[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-logs)
[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-logs.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-logs)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-logs.svg)](http://badge.fury.io/rb/sensu-plugins-logs)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-logs)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-logs.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-logs)

## Sensu Plugins Logs Plugin

- [Overview](#overview)
- [Files](#files)
- [Usage examples](#usage-examples)
- [Configuration](#configuration)
  - [Sensu Go](#sensu-go)
    - [Asset registration](#asset-registration)
    - [Asset definition](#asset-definition)
    - [Check definition](#check-definition)
  - [Sensu Core](#sensu-core)
    - [Check definition](#check-definition)
- [Installation from source](#installation-from-source)
- [Additional notes](#additional-notes)
- [Contributing](#contributing)

### Overview

This plugin provides native instrumentation for monitoring log files or system logs via journald for regular expressions and a Sensu handler for logging Sensu events to log files.

### Files
 * bin/check-journal.rb
 * bin/check-log.rb
 * bin/handler-logevent.rb
 * bin/handler-show-event-config.rb
 
**check-journal**
Checks the systemd journal (`journald`) for a pattern.

**check-log**
Checks a log file for a regular expression, skipping lines that have already been read. Stores the number of bytes read and seeks to that position next time (instead of making a backup copy of the whole log file). 

**handler-logevent**
Logs last `settings['logevent']['keep']` JSON events in files as `settings['logevent']['eventdir']/client/check_name/timestamp.action`.

**handler-show-event-config**
Lists the handler's config and the event it read.

## Usage examples

### Help

**check-journal.rb**
```
Usage: check-journal.rb (options)
    -c, --critical COUNT             Number of matches to consider a critical issue.
    -j "ARGS1 ARGS2 ...",            Pass additional arguments to journalctl, eg: "-u nginx.service"
        --journalctl_args
    -q, --pattern PAT                Pattern to search for
    -s, --since TIMESPEC             Query journal entries on or newer than the specified date/time.
    -v                               Verbose output. Helpful for debugging the plugin.
    -w, --warning COUNT              Number of matches to consider a warning    
```

**handler-logevent.rb**
```
Usage: handler-logevent.rb (options)
        --map-go-event-into-ruby     Enable Sensu Go to Sensu Ruby event mapping. Alternatively set envvar SENSU_MAP_GO_EVENT_INTO_RUBY=1.

```

## Configuration
### Sensu Go
#### Asset registration

Assets are the best way to make use of this plugin. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the asset: 

`sensuctl asset add sensu-plugins/sensu-plugins-logs`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai asset index page](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-logs).

#### Asset definition

```yaml
---
type: Asset
api_version: core/v2
metadata:
  name: sensu-plugins-logs
spec:
  url: https://assets.bonsai.sensu.io/9ba6c6b27b5ca36538de3a13f014718ead3a1215/sensu-plugins-logs_4.0.0_centos_linux_amd64.tar.gz
  sha512: 4e29c549924b5df01c7a8e0ed105659b3e9e81ca5c919548efd03a2ccaaf83d8605130ab80132e93db6f5e25c7acddbd7f6e8c6d185567eb5f73cd420dcc2f06
```

#### Check definition

```yaml
---
type: CheckConfig
spec:
  command: "check-journal.rb"
  handlers: []
  high_flap_threshold: 0
  interval: 10
  low_flap_threshold: 0
  publish: true
  runtime_assets:
  - sensu-plugins/sensu-plugins-logs
  - sensu/sensu-ruby-runtime
  subscriptions:
  - linux
```

#### Handler definition

**handler-logevent**
```
{
  "logevent": {
    "eventdir": "/var/log/sensu/events",
    "keep": 10
  }
}
```

### Sensu Core

#### Check definition
```json
{
  "checks": {
    "check-journal": {
      "command": "check-journal.rb",
      "subscribers": ["linux"],
      "interval": 10,
      "refresh": 10,
      "handlers": ["influxdb"]
    }
  }
}
```

## Installation from source

### Sensu Go

See the instructions above for [asset registration](#asset-registration).

### Sensu Core

Install and setup plugins on [Sensu Core](https://docs.sensu.io/sensu-core/latest/installation/installing-plugins/).

## Additional notes

### Sensu Go Ruby Runtime Assets

The Sensu assets packaged from this repository are built against the Sensu Ruby runtime environment. When using these assets as part of a Sensu Go resource (check, mutator, or handler), make sure to include the corresponding [Sensu Ruby Runtime Asset](https://bonsai.sensu.io/assets/sensu/sensu-ruby-runtime) in the list of assets needed by the resource.

### Use this plugin with Sensu Go

To use the included handlers with Sensu Go, use the `--map-go-event-into-ruby` argument or set environment variable `SENSU_MAP_GO_EVENT_INTO_RUBY=1`.

Make sure the required handler configuration JSON exists under `/etc/sensu/conf.d/` or at a path in the colon-separated list of files in the environment variable `SENSU_CONFIG_FILES`.

## Contributing

See [CONTRIBUTING.md](https://github.com/sensu-plugins/sensu-plugins-logs/blob/master/CONTRIBUTING.md) for information about contributing to this plugin.
