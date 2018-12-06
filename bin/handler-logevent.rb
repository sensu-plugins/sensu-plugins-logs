#!/usr/bin/env ruby
#
# This handler logs last settings['logevent']['keep'] json events in files as
# settings['logevent']['eventdir']/client/check_name/timestamp.action
#
# Copyright 2013 Piavlo <lolitushka@gmail.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE for details.

require 'sensu-handler'
require 'fileutils'
require 'json'

class LogEvent < Sensu::Handler
  def handle
    event_action = @event['action']
    event_action ||= 'unknown'
    check_name = @event['check']['name'] if (@event.include? 'check') && (@event['check'].include? 'name')
    check_name ||= 'unknown'
    client_name = @event['client']['name'] if (@event.include? 'client') && (@event['client'].include? 'name')
    client_name ||= 'unknown'
    check_executed = @event['check']['executed'] if (@event.include? 'check') && (@event['check'].include? 'executed')
    check_executed ||= 'unknown'
    dir_stub = settings['logevent']['eventdir'] if (settings.include? 'logevent') && (settings['logevent'].include? 'eventdir')
    puts settings
    raise 'logevent eventdir setting is missing' unless dir_stub

    eventdir = "#{settings['logevent']['eventdir']}/#{client_name}/#{check_name}"
    FileUtils.mkdir_p(eventdir)

    File.open("#{eventdir}/#{check_executed}.#{event_action}", 'w') do |f|
      f.write(JSON.pretty_generate(@event))
    end

    events = Dir.glob("#{eventdir}/*.#{event_action}")
    # #YELLOW
    if settings['logevent']['keep'] < events.length # rubocop:disable GuardClause
      FileUtils.rm_f(events.sort.reverse.shift(settings['logevent']['keep']))
    end
  end
end
