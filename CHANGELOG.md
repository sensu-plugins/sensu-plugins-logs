# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

### Breaking Changes
- remove support for ruby versions `< 2.3.0` (@jspaleta)

### Added
- updated to use sensu-plugin 2.7 with 2.x to 1.x migration option (@jspaleta)


### Fixed
- check-log.rb: pattern is now required via option config
- check-log.rb: update descriptions of crit and warn options

## [1.3.1] - 2017-10-09
### Fixed
- check-log.rb: added `File::TRUNC` option to the state file to address scenerios where files were written to often and rotated which caused the offset to be wrong. This caused high diskio as it was trying to seek to a part of a non existent file or past the correct location in the file. (@georgespatton)

## [1.3.0] - 2017-09-23
### Added
- check-log.rb: `return-error-limit` option to limit the number of returned matched lines (log entries) (@jhshadi)

## [1.2.1] - 2017-09-23
### Added
- ruby 2.4 testing (@majormoses)

### Fixed
- Fixed unhandled encoding exception when using the `log-pattern` option (@jhshadi)
- PR template spelling "compatibility"

### Changed
- updated CHANGELOG guidelines location (@majormoses)

## [1.2.0] - 2017-07-04
### Added
- Support of UTF16 encoded characters (@avoosh)

## [1.1.2] - 2017-05-25
### Fixed
- Write the state file atomically by using flock where available (@nlopes)

## [1.1.1] - 2017-05-21
### Changed
- `check-log.rb`: Fix 'crit' and 'warn' flags being ignored in search_log (@avifried1)

## [1.1.0] - 2017-05-20
### Added
- Add `return-length` option to support custom length for returned matched lines (@jhshadi)
- Add `log-pattern` option to support read and match against whole log entry instead of single line (@jhshadi)

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/2.0.0...HEAD
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.3.1...2.0.0
[1.3.1]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.2.2...1.2.0
[1.1.2]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/1.0.0...1.1.0
[0.0.4]:
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.4...1.0.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/0.0.2...0.0.3
