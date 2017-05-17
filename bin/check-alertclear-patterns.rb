#!/usr/bin/env ruby
#
# Check Alert/Clear Patterns plugin
# ===
# This plugin will read a log file and raise an alert on each line matching
# #{pattern_alert}. This same alert will be cleared only when a new line
# is found by matching #{pattern_clear}. Alert/Clear relationship is based on
# a subpart of both lines, using #{pattern_identifier} regexp to extract the id
#
# This plugin checks a log file, skipping lines that have already been read,
# like Nagios's check_log. However, instead of making a backup copy of the
# whole log file (very slow with large logs), it stores the number of bytes
# read, and seeks to that position next time.
#
# ===
# Example:
# Log file content:
# 16:00: lost connection to database PRIMARY
# 16:01: lost connection to database SECONDARY
# 16:20: connected to database PRIMARY
#
# Options will be:
# -A "lost connection"
# -C "connected to"
# -I "database (.*)"
#
# Sensu events generated will be:
# {"check": {"name":"PRIMARY",  "status": 2, "output": "CRITICAL: 16:00: lost connection to database PRI01"} }
# {"check": {"name":"SECONDARY","status": 2, "output": "CRITICAL: 16:01: lost connection to database PRI02"} }
# {"check": {"name":"PRIMARY",  "status": 0, "output": "OK: 16:20: connected to database PRI01"} }
#
# ===
# Copyright 2014 Thomson Reuters, Jonathan Huot <jonathan.huot@thomsonreuters.com>
# Copyright 2011 Sonian, Inc <chefs@sonian.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'fileutils'
require 'json'
require 'socket'
require 'time'

class CheckLog < Sensu::Plugin::Check::CLI

  BASE_DIR = '/var/cache/check-log'

  option :state_auto,
         :description => "Set state file dir automatically using name",
         :short => '-n NAME',
         :long => '--name NAME',
         :proc => proc { |arg| "#{BASE_DIR}/#{arg}" }

  option :state_dir,
         :description => "Dir to keep state files under",
         :short => '-s DIR',
         :long => '--state-dir DIR',
         :default => "#{BASE_DIR}/default"

  option :log_file,
         :description => "Path to log file",
         :short => '-f FILE',
         :long => '--log-file FILE'

  option :pattern_alert,
         :description => "Pattern to create alert",
         :short => '-A PAT',
         :long => '--pattern-alert PAT'

  option :pattern_clear,
         :description => "Pattern to clear alert",
         :short => '-C PAT',
         :long => '--pattern-clear PAT'

  option :pattern_identifier,
         :description => "Pattern regex to extract alert name from alert log line",
         :short => '-I PAT',
         :long => '--pattern-identifier PAT'

  option :encoding,
         :description => "Explicit encoding page to read log file with",
         :short => '-e ENCODING-PAGE',
         :long => '--encoding ENCODING-PAGE'

  option :only_warn,
         :description => "Warn instead of critical on match",
         :short => '-o',
         :long => '--warn-only',
         :boolean => true

  option :handler,
         :short => '-h HANDLER',
         :long => '--handler HANDLER',
         :default => 'default'

  option :extra_event_args,
         :description => "Add extra arguments to the event data created. Format is JSON",
         :short => '-x ARGS',
         :long => '--extra-event-args ARGS'

  option :case_insensitive,
         :description => "Run a case insensitive match",
         :short => '-i',
         :long => '--icase',
         :boolean => true,
         :default => false

  option :file_pattern,
         :description => "Check a pattern of files, instead of one file",
         :short => '-F FILE',
         :long => '--filepattern FILE'

  option :static_checkId,
         :description => "Static content, that is needed on the check_Id",
         :short => '-P STATIC_CHECK_ID',
         :long => '--staticcheckid STATIC_CHECK_ID'

  option :verbose,
         :short => '-v',
         :long => "--verbose",
         :boolean => true,
         :default => false

  option :dry_run,
         :short => '-d',
         :long => "--dry-run",
         :boolean => true,
         :default => false

  def run
    unknown "No log file specified" unless config[:log_file] || config[:file_pattern]
    file_list = []
    file_list << config[:log_file] if config[:log_file]
    if config[:file_pattern]
      dir_str = config[:file_pattern].slice(0, config[:file_pattern].to_s.rindex('/'))
      file_pat = config[:file_pattern].slice((config[:file_pattern].to_s.rindex('/') + 1), config[:file_pattern].length)
      Dir.foreach(dir_str) do |file|
        if config[:case_insensitive]
          file_list << "#{dir_str}/#{file}" if file.to_s.downcase.match(file_pat.downcase)
        else
          file_list << "#{dir_str}/#{file}" if file.to_s.match(file_pat)
        end
      end
    end
    file_list.each do |log_file|
      begin
        open_log log_file
      rescue => e
        unknown "Could not open log file: #{e}"
      end
      search_log
    end
  end

  def open_log(log_file)
    state_dir = config[:state_auto] || config[:state_dir]

    # Opens file using optional encoding page. ex: 'iso8859-1'
    if config[:encoding]
      @log = File.open(log_file, "r:#{config[:encoding]}")
    else
      @log = File.open(log_file)
    end

    @state_file = File.join(state_dir, File.expand_path(log_file))
    @bytes_to_skip = begin
      File.open(@state_file) do |file|
        file.readline.to_i
      end
    rescue
      0
    end
  end

  def sensu_client_socket(msg)
    u = UDPSocket.new
    if not config[:dry_run]
      u.send(msg + "\n", 0, '127.0.0.1', 3030)
    elsif config[:verbose]
      puts "UDP: <#{msg}>"
    end
  end

  def send_event(check_name, status, msg)
    puts "send_event: <#{check_name}><#{msg}>" if config[:verbose]

    d = {'name' => check_name, 'status' => status, 'output' => msg}
    if config[:extra_event_args]
      # Will allow below options to works:
      # -h 'default,mailer' -x '{"mail_to":["x.y@z.com,a.b@c.com"], "another_one":"value"}'
      parsed = JSON.parse(config[:extra_event_args])
      d = parsed.merge(d)
    end
    sensu_client_socket d.to_json
  end

  def send_ok(check_name, msg)
    send_event check_name, 0, 'OK: ' + msg
  end

  def send_warning(check_name, msg)
    send_event check_name, 1, 'WARNING: ' + msg
  end

  def send_critical(check_name, msg)
    if config[:only_warn]
      send_warning check_name, msg
    else
      send_event check_name, 2, 'CRITICAL: ' + msg
    end
  end

  def extract_identifier(line)
    id = line[/#{config[:pattern_identifier]}/, 1]
    id = id ? id : "#{Time.now.utc.iso8601}.#{Time.now.utc.tv_usec}"
    # sensu checkname is a bit restrictive. it must match  check[:name] =~ /^[\w\.-]+$/ (from lib/sensu/socket.rb:27)
    #TORN-1883
    if config[:static_checkId]
      id = config[:static_checkId] + '-' + id
    end
    id.gsub(/[+ ]/i, '-').gsub(/:/i, '.').gsub(/[^0-9a-z\-\.]/i, '')
  end

  def search_log
    log_file_size = @log.stat.size
    if log_file_size < @bytes_to_skip
      @bytes_to_skip = 0
    end
    bytes_read = 0
    if @bytes_to_skip > 0
      @log.seek(@bytes_to_skip, File::SEEK_SET)
    end
    @log.each_line do |line|
      bytes_read += line.size
      if not config[:pattern_alert]
        b = line
      elsif config[:case_insensitive]
        b = line.downcase.match(config[:pattern_alert].downcase)
      else
        b = line.match(config[:pattern_alert])
      end
      if b
        send_critical extract_identifier(line), line
      elsif config[:pattern_clear]
        if config[:case_insensitive]
          e = line.downcase.match(config[:pattern_clear].downcase)
        else
          e = line.match(config[:pattern_clear])
        end
        if e
          send_ok extract_identifier(line), line
        end
      end
    end
    FileUtils.mkdir_p(File.dirname(@state_file))
    File.open(@state_file, 'w') do |file|
      file.write(@bytes_to_skip + bytes_read)
    end
    ok
  end

end
