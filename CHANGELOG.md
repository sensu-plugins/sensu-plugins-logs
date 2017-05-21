#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Changed
- `check-log.rb`: Fix 'crit' and 'warn' flags being ignored in search_log

## [1.1.0] - 2017-05-20
### Added
- Add `return-length` option to support custom length for returned matched lines
- Add `log-pattern` option to support read and match against whole log entry instead of single line

## [1.0.0] - 2017-03-07
### Fixed
- `check-log.rb`: Drop non-ASCII chars from log line (@vlinevich)
- `check-log.rb`: Fix return content to have matched line (@saka-shin)

### Changed
- Upgrade to Rubocop 0.40 and cleanup (@eheydrick)

### Added
- Ruby 2.3 support

### Removed
- Ruby 2.0 and older support (@eheydrick)

## [0.0.4] - 2016-03-12
### Removed
- Remove dependency on the fileutils gem

## [0.0.3] - 2015-10-22
### Changed
- updated sensu-plugin gem to 1.2.0
- multibyte fix

### Removed
- Remove JSON gem dep that is not longer needed with Ruby 1.9+

## [0.0.1] - 2015-06-04

### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.1.0...HEAD
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.0.0...1.1.0
[0.0.4]:
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...1.0.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.2...0.0.3
