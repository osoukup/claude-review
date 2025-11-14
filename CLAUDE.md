# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Information

AI-assisted code review tool that wraps Claude CLI to analyze git commits for potential issues.

- **License**: MIT
- **Main Branch**: main
- **Language**: Bash
- **Target Users**: Developers using Claude CLI who want automated code review

## Architecture

### Core Components

- **claude-review**: Main bash script that orchestrates the code review process
  - Standalone tool - no tmux dependencies
  - Argument parsing and validation
  - Git repository detection and branch management
  - Diff extraction between base branch and HEAD
  - Claude CLI integration via subprocess with spinner progress indicator
  - Formatted output with color-coded results (uses glow if available)
  - Colorized markdown rendering (headers, bold, recommendations)
  - Can be run directly from command line or via tmux wrapper

- **Makefile**: Convenient shortcuts for common operations
  - install/uninstall targets (run Ansible playbooks)
  - test targets with REPO and BRANCH parameters
  - check-deps for dependency verification
  - dev-test for syntax checking
  - Self-documenting help system

- **claude-review-tmux**: Smart tmux popup wrapper (all tmux logic here)
  - Detects git repository root automatically
  - Creates named tmux sessions (e.g., `myproject-claude-review`)
  - Uses `tmux new-session -A` to create OR attach to existing session
  - Launches in popup window (80%x75% by default)
  - Prevents duplicate reviews for same repository
  - Supports environment variables for custom dimensions
  - Handles pause-before-close so user can read results

- **install.yml**: Ansible playbook for user-space installation
  - Creates symlinks in ~/.local/bin to repo scripts (no sudo required)
  - Development-friendly: changes to repo take effect immediately
  - Verifies prerequisites (git, claude CLI, tmux)
  - Configures tmux keybinding (prefix + r) via managed block in ~/.tmux.conf
  - Checks if ~/.local/bin is in PATH
  - Validates installation

- **uninstall.yml**: Ansible playbook for clean removal
  - Removes symlinks from ~/.local/bin
  - Removes tmux configuration block from ~/.tmux.conf
  - Reloads tmux config if running

### Workflow

1. User runs `claude-review` in a git repository
2. Script auto-detects base branch (main/master) or uses provided flag
3. Extracts git diff and commit messages between base and current branch
4. Constructs structured prompt asking Claude to review for:
   - Functional issues (bugs, logic errors, edge cases)
   - Performance issues (inefficiencies, memory leaks)
   - Security issues (injection flaws, auth problems, data exposure)
   - Code quality (maintainability, best practices)
5. Sends prompt to Claude CLI via stdin
6. Claude returns structured review with file:line references
7. Displays review with recommendation: REJECT / POLISH / ACCEPT

### Design Principles

- **Read-only**: Never modifies code, only provides recommendations
- **Minimal dependencies**: Pure bash, requires only git and claude CLI
- **User-friendly**: Color-coded output, clear recommendations, animated spinner
- **Flexible**: Supports custom base branch via flags
- **Pipe-friendly**: Auto-detects TTY vs piped output
  - Terminal: Colors, spinner, decorative elements
  - Piped/redirected: Plain text, no colors, progress to stderr
  - Works seamlessly in scripts and pipelines
- **Separation of concerns**: Main script is standalone; tmux integration is optional wrapper
  - `claude-review` has zero tmux dependencies and can run anywhere
  - `claude-review-tmux` contains ALL tmux-specific logic
  - This makes the codebase easier to maintain and understand

## Development

### Testing the Tool

```bash
# Make script executable
chmod +x claude-review

# Test in a git repository with commits
./claude-review

# Test with custom base branch
./claude-review --base-branch develop
```

### Installation

```bash
# Easiest: Using Makefile
make install

# Or directly with Ansible
ansible-playbook install.yml

# Customize tmux settings in install.yml vars before running:
# - tmux_enable: true/false
# - tmux_keybinding: "r" (or any key)
# - tmux_popup_width: "80%" (default)
# - tmux_popup_height: "75%" (default)

# Override popup size at runtime:
export CLAUDE_REVIEW_POPUP_WIDTH="90%"
export CLAUDE_REVIEW_POPUP_HEIGHT="85%"

# Uninstall
make uninstall
# Or: ansible-playbook uninstall.yml

# Check dependencies
make check-deps

# Manual: Add to PATH
sudo ln -s "$(pwd)/claude-review" /usr/local/bin/claude-review

# Or create alias in ~/.bashrc
alias cr='/path/to/claude-review'
```

## Common Commands

```bash
# Using Makefile (recommended)
make help                              # Show all available commands
make test                              # Test in current directory
make test REPO=/path/to/repo           # Test in specific repository
make test-branch BRANCH=develop        # Test against specific branch
make install                           # Install system-wide
make uninstall                         # Uninstall
make check-deps                        # Verify dependencies

# Direct script usage
./claude-review                        # Run code review
./claude-review --base-branch develop  # Specify base branch
./claude-review --help                 # Show help

# In tmux: prefix + r (opens in popup, or attaches to existing session)

# Development
make dev-test                          # Run syntax checks
bash -n claude-review                  # Check bash syntax

# Test git operations
git log main..HEAD --oneline
git diff main..HEAD

# Reload tmux config (after installation or changes)
tmux source-file ~/.tmux.conf
```
