# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-08-29

### Added

* @luckylittle Added: spell-check workflow ea9ef6a2d64d9cfff27a2be7d2fc49f8317dc811
* @luckylittle Added: terraform.tf to tests for easier testing 79469102b8501541dc19cc792f3acf1053a6ee58
* @luckylittle Added: tfstate.lock.info to .gitignore 7a6e064ed328c19a85b9fe5646ba5cc343bb8144

### Fixed

* @luckylittle Bugfix: Added qBt cache removal to panic b0e21d5a5515dc65ae12677c5ed6cc84cd4ca531

### Changed

* @luckylittle Updated: .gitignore a9c67dc6f6a8634a89c7625f214186fdf451144c
* @luckylittle Updated: ansible-lint runs-on bda8507ff84f3944181b2113db05906990f02bd8
* @luckylittle Updated: README.md 87ac249077279e3999f4ddc4625623843624dd27

## [0.1.1] - 2025-08-28

### Fixed

* @luckylittle Bugfix: panic.sh incorrect netronome

## [0.1.0] - 2025-08-27

### Added

* @luckylittle Added: automatic latest version
* @luckylittle Added: automatic latest version (try 2)
* @luckylittle Added: metronome agent
* @luckylittle Added: netronome
* @luckylittle Added: netronome smoke_test

### Fixed

* @luckylittle Bugfix: ansible-lint doesn't make use of collection installed for the...
* @luckylittle Bugfix: journald typo
* @luckylittle Bugfix: metronome_cfg_port not defined
* @luckylittle Bugfix: Missed vnstat service
* @luckylittle Bugfix: netronome_ver is undefined
* @luckylittle Bugfix: removing "v" from the version
* @luckylittle Bugfix: vnstat from Fedora repo must have disable_gpg_check
* @luckylittle Bugfix: wrong indentation

### Changed

* @luckylittle Update: agent.toml logging and api_key
* @luckylittle Update: cross-seed default now
* @luckylittle Update: line too long
* @luckylittle Update: minor change in the sshd config variable
* @luckylittle Update: netronome-agent service ProtectHome
* @luckylittle Update: README

### Removed

* @luckylittle Removed: _ver from defaults/main.yml and README
* @luckylittle Removed: http_port_t labeling

## [0.0.1] - 2025-08-26

### Added

* @luckylittle Rebranding to qBt

### Changed

* @luckylittle Rebranding to qBt

### Fixed

* @luckylittle Rebranding to qBt
