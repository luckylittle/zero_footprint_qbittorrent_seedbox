#### What is the relevant ticket/issue?
*

#### What’s this PR do?
##### Add
*
##### Change
*
##### Remove
*

#### Does the PR pass all of the below rules?

##### GENERAL RULES

- [] all files passing yamllint `1.37.1^`
- [] all files passing ansible-lint `6.22.2^`
- [] all files passing codespell `2.4.1^`
- [] all templates/files have "Ansible managed" header
- [] all tasks are properly tagged
- [] all tasks have versions for identification purpose(s)

##### 0. PREFLIGHT

- [] fails when `ipv4_whitelist` is not configured
- [] fails if not `single_user` and `users.txt` is empty
- [] display `GRUB_CMDLINE_LINUX` if it contains crashkernel other than `no`

##### 1. COMMON

- [] all packages are up to date
- [] timezone is set correctly
- [] DNS servers are set correctly (Optional)
- [] directory structure is created
- [] MOTDs are removed
- [] systemd limits are set
- [] sysctl tunables are set (when `true`)
- [] `/home` is remounted with noatime and nodiratime
- [] tuned is installed and latency-performance profile is set

##### 2. QBT

- [] config is in place
- [] categories are in place
- [] static nox is installed
- [] all the options are as expected
- [] all advanced options are as expected
- [] can you download?
- [] can you change the category and the path changes as well?

##### 3. VSFTPD

- [] openssl cert is in place with the right options
- [] config is in place
- [] if `users.txt` is used, all users can log in
- [] unnecessary file(s) removed
- [] pam config is in place
- [] you can transfer data

##### 4. TOOLS

- [] autobrr installed
- [] autobrr config in place
- [] autobrr service in place
- [] tqm installed
- [] tqm can execute
- [] tqm config in place
- [] autobrrctl can execute
- [] sizechecker can execute
- [] mkbrr can execute
- [] `upgrade_autobrr.sh` in place and working
- [] `panic.sh` in place and working
- [] `bench.sh` in place and working
- [] cross-seed installed (Optional)
- [] cross-seed config in oplace
- [] cross-seed service in place
- [] cross-seed responds to a local webhook
- [] when qbt finishes download, cross-seed is notified via webhook
- [] unnecessary file(s) removed

##### 5. SECURITY

- [] selinux enforcing
- [] all `/usr/local/bin` can execute
- [] autobrr port is labeled
- [] firewalld is running and enabled
- [] connection from the internet on `qbt_port` is allowed
- [] connection from the internet on any other port is not allowed
- [] connection from any `ipv4_whitelist` address is working
- [] sshd config is templated
- [] shell history is disabled
- [] sudo is restricted to only some commands

##### 6. CLEANUP

- [] unnecessary package(s) removed
- [] `/home` folder is clean
- [] journald storage is volatile
- [] journald config is tuned
- [] any possible logging is disabled
- [] logrotate is removed, but vsftpd still works
- [] all `/var/log` files are symlinks to black hole
- [] unnecessary service(s) removed
- [] dnf cache is empty

##### 7. REBOOT

- [] all services are enabled
- [] machine is rebooted
- [] machine is responsive upon reboot

##### 8. SMOKE_TESTS

- [] active/inactive/running/stopped/unknown services are displayed
- [] check sshd port is open from the ansible control plane
- [] check vsftpd port is open from the ansible control plane
- [] check qbt port is open from the ansible control plane
- [] check qbt webui port is open from the ansible control plane
- [] check autobrr webui port is open from the ansible control plane
- [] check autobrr healthcheck port is open from the ansible control plane
- [] check cros-seed port is open on the managed node and webhook responding
- [] check the results are displayed correctly
- [] check the journald for any errors

#### Where should the reviewer start?
*

#### How should this be manually tested?
*

#### Risk involved?
*

#### Screenshots (if appropriate):
*

#### Does the documentation or dependencies need an update?
*
