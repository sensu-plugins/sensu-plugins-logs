## Sensu-Plugins-logs

[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-logs.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-logs)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-logs.svg)](http://badge.fury.io/rb/sensu-plugins-logs)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-logs.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-logs)

## Functionality

## Files
 * bin/check-journal.rb
 * bin/check-log.rb
 * bin/handler-logevent.rb
 * bin/handler-show-event-config.rb

## Usage

**handler-logevent**
```
{
  "logevent": {
    "eventdir": "/var/log/sensu/events",
    "keep": 10
  }
}
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes
To use included handlers with Sensu Go, use `--map-go-event-into-ruby` argument or set environment variable `SENSU_MAP_GO_EVENT_INTO_RUBY=1`
