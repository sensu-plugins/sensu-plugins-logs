#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...HEAD
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.1...0.0.3
