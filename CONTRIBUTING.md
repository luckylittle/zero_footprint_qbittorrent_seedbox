# Contributing to zero_footprint_qbittorrent_seedbox

Thank you for your interest in contributing to this Ansible role! This document provides guidance for setting up your development environment, testing your changes, and following best practices.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Setup Development Environment](#setup-development-environment)
- [Testing](#testing)
- [Code Style and Quality Standards](#code-style-and-quality-standards)
- [Practical Tips](#practical-tips)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project adheres to a Code of Conduct. Please review [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Setup Development Environment

### Prerequisites

1. **Ansible Core**: Version `2.16.14` or higher
   ```bash
   # Verify your Ansible version
   ansible --version
   ```

2. **Python**: Required for Ansible and linting tools
   ```bash
   python3 --version  # Should be Python 3.8+
   ```

3. **Linting Tools** (required versions):
   - `yamllint` version `1.37.1^`
   - `ansible-lint` version `6.22.2^`
   - `codespell` version `2.4.1^`

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/luckylittle/zero_footprint_qbittorrent_seedbox.git
   cd zero_footprint_qbittorrent_seedbox
   ```

2. **Install Ansible collections**:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

   This installs:
   - `ansible.posix` (v2.1.0)
   - `community.crypto` (v3.1.0)
   - `community.general` (v12.3.0)

3. **Install linting tools** (using pip):
   ```bash
   pip3 install --user yamllint ansible-lint codespell
   ```

   Or using your system package manager:
   ```bash
   # On RHEL/CentOS/Fedora
   sudo dnf install yamllint ansible-lint codespell
   ```

4. **Verify installation**:
   ```bash
   yamllint --version
   ansible-lint --version
   codespell --version
   ```

### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b bugfix/your-bugfix-name
   ```

2. **Make your changes** following the conventions outlined in this document

3. **Run linting** before committing:
   ```bash
   yamllint .
   ansible-lint .
   codespell
   ```

4. **Test your changes** (see [Testing](#testing) section)

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   git push origin feature/your-feature-name
   ```

## Testing

### Local Linting

Before submitting changes, ensure all linting passes:

```bash
# Run all linters
yamllint .
ansible-lint .
codespell
```

### Integration Testing

The project includes a comprehensive testing infrastructure using Terraform and AWS.

#### Prerequisites for Testing

1. **Terraform**: Install [Terraform](https://www.terraform.io/downloads) (v1.0+)
2. **AWS Account**: With appropriate credentials configured
3. **AWS Key Pair**: An existing EC2 key pair in your AWS region

#### Running Tests

1. **Navigate to the tests directory**:
   ```bash
   cd tests/
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Create test infrastructure**:
   ```bash
   terraform apply -var=key_name=<YOUR_AWS_KEY_PAIR_NAME> -auto-approve
   ```

   This creates:
   - An RHEL 10 EC2 instance (t3.medium)
   - Security groups with appropriate rules
   - EBS volumes for testing

4. **Generate inventory**:
   ```bash
   terraform output -raw instance_public_ip > inventory
   ```

5. **Set up role symlink**:
   ```bash
   mkdir -p roles/
   ln -s ../../ roles/luckylittle.zero_footprint_qbittorrent_seedbox
   ```

6. **Run the test playbook**:
   ```bash
   time ansible-playbook -i inventory -u ec2-user test.yml
   ```

   **Note**: The test will take approximately 13-15 minutes on a t3.medium instance.

7. **Verify services** (after successful run):
   - qBittorrent WebUI: `http://<instance-ip>:8080`
   - Autobrr: `http://<instance-ip>:7474/onboard`
   - Qui: `http://<instance-ip>:7476`
   - Netronome: `http://<instance-ip>:7575`
   - vsFTPd: `ftps://<instance-ip>:55443`

8. **Clean up** (when done):
   ```bash
   terraform destroy -auto-approve
   ```

#### Testing Specific Task Sections

You can test individual sections using tags:

```bash
# Test only common tasks
ansible-playbook -i inventory -u ec2-user test.yml --tags common

# Test only qBittorrent setup
ansible-playbook -i inventory -u ec2-user test.yml --tags qbt

# Test only security configuration
ansible-playbook -i inventory -u ec2-user test.yml --tags security

# Skip reboot (useful for iterative testing)
ansible-playbook -i inventory -u ec2-user test.yml --skip-tags reboot
```

#### Smoke Tests

The role includes automated smoke tests in `tasks/08-smoke_tests.yml` that verify:
- Services are running and enabled
- Ports are listening
- Configuration files exist
- System state is correct

These run automatically at the end of the role execution.

### Testing Checklist

Before submitting a pull request, verify:

- [ ] All linting passes (`yamllint`, `ansible-lint`, `codespell`)
- [ ] Full integration test completes successfully
- [ ] All services start and respond appropriately
- [ ] Security configurations are applied correctly
- [ ] System reboots successfully (if `require_reboot: true`)
- [ ] Smoke tests pass
- [ ] No sensitive data is committed (check for passwords, keys, etc.)

## Code Style and Quality Standards

### Task Organization

Tasks are organized in numbered files that execute sequentially:

- `00-preflight.yml` - Pre-flight checks and validations
- `01-common.yml` - Common system configuration
- `02-qbt.yml` - qBittorrent installation and configuration
- `03-vsftpd.yml` - vsFTPd FTP server setup
- `04-tools.yml` - Additional tools (autobrr, netronome, tqm, etc.)
- `05-security.yml` - Security hardening
- `06-cleanup.yml` - System cleanup
- `07-reboot.yml` - System reboot handling
- `08-smoke_tests.yml` - Post-deployment verification

### Task Conventions

1. **Task Naming**: Use descriptive names with section prefixes
   ```yaml
   - name: QBT | 2.1 Install qBittorrent
   ```

2. **Task Versioning**: All tasks must have version identifiers
   ```yaml
   - name: QBT | 2.1 Install qBittorrent
   ```

3. **Tags**: All tasks must be properly tagged
   ```yaml
   tags:
     - qbt
     - installation
   ```

4. **Backup**: Always set `backup: true` for file modifications
   ```yaml
   ansible.builtin.copy:
     src: file.conf
     dest: /etc/file.conf
     backup: true
   ```

5. **Headers**: Templates and files must include "Ansible managed" header

### Variable Conventions

- **Defaults** (`defaults/main.yml`): User-configurable variables with sensible defaults
- **Vars** (`vars/main.yml`): Internal role variables (not recommended to change)
- **Variable Naming**: Use descriptive names with underscores (e.g., `qbt_port`, `ipv4_whitelist`)
- **Variable Organization**: Group variables by task section with comments

Example:
```yaml
# 02-qbt
qbt_port: 55442

# 03-vsftpd
ftp_port: 55443
```

### Template Conventions

- All templates use Jinja2 syntax (`.j2` extension)
- Templates are located in `templates/` organized by component subdirectories
- Templates should include "Ansible managed" header comments
- Use proper Jinja2 escaping for YAML values

### File Management

- **Static files**: Place in `files/` directory
- **Templates**: Place in `templates/` with appropriate subdirectories
- **Always use `backup: true`** when modifying existing files
- **Remove temporary files** after use

## Practical Tips

### Working with Task Files

1. **Maintain Sequential Order**: When adding new tasks, maintain the numbered sequence
2. **Use Appropriate Tags**: Tag tasks so they can be selectively executed
3. **Include Pre-flight Checks**: Add validation tasks in `00-preflight.yml` for critical configurations
4. **Handle Errors Gracefully**: Use `failed_when` and `ignore_errors` appropriately

### Security Considerations

1. **Never Commit Secrets**:
   - Use variables for sensitive data
   - Never hardcode passwords or API keys
   - Use Ansible Vault for sensitive variables if needed

2. **SSH Key Authentication**:
   - The role disables password-based SSH access
   - Ensure SSH key authentication is configured before testing

3. **Firewall Whitelisting**:
   - Always configure `ipv4_whitelist` with valid IP addresses
   - The default placeholder `X.X.X.X` will cause the role to fail (by design)

4. **SELinux**:
   - Always use appropriate SELinux labels (`seuser`, `serole`, `setype`, `selevel`)
   - Test SELinux contexts when adding new file operations

### Common Patterns

#### Service Management Pattern

```yaml
- name: Install service
  ansible.builtin.get_url:
    url: "{{ service_url }}"
    dest: "/usr/local/bin/{{ service_name }}"
    mode: '0755'

- name: Configure service
  ansible.builtin.template:
    src: "{{ service_name }}/config.toml.j2"
    dest: "/home/{{ ansible_user }}/.config/{{ service_name }}/config.toml"
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: '0600'
    backup: true

- name: Create systemd service
  ansible.builtin.template:
    src: "{{ service_name }}/{{ service_name }}.service.j2"
    dest: "/etc/systemd/system/{{ service_name }}.service"
    backup: true
  notify: reload systemd

- name: Enable and start service
  ansible.builtin.systemd:
    name: "{{ service_name }}"
    enabled: true
    state: started
    daemon_reload: true
```

#### Directory Creation Pattern

```yaml
- name: Create directory structure
  ansible.builtin.file:
    path: "/home/{{ ansible_user }}/.config/{{ app_name }}"
    state: directory
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: '0755'
```

### Debugging Tips

1. **Use Verbose Mode**: Run playbooks with `-v`, `-vv`, or `-vvv` for detailed output
   ```bash
   ansible-playbook -i inventory -u ec2-user test.yml -vv
   ```

2. **Test Individual Tasks**: Use `--start-at-task` to resume from a specific task
   ```bash
   ansible-playbook -i inventory -u ec2-user test.yml --start-at-task "QBT | 2.1"
   ```

3. **Check Service Status**: After testing, SSH into the instance and verify:
   ```bash
   systemctl status qbittorrent
   systemctl status autobrr
   journalctl -u qbittorrent -n 50
   ```

4. **Verify Configuration Files**: Check that templates rendered correctly
   ```bash
   cat /home/ec2-user/.config/qBittorrent/qBittorrent.conf
   ```

### Performance Considerations

1. **Idempotency**: Ensure all tasks are idempotent (can be run multiple times safely)
2. **Conditional Execution**: Use `when` clauses to skip unnecessary work
3. **Parallel Execution**: Use `async` and `poll` for long-running tasks when appropriate
4. **Cache Facts**: Use `fact_caching` in `ansible.cfg` for faster subsequent runs

### User Context

Many tasks rely on `ansible_user` / `remote_user` variable:
- Directory structures are created under this user's home directory
- Services run as this user
- Configuration files are placed in this user's `.config` directories

Always use `{{ ansible_user }}` instead of hardcoding usernames.

## Submitting Changes

### Pull Request Process

1. **Fork the repository** (if you don't have write access)

2. **Create a feature branch** from `main`:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following all conventions

4. **Run all tests** and ensure they pass

5. **Commit your changes** with descriptive messages:
   ```bash
   git commit -m "Add feature: description of what you added"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** on GitHub with:
   - Clear description of changes
   - Reference to any related issues
   - Confirmation that tests pass
   - Any breaking changes clearly documented

### Pull Request Checklist

- [ ] Code follows project conventions
- [ ] All linting passes
- [ ] Tests pass (full integration test)
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated (for user-facing changes)
- [ ] No sensitive data committed
- [ ] Commit messages are clear and descriptive

### Code Review

- All pull requests require review before merging
- Address review comments promptly
- Be open to feedback and suggestions
- Keep discussions constructive and respectful

## Getting Help

- **Issues**: Open an issue on GitHub for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions and general discussion
- **Documentation**: Check [README.md](README.md) and [AGENTS.md](AGENTS.md) for detailed information

## Additional Resources

- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Lint Documentation](https://ansible-lint.readthedocs.io/)
- [YAML Lint Documentation](https://yamllint.readthedocs.io/)

Thank you for contributing to this project!
