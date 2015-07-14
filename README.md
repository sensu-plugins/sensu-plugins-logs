## Sensu-Plugins-logs

[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-logs.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-logs)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-logs.svg)](http://badge.fury.io/rb/sensu-plugins-logs)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-logs.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-logs)
[ ![Codeship Status for sensu-plugins/sensu-plugins-logs](https://codeship.com/projects/85800600-e95b-0132-81a4-7e47788fdd48/status?branch=master)](https://codeship.com/projects/82942)

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

[Installation and Setup](https://github.com/sensu-plugins/documentation/blob/master/user_docs/installation_instructions.md)

## Notes
