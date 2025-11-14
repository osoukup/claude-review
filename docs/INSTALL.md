# Installation Guide

Complete guide to installing claude-review.

**[← Back to README](../README.md)**

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
  - [Using Makefile (Recommended)](#using-makefile-recommended)
  - [Using Ansible Directly](#using-ansible-directly)
  - [Manual Installation](#manual-installation)
- [Verification](#verification)
- [Uninstallation](#uninstallation)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required

- **[Claude CLI](https://claude.ai/download)** - Must be installed and configured
- **Git** - Version control system
- **Bash** - Shell (usually pre-installed on Linux/macOS)

### Optional

- **Ansible** - For automated installation (can also use manual method)
- **Tmux** - For popup integration
- **[glow](https://github.com/charmbracelet/glow)** - For enhanced markdown rendering

### Check Prerequisites

```bash
# Check if tools are installed
make check-deps

# Or manually:
which git
which claude
which tmux
which ansible-playbook
```

## Installation Methods

### Using Makefile (Recommended)

The easiest way to install:

```bash
# Clone the repository
git clone https://github.com/osoukup/claude-review.git
cd claude-review

# Install (creates symlinks in ~/.local/bin)
make install
```

**What this does:**
- Creates `~/.local/bin` if it doesn't exist
- Creates symlinks (not copies) to the scripts
- Configures tmux keybinding (if tmux is installed)
- Checks if `~/.local/bin` is in your PATH
- No sudo required!

### Using Ansible Directly

If you prefer to run the playbook directly:

```bash
# Install
ansible-playbook install.yml

# With custom settings (edit install.yml first)
ansible-playbook install.yml
```

**Customization options in `install.yml`:**
```yaml
tmux_enable: true          # Enable/disable tmux integration
tmux_keybinding: "r"       # Keybinding (prefix + this key)
tmux_popup_width: "80%"    # Popup width
tmux_popup_height: "75%"   # Popup height
```

### Manual Installation

For those who prefer manual control:

```bash
# Clone the repository
git clone https://github.com/osoukup/claude-review.git
cd claude-review

# Ensure ~/.local/bin exists
mkdir -p ~/.local/bin

# Create symlinks
ln -s "$(pwd)/claude-review" ~/.local/bin/claude-review
ln -s "$(pwd)/claude-review-tmux" ~/.local/bin/claude-review-tmux

# Make sure scripts are executable
chmod +x claude-review claude-review-tmux
```

## PATH Configuration

If `~/.local/bin` is not in your PATH, add it:

**For Bash (`~/.bashrc`):**
```bash
export PATH="$HOME/.local/bin:$PATH"
```

**For Zsh (`~/.zshrc`):**
```bash
export PATH="$HOME/.local/bin:$PATH"
```

**Apply changes:**
```bash
source ~/.bashrc  # or ~/.zshrc
```

## Verification

Test that installation worked:

```bash
# Check if command is available
which claude-review

# Show version
claude-review --version

# Show help
claude-review --help

# Test in current directory (if it's a git repo)
make test
```

## Uninstallation

### Using Makefile

```bash
make uninstall
```

### Using Ansible

```bash
ansible-playbook uninstall.yml
```

### Manual Uninstallation

```bash
# Remove symlinks
rm ~/.local/bin/claude-review
rm ~/.local/bin/claude-review-tmux

# Remove tmux configuration (if configured)
# Edit ~/.tmux.conf and remove the ANSIBLE MANAGED BLOCK for claude-review
```

## Troubleshooting

### "Claude CLI is not installed"

Install Claude CLI:
```bash
# Download from https://claude.ai/download
# Or check their documentation for installation instructions
```

Verify installation:
```bash
which claude
claude --version
```

### "ansible-playbook not found"

Install Ansible:

```bash
# Fedora/RHEL
sudo dnf install ansible

# Ubuntu/Debian
sudo apt install ansible

# macOS
brew install ansible
```

Or use the manual installation method instead.

### "~/.local/bin is not in your PATH"

Add to your shell configuration file:

```bash
# Add this line to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# Reload your shell
source ~/.bashrc  # or ~/.zshrc
```

### Symlinks Not Working

If symlinks aren't working (rare), you can copy instead:

```bash
cp claude-review ~/.local/bin/
cp claude-review-tmux ~/.local/bin/
```

**Note:** With copies, you'll need to reinstall after making changes.

### Tmux Integration Not Working

Check if tmux is installed:
```bash
which tmux
```

Check if the keybinding was added to `~/.tmux.conf`:
```bash
grep claude-review ~/.tmux.conf
```

Reload tmux configuration:
```bash
tmux source-file ~/.tmux.conf
```

### Permission Issues

The installation should not require sudo. If you get permission errors:

1. Make sure you're installing to `~/.local/bin` (user space)
2. Check ownership: `ls -la ~/.local/bin/claude-review*`
3. Fix if needed: `chmod +x ~/.local/bin/claude-review*`

## Optional Enhancements

### Install glow for Better Formatting

For enhanced markdown rendering:

```bash
# Fedora/RHEL
sudo dnf install glow

# macOS
brew install glow

# Using Go
go install github.com/charmbracelet/glow@latest
```

The tool automatically detects and uses `glow` if available.

### Create Shell Alias

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias cr='claude-review'
```

Then use:
```bash
cr  # Instead of claude-review
```

---

**[← Back to README](../README.md)** • **[Usage Guide →](USAGE.md)** • **[Tmux Integration →](TMUX.md)**
