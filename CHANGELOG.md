# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-02-04

### Added

* @luckylittle feat(ai): Closes #24 1439fc7
* @luckylittle feat(chore): Updated runbook in PR template 8b3bb06
* @luckylittle feat(docs): Added sfvbrr to PR template checklist 92ceba2
* @luckylittle feat(docs): Updated CONTRIBUTING.md 3acaa79
* @luckylittle feat(docs): Updated CONTRIBUTING.md d7873fd
* @luckylittle feat(qui,sfvbrr): Added new vars for these two tools a318231
* @luckylittle feat(qui): Closes #20 cfd0eee
* @luckylittle feat(rhel10): Changed default TZ baff01d
* @luckylittle feat(rhel10): Closes #22 b822877
* @luckylittle feat(rhel10): Initial refactor c5d3708
* @luckylittle feat(sfvbrr): Closes #23 9aec73e
* @luckylittle fix(vsftpd): Added example users.txt 7ac7f66

### Fixed

* @luckylittle fix(cleanup): Gracefully continue when packages not installed 2cc862a
* @luckylittle fix(cleanup): Renamed identical task for better differentiation c4aab4d
* @luckylittle fix(common): Improved task names and change_when detection for tuned 4ee1a84
* @luckylittle fix(docs): Missing qui in smoke_tests 86b6fef
* @luckylittle fix(preflight): Better handling of the role path 58a1bba
* @luckylittle fix(reboot): Service name vars moved to main.yml d0b3077
* @luckylittle fix(sec): Notify firewalld reload for all related tasks 7c4d300
* @luckylittle fix(selinux): Closes #21 83e7680
* @luckylittle fix(sfvbrr): Automatically generate presets instead 4cdcf4d
* @luckylittle fix(smoke_tests): Typo 009ebf2
* @luckylittle fix(tools): Backup re-enabled for 4.4, 4.5, 4.6 ded6654
* @luckylittle fix(tools): failed opening custom definitions directory deca4b8
* @luckylittle fix(tools): Typo in command f3e7134
* @luckylittle fix(vsftpd): Add disable_gpg_check 990695d
* @luckylittle fix(vsftpd): Separate EPEL GPG should not be required 47b915b
* @luckylittle fix(workflow): passing YamlLint 36f85bc

### Changed

* @luckylittle chore(bench): Updated to the latest 3738fca
* @luckylittle docs(readme) Updated 2026-02-04 e1763ed
* @luckylittle docs(readme): Add Excalidraw source cd2604a
* @luckylittle docs(readme): Added Qui 0a5fab7
* @luckylittle docs(readme): Updated 2026-02-03 c4b3494
* @luckylittle docs(readme): Updated 2026-02-04 f8aaa1a
* @luckylittle docs(readme): Updated diagram and location 121286f

### Removed

* @luckylittle fix(cross): Removed unused var 39a85ff
* @luckylittle chore(tools): Removed unused baseUrl from AutoBrr f9ee2c6

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
