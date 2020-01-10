# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

### Added
- Updated asset build targets to support centos6
- Removed centos from bonsai asset definition

## [4.0.0] - 2019-05-07
### Breaking Changes
- Bump `sensu-plugin` dependency from `~> 3.0` to `~> 4.0` you can read the changelog entries for [4.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#400---2018-02-17), [3.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#300---2018-12-04), and [2.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29)

### Added
- Travis build automation to generate Sensu Asset tarballs that can be used n conjunction with Sensu provided ruby runtime assets and the Bonsai Asset Index
- Require latest sensu-plugin for [Sensu Go support](https://github.com/sensu-plugins/sensu-plugin#sensu-go-enablement)


## [3.0.0] - 2018-12-15
### Breaking Changes
- updated to use sensu-plugin 3.0 with Sensu Go to Sensu Core 1.x migration option

### Changes
- Update handler-logevent.rb to gracefully handle missing check and client definitions in events.  Missing attributes will use 'unknown' fallback strings so that malformed events will still be captured in the event logging directory structure instead of erroring out.  Useful for diagnosing problems with malformed events when migrating to Sensu Go. (@jspaleta)

### Added
- add ruby 2.5.1 into travis automation (@jspaleta)

### Fixed
- add rdoc to development dependancy to fix rake task errors ruby 2.5.1 (@jspaleta) (@dependabot)
- update dev dep for github-markup (@jspaleta) (@dependabot)
- update dev dep for codeclimate-test-reporter (@jspaleta) (@dependabot)
- update dev dep for serverspec (@jspaleta) (@dependabot)
- update dev dep for mixlib-shellout (@jspaleta) (@dependabot)
- update dev dep for rubocop (@jspaleta) (@dependabot)

## [2.0.0] - 2018-09-30
### Breaking Changes
- remove support for ruby versions `< 2.3.0` (@jspaleta)

### Added
- updated to use sensu-plugin 2.7 with 2.x to 1.x migration option (@jspaleta)


### Fixed
- check-log.rb: pattern is now required via option config (@cgeers)
- check-log.rb: update descriptions of crit and warn options (@cgeers)

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/4.0.0...HEAD
[4.0.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/3.0.0...4.0.0
[3.0.0]: https://github.com/sensu-plugins/sensu-plugins-logs/compare/2.0.0...3.0.0
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
