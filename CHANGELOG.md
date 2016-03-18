#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Added
- Added option to ignore matched files based on given Regex - check-log.rb
- Added option to set line limit on the return message for each file matched - check-log.rb
- Added inode tracking for log files - check-log.rb

### Changed
- Returned lines now include the file name - check-log.rb
- Refactored code into methods - check-log.rb
- Fixed rubocop errors - check-log.rb
- Now opens state files as read/write so new files have write access - check-log.rb

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...HEAD
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.1...0.0.3
