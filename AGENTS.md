# AGENTS.md

This document provides guidance for AI coding agents working on this Ansible role project.

## Project Overview

This is an Ansible role (`luckylittle.zero_footprint_qbittorrent_seedbox`) that provisions a Red Hat Enterprise Linux system as a secure, efficient, and lightweight peer-to-peer (P2P) seedbox running qBittorrent. The role prioritizes security and simplicity, utilizing SELinux and firewalld, and is configured for zero-logging operation.

## Directory Structure

This role follows the standard Ansible role directory structure:

```
.
├── defaults/          # Default variable values (user-configurable)
├── files/             # Static files to be copied to target hosts
├── handlers/          # Handler definitions
├── meta/              # Role metadata (dependencies, platforms, etc.)
├── tasks/             # Task files (main.yml and numbered task files)
├── templates/         # Jinja2 templates for configuration files
├── vars/              # Role variables (internal, not recommended to change)
└── tests/             # Test playbooks and infrastructure
```

## Task Organization

Tasks are organized in numbered files that execute in sequence:

- `00-preflight.yml` - Pre-flight checks and validations
- `01-common.yml` - Common system configuration (DNS, timezone, directories, sysctl, etc.)
- `02-qbt.yml` - qBittorrent installation and configuration
- `03-vsftpd.yml` - vsFTPd FTP server setup
- `04-tools.yml` - Additional tools (autobrr, netronome, tqm, sizechecker, etc.)
- `05-security.yml` - Security hardening (firewalld, SSH, SELinux, sudo restrictions)
- `06-cleanup.yml` - System cleanup (remove unnecessary packages, disable logging)
- `07-reboot.yml` - System reboot handling
- `08-smoke_tests.yml` - Post-deployment verification tests

## Code Style and Quality Standards

### Linting Requirements

All files must pass the following linting tools:

- **yamllint** version `1.37.1^` - YAML syntax and style validation
- **ansible-lint** version `6.22.2^` - Ansible-specific best practices
- **codespell** version `2.4.1^` - Spell checking

### Task Conventions

1. **Task Naming**: Use descriptive names with section prefixes (e.g., `MAIN | 1.0`, `QBT | 2.1`)
2. **Task Versioning**: All tasks must have version identifiers for tracking purposes
3. **Tags**: All tasks must be properly tagged for selective execution
4. **Backup**: Where applicable, always set `backup: true` for file modifications
5. **Headers**: All templates and files must include "Ansible managed" header

### Variable Conventions

- **Defaults** (`defaults/main.yml`): User-configurable variables with sensible defaults
- **Vars** (`vars/main.yml`): Internal role variables (not recommended to change)
- **Variable Naming**: Use descriptive names with underscores (e.g., `qbt_port`, `ipv4_whitelist`)
- **Variable Organization**: Group variables by task section (e.g., `# 02-qbt`, `# 03-vsftpd`)

### Template Conventions

- All templates use Jinja2 syntax (`.j2` extension)
- Templates are located in `templates/` organized by component subdirectories
- Templates should include "Ansible managed" header comments

## Important Configuration Notes

### Critical Security Warnings

1. **SSH Key Authentication**: The role disables password-based SSH access. SSH key authentication MUST be configured before role execution.
2. **Firewall IP Whitelisting**: The `ipv4_whitelist` variable MUST be configured with valid IP addresses before execution to prevent system lockout.
3. **Default Values**: The default `ipv4_whitelist` contains placeholder values (`X.X.X.X`) that MUST be changed.

### User Context

Many tasks rely on `ansible_user` / `remote_user` variable:
- Directory structures are created under this user's home directory
- Services run as this user
- Configuration files are placed in this user's `.config` directories

## Testing

### Manual Testing

The project includes a comprehensive test checklist in `.github/pull_request_template.md`. Before submitting changes, verify:

1. All linting passes
2. All task sections function correctly
3. Services start and respond appropriately
4. Security configurations are applied
5. System reboots successfully
6. Smoke tests pass

### Test Infrastructure

- Test playbook: `tests/test.yml`
- Terraform infrastructure: `tests/terraform.tf`
- Test inventory: `tests/inventory`

## Dependencies

- **Ansible Core**: Version `2.16.14` or higher
- **Collections**: Install via `ansible-galaxy collection install -r requirements.yml`

## Build and Setup Commands

```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements.yml

# Run linting
yamllint .
ansible-lint .
codespell

# Test the role (from tests/ directory)
cd tests/
terraform init
terraform apply -var=key_name=<KEY_PAIR_NAME> -auto-approve
terraform output -raw instance_public_ip > inventory
mkdir roles/
ln -s ../../ roles/luckylittle.zero_footprint_qbittorrent_seedbox
ansible-playbook -i inventory -u ec2-user test.yml
```

## Common Patterns

### Service Management

Services are typically:
1. Installed/downloaded
2. Configured via templates
3. Enabled and started via systemd
4. Verified in smoke tests

### File Management

- Static files go in `files/`
- Templates go in `templates/`
- Always use `backup: true` when modifying existing files
- Remove temporary files after use

### Security Considerations

- Always use SELinux labels where applicable
- Configure firewalld rules appropriately
- Restrict sudo access to specific commands
- Disable unnecessary logging

## When Making Changes

1. **Follow the task numbering**: Maintain the sequential organization
2. **Update variables**: Add new variables to appropriate section in `vars/main.yml` or `defaults/main.yml`
3. **Add tags**: Ensure new tasks have appropriate tags
4. **Update documentation**: Update README.md if adding new configurable variables
5. **Test thoroughly**: Run through the PR template checklist
6. **Maintain backward compatibility**: Consider existing deployments when changing defaults

## Key Components

### Services Installed

- qBittorrent (static nox build)
- vsFTPd (FTP server with SSL/TLS)
- Autobrr (automated download manager)
- Netronome (network monitoring)
- Qui (qBittorrent management utility & cross-seed)

### Ports Used

- SSH: 22 (configurable via `ssh_port` in defaults)
- qBittorrent: 55442 (configurable via `qbt_port` in defaults)
- qBittorrent WebUI: 8080
- vsFTPd: 55443 (configurable via `ftp_port` in defaults)
- Autobrr: 7474 (configurable via `autobrr_cfg_port` in vars)
- Netronome: 7575 (configurable via `netronome_cfg_port` in vars)
- Netronome Agent: 8200
- Qui: 7476 (configurable via `qui_cfg_port` in vars)

## Additional Resources

- README.md - User-facing documentation
- CONTRIBUTING.md - Contribution guidelines
- .github/pull_request_template.md - PR checklist and standards
- meta/main.yml - Role metadata and platform support
