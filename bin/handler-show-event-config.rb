#!/usr/bin/env ruby
# frozen_string_literal: false

#
# This handler just spits out its config and the event it read.
#
# Copyright 2011 Sonian, Inc <chefs@sonian.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'sensu-handler'

class Show < Sensu::Handler
  def handle
    puts 'Settings: ' + settings.to_hash.inspect
    puts 'Event: ' + @event.inspect
  end
end
