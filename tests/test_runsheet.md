# TEST RUNSHEET

## 0. PREFLIGHT

- [ ] PREFLIGHT | 0.1 Ensure 'fail2ban_ignore_ipv4' does not contain
- [ ] PREFLIGHT | 0.2 Get status of local users.txt file for vsftpd
- [ ] PREFLIGHT | 0.3 Ensure users.txt exists and is not empty for
- [ ] PREFLIGHT | 0.4 Read GRUB content
- [ ] PREFLIGHT | 0.5 Select the relevant line
- [ ] PREFLIGHT | 0.6 Warn if crashkernel is undesirable
- [ ] PREFLIGHT | 0.7 Display GRUB_CMDLINE_LINUX

## 1. COMMON

- [ ] COMMON | 1.1 Upgrade all existing packages
- [ ] COMMON | 1.2 Set timezone
- [ ] COMMON | 1.3 Add two IPv4 Google DNS servers (Optional)
- [ ] COMMON | 1.4 Add the user with a specific uid and a primary
- [ ] COMMON | 1.5 Create a directory structure
- [ ] COMMON | 1.6 Change home folder permissions
- [ ] COMMON | 1.7 Remove unnecessary messages of the day
- [ ] COMMON | 1.8 Add cleanup cron for Torrent files
- [ ] COMMON | 1.9 Add cleanup cron for the Torrent data
- [ ] COMMON | 1.10 Add useful alias rt
- [ ] COMMON | 1.11 Add Autobrr service
- [ ] COMMON | 1.12 Add Autobrr config directory
- [ ] COMMON | 1.13 Generate session secret for Autobrr
- [ ] COMMON | 1.14 Add Autobrr configuration file
- [ ] COMMON | 1.15 Add required package tar
- [ ] COMMON | 1.16 Unarchive Autobrr
- [ ] COMMON | 1.17 Unarchive Sizechecker
- [ ] COMMON | 1.18 Unarchive Mkbrr
- [ ] COMMON | 1.19 Install Autobrr, Mkbrr & Sizechecker binaries
- [ ] COMMON | 1.20 Add required package policycoreutils-python-utils
- [ ] COMMON | 1.21 Restore Autobrr, Mkbrr & Sizechecker files default
- [ ] COMMON | 1.22 Ensure port 7474 is labeled with http_port_t for Autobrr
- [ ] COMMON | 1.23 Add Autobrr backup & upgrade shell script
- [ ] COMMON | 1.24 Add panic shell script
- [ ] COMMON | 1.25 Systemd wide DefaultLimitNOFILE
- [ ] COMMON | 1.26 Set soft nofile limit
- [ ] COMMON | 1.27 Set hard nofile limit
- [ ] COMMON | 1.28 Include sysctl vars
- [ ] COMMON | 1.29 Set various sysctl settings
- [ ] COMMON | 1.30 Remount a /home and change atime options
- [ ] COMMON | 1.31 Install dynamic adaptive system tuning daemon
- [ ] COMMON | 1.32 Configure tuned for latency-performance
- [ ] COMMON | 1.33 Deploy benchmarking script

## 2. RTORRENT

- [ ] RTORRENT | 2.1 Install required packages
- [ ] RTORRENT | 2.2 Untar the libtorrent & rtorrent sources
- [ ] RTORRENT | 2.3 Compile libtorrent - configure
- [ ] RTORRENT | 2.4 Compile libtorrent - make
- [ ] RTORRENT | 2.5 Compile libtorrent - make install
- [ ] RTORRENT | 2.6 Compile rtorrent - configure
- [ ] RTORRENT | 2.7 Compile rtorrent - make
- [ ] RTORRENT | 2.8 Compile rtorrent - make install
- [ ] RTORRENT | 2.9 Template the configuration for rtorrent
- [ ] RTORRENT | 2.10 Template a service file for rtorrent

## 3. VSFTPD

- [ ] VSFTPD | 3.1 Install required packages
- [ ] VSFTPD | 3.2 Create a directory structure for SSL certificates
- [ ] VSFTPD | 3.3 Determine public IPv4 address
- [ ] VSFTPD | 3.4 Store public IPv4 address as a fact
- [ ] VSFTPD | 3.5 Create private key (RSA, 4096 bits)
- [ ] VSFTPD | 3.6 Generate an OpenSSL Certificate
- [ ] VSFTPD | 3.7 Generate a Self Signed OpenSSL certificate
- [ ] VSFTPD | 3.8 Template the configuration for vsftpd
- [ ] VSFTPD | 3.9 Configure vsftpd for multiple users (in users.txt)
  - [ ] VSFTPD | 3.9.1 Copy the users.txt
  - [ ] VSFTPD | 3.9.2 Get only the users from
  - [ ] VSFTPD | 3.9.3 Add users from users.txt without ability to SSH
  - [ ] VSFTPD | 3.9.4 Generate login database
  - [ ] VSFTPD | 3.9.5 Remove unnecessary file
  - [ ] VSFTPD | 3.9.6 Copy the vsftpd configuration for PAM

## 4. RUTORRENT

- [ ] RUTORRENT | 4.1 Install required packages
- [ ] RUTORRENT | 4.2 Create a directory structure
- [ ] RUTORRENT | 4.3 Untar the ruTorrent sources
- [ ] RUTORRENT | 4.4 Template the configuration for ruTorrent
- [ ] RUTORRENT | 4.5 Ensure unnecessary ruTorrent plugins are disabled
- [ ] RUTORRENT | 4.6 Change Plugins from user-defined to yes
- [ ] RUTORRENT | 4.7 Hide the Plugins tab
- [ ] RUTORRENT | 4.8 Copy the configuration for php-fpm
- [ ] RUTORRENT | 4.9 php-fpm log is sent to syslogd
- [ ] RUTORRENT | 4.10 Template the configuration for lighttpd
- [ ] RUTORRENT | 4.11 Copy the configuration for lighttpd modules
- [ ] RUTORRENT | 4.12 Copy the configuration for auth module
- [ ] RUTORRENT | 4.13 Copy the configuration for fastcgi module
- [ ] RUTORRENT | 4.14 Add a user to a htpasswd file and ensure
- [ ] RUTORRENT | 4.15 Copy the configuration for proxy module
- [ ] RUTORRENT | 4.16 Validate the lighttpd config files

## 5. SECURITY

- [ ] SECURITY | 5.1 Install packages
- [ ] SECURITY | 5.2 Ensure SELinux is set to enforcing mode
- [ ] SECURITY | 5.3 Copy the SELinux modules (for ruTorrent & tmux)
- [ ] SECURITY | 5.4 Compile the SELinux modules
- [ ] SECURITY | 5.5 Install the SELinux modules
- [ ] SECURITY | 5.6 Start service firewalld
- [ ] SECURITY | 5.7 Create a new firewalld zone "limited"
- [ ] SECURITY | 5.8 Add source to a new firewalld zone "limited"
- [ ] SECURITY | 5.9 Permit traffic in "default" zone for https service
- [ ] SECURITY | 5.10 Permit traffic in "default" zone for various rtorrent,
- [ ] SECURITY | 5.11 Deny traffic in "default" zone for cockpit and ssh
- [ ] SECURITY | 5.12 Deny ICMP traffic in "default" zone
- [ ] SECURITY | 5.13 Permit traffic in "limited" zone for various rtorrent,
- [ ] SECURITY | 5.14 Permit traffic in "limited" zone for https, sshd service
- [ ] SECURITY | 5.15 Template the configuration for SSHD
- [ ] SECURITY | 5.16 Copy the configuration for Fail2Ban (jail)
- [ ] SECURITY | 5.17 Copy the configuration for Fail2Ban (lighttpd)
- [ ] SECURITY | 5.18 Copy the configuration for Fail2Ban (sshd)
- [ ] SECURITY | 5.19 Template the configuration for Fail2Ban (vsftpd)
- [ ] SECURITY | 5.20 Make exceptions for some IP addresses for Fail2Ban
- [ ] SECURITY | 5.21 Change logging of Fail2Ban to systemd
- [ ] SECURITY | 5.22 Copy the filter for Fail2Ban (lighttpd-auth)
- [ ] SECURITY | 5.23 Copy the filter for Fail2Ban (vsftpd)
- [ ] SECURITY | 5.24 Disable shell history
- [ ] SECURITY | 5.25 Configure restricted sudo for ansible_user

## 6. CLEANUP

- [ ] CLEANUP | 6.1 Remove unnecessary packages
- [ ] CLEANUP | 6.2 Remove unnecessary source files
- [ ] CLEANUP | 6.3 Remove unnecessary SELinux files
- [ ] CLEANUP | 6.4 Remove unnecessary .github folder from ruTorrent
- [ ] CLEANUP | 6.5 Remove unnecessary Autobrr & Sizechecker files
- [ ] CLEANUP | 6.6 Change journald storage to RAM
- [ ] CLEANUP | 6.7 Lower jourland RuntimeMaxUse
- [ ] CLEANUP | 6.8 Lower jourland RuntimeMaxFileSize
- [ ] CLEANUP | 6.9 Lower jourland RuntimeMaxFiles
- [ ] CLEANUP | 6.10 Ensure rhsm logging is disabled
- [ ] CLEANUP | 6.11 Ensure rhsm logging is only ERROR
- [ ] CLEANUP | 6.12 Disable DNF logging
- [ ] CLEANUP | 6.13 Find all logs in /var/log
- [ ] CLEANUP | 6.14 Remove all var_log_files
- [ ] CLEANUP | 6.15 Create a symbolic link pointing to
- [ ] CLEANUP | 6.15 Create a symbolic link pointing to
- [ ] CLEANUP | 6.16 Remove all remaining packages that are not being used
- [ ] CLEANUP | 6.17 Remove logrotate without dependency (vsftpd)
- [ ] CLEANUP | 6.18 Remove /etc/logrotate.d/
- [ ] CLEANUP | 6.19 Clean all DNF caches
- [ ] CLEANUP | 6.20 Disable unnecessary services

## 7. REBOOT

- [ ] REBOOT | 7.1 Set Autobrr service as fact
- [ ] REBOOT | 7.2 Enable all required services
- [ ] REBOOT | 7.3 Reboot a machine
- [ ] REBOOT | 7.4 Test we can logon back after the reboot

## 8. TEST

- [ ] TEST | 8.1 Populate service_facts
- [ ] TEST | 8.2 Print ACTIVE services
- [ ] TEST | 8.3 Print INACTIVE services
- [ ] TEST | 8.4 Print RUNNING services
- [ ] TEST | 8.5 Print STOPPED services
- [ ] TEST | 8.6 Print UNKNOWN services
- [ ] TEST | 8.7 Check for port 22 to be open and contain "OpenSSH"
- [ ] TEST | 8.8 Check for FTP port to be open and contain "220 Welcome to"
- [ ] TEST | 8.9 Check for rtorrent port to be open
- [ ] TEST | 8.10 Check for RPC rtorrent endpoint to be open
- [ ] TEST | 8.11 Check for HTTPS rutorrent port to be open
- [ ] TEST | 8.12 Check for Autobrr to be responding
- [ ] TEST | 8.13 Check for Autobrr healtcheck to be reporting OK
- [ ] TEST | 8.14 Show the smoke test results
- [ ] TEST | 8.15 Output
