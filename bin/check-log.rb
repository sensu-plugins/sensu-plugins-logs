#! /usr/bin/env ruby
#
#   check-log
#
# DESCRIPTION:
#   This plugin checks a log file, or collection of log files matching
#   a pattern, for a regular expression, skipping lines that have
#   already been read, like Nagios's check_log. However, instead
#   of making a backup copy of the whole log file (very slow with large
#   logs), it stores the number of bytes read, and seeks to that position
#   next time.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   #YELLOW
#
# EXAMPLES:
#   Returns matched lines, searches all files containing "logfile",
#   ignores all .gz files, searches for "ERROR" in each line,
#   returns a max of 4 matched lines in output
#
#   check-log.rb -r -F "logfile" -q "ERROR" -X "^.+\.gz$" -t 4
# LICENSE:
#   Copyright 2011 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'fileutils'
require 'English'

class CheckLog < Sensu::Plugin::Check::CLI
  BASE_DIR = '/var/cache/check-log'.freeze

  option :state_auto,
         description: 'Set state file dir automatically using name',
         short: '-n NAME',
         long: '--name NAME',
         proc: proc { |arg| "#{BASE_DIR}/#{arg}" }

  option :state_dir,
         description: 'Dir to keep state files under',
         short: '-s DIR',
         long: '--state-dir DIR',
         default: "#{BASE_DIR}/default"

  option :log_file,
         description: 'Path to log file',
         short: '-f FILE',
         long: '--log-file FILE'

  option :pattern,
         description: 'Pattern to search for',
         short: '-q PAT',
         long: '--pattern PAT'

  option :exclude,
         description: 'Pattern to exclude from log line matching',
         short: '-E PAT',
         long: '--exclude PAT',
         proc: proc { |s| Regexp.compile s },
         default: /(?!)/

  option :exclude_file,
         descprtion: 'Pattern to exclude from file matching',
         short: '-X PAT',
         long: '--exclude_file PAT',
         proc: proc { |s| Regexp.compile s },
         default: /(?!)/

  option :encoding,
         description: 'Explicit encoding page to read log file with',
         short: '-e ENCODING-PAGE',
         long: '--encoding ENCODING-PAGE'

  option :warn,
         description: 'Warning level if pattern has a group',
         short: '-w N',
         long: '--warn N',
         proc: proc(&:to_i)

  option :crit,
         description: 'Critical level if pattern has a group',
         short: '-c N',
         long: '--crit N',
         proc: proc(&:to_i)

  option :only_warn,
         description: 'Warn instead of critical on match',
         short: '-o',
         long: '--warn-only',
         boolean: true

  option :case_insensitive,
         description: 'Run a case insensitive match',
         short: '-i',
         long: '--icase',
         boolean: true,
         default: false

  option :file_pattern,
         description: 'Check a pattern of files, instead of one file',
         short: '-F FILE',
         long: '--filepattern FILE'

  option :return_content,
         description: 'Return matched line',
         short: '-r',
         long: '--return',
         boolean: true,
         default: false

  option :return_threshold,
         desciption: 'Set maximum number of returned lines for each file, if -r specified',
         short: '-t N',
         long: '--return_t N',
         proc: proc(&:to_i),
         default: 50

  def run
    unknown 'No log file specified' unless config[:log_file] || config[:file_pattern]
    unknown 'No pattern specified' unless config[:pattern]

    file_list = load_file_list
    n_warns_overall, n_crits_overall, accumulative_error = search_files file_list

    if config[:return_content]
      error_overall = accumulative_error
    end

    message "#{n_warns_overall} warnings, #{n_crits_overall} criticals for pattern #{config[:pattern]}. #{error_overall}"

    if n_crits_overall > 0
      critical
    elsif n_warns_overall > 0
      warning
    else
      ok
    end
  end

  # Populates the file list based on log_file name or pattern provided
  # Return: matched file or list of files, nil if none found
  def load_file_list
    file_list = []
    file_list << config[:log_file] if config[:log_file]

    if config[:file_pattern]
      dir_str = config[:file_pattern].slice(0, config[:file_pattern].to_s.rindex('/'))
      file_pat = config[:file_pattern].slice((config[:file_pattern].to_s.rindex('/') + 1), config[:file_pattern].length)
      Dir.foreach(dir_str) do |file|
        if config[:case_insensitive]
          file_list << "#{dir_str}/#{file}" if file.to_s.downcase.match(file_pat.downcase) && \
                                               !file.to_s.downcase.match(config[:exclude_file])
        else
          file_list << "#{dir_str}/#{file}" if file.to_s.match(file_pat) && \
                                               !file.to_s.match(config[:exclude_file])
        end
      end
    end
    file_list
  end

  # Processes list of log files, passes each to the search_log method
  # Input: file_list, a list of one or more file names
  # Return: total warnings, total criticals, and total error messages for the file list
  def search_files(file_list)
    n_warns_overall = 0
    n_crits_overall = 0
    overall_error = ''

    file_list.each do |log_file|
      begin
        open_log log_file
      rescue => e
        unknown "Could not open log file: #{e}"
      end
      n_warns, n_crits, accumulative_error = search_log log_file
      n_warns_overall += n_warns
      n_crits_overall += n_crits
      overall_error += accumulative_error
    end

    [n_warns_overall, n_crits_overall, overall_error]
  end

  # Opens the given log file, reads its state file to get the bytes to skip and inode number
  # Input: a single log file
  def open_log(log_file)
    state_dir = config[:state_auto] || config[:state_dir]

    # Opens file using optional encoding page.  ex: 'iso8859-1'
    @log = if config[:encoding]
             File.open(log_file, "r:#{config[:encoding]}")
           else
             File.open(log_file)
           end

    @state_file = File.join(state_dir, File.expand_path(log_file).sub(/^([A-Z]):\//, '\1/'))

    @inode = begin
      File.open(@state_file, 'r+') do |file|
        file.readline.each_line(':').to_a[0].to_i
      end
    rescue
      @log.stat.ino
    end

    @bytes_to_skip = begin
      File.open(@state_file, 'r+') do |file|
        file.readline.each_line(':').to_a[1].to_i
      end
    rescue
      0
    end
  end

  # Checks for a match, if found it records the line message and severity (critical default)
  # Input: a single log file, the match_data, and the text line matched
  # Return: A count of warnings/criticals, and error string
  def process_match(log_file, match, line)
    n_warns = 0
    n_crits = 0
    error = ''

    if match
      error = "\n" + log_file + ': ' + line.slice(0, 250) unless config[:return_threshold] && \
                                                                 $INPUT_LINE_NUMBER > config[:return_threshold]
      if match[1]
        if config[:crit] && match[1].to_i > config[:crit]
          n_crits = 1
        elsif config[:warn] && match[1].to_i > config[:warn]
          n_warns = 1
        end
      else
        if config[:only_warn]
          n_warns = 1
        else
          n_crits = 1
        end
      end
    end
    [n_warns, n_crits, error]
  end

  # Searches the open log file for the provided pattern, skipping previously read bytes
  # Input: a single log file
  # Return: number of warnings found, number of criticals found, error string for all errors found
  def search_log(log_file)
    log_file_size = @log.stat.size
    inode = @log.stat.ino
    @bytes_to_skip = 0 if log_file_size < @bytes_to_skip || inode != @inode
    bytes_read = 0
    n_warns_overall = 0
    n_crits_overall = 0
    error_overall = ''

    @log.seek(@bytes_to_skip, File::SEEK_SET) if @bytes_to_skip > 0
    # #YELLOW
    @log.each_line do |line|
      bytes_read += line.bytesize
      if config[:case_insensitive]
        match = line.downcase.match(config[:pattern].downcase) unless line.match(config[:exclude])
      else
        match = line.match(config[:pattern]) unless line.match(config[:exclude])
      end
      n_warns, n_crits, error = process_match(log_file, match, line)
      n_warns_overall += n_warns
      n_crits_overall += n_crits
      error_overall += error
    end

    # Update state file with bytes read
    FileUtils.mkdir_p(File.dirname(@state_file))
    File.open(@state_file, 'w') do |file|
      file.write("#{inode}:#{@bytes_to_skip + bytes_read}")
    end
    [n_warns_overall, n_crits_overall, error_overall]
  end

  private :load_file_list, :search_files, :open_log, :process_match, :search_log
end
