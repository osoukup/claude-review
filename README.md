# claude-review

AI-assisted code review using Claude CLI. Analyzes git commits for functional issues, performance problems, security vulnerabilities, and code quality.

---

📚 **[Installation Guide](docs/INSTALL.md)** • **[Usage Guide](docs/USAGE.md)** • **[Tmux Integration](docs/TMUX.md)**

---

## Quick Start

```bash
# Clone and install
git clone https://github.com/osoukup/claude-review.git
cd claude-review
make install

# Run a review
claude-review
```

## What It Does

`claude-review` examines your git commits and provides an AI-powered code review with:

- **Critical Issues**: Security vulnerabilities, logic errors, bugs
- **Warnings**: Performance problems, code smells
- **Suggestions**: Best practices, improvements
- **Recommendation**: REJECT, POLISH, or ACCEPT

## Key Features

✓ **No sudo required** - Installs to `~/.local/bin`
✓ **Development-friendly** - Uses symlinks, changes take effect immediately
✓ **Tmux integration** - Press `prefix + r` for popup reviews
✓ **Pipe-friendly** - Clean output for scripts and automation
✓ **Read-only** - Never modifies your code

## Installation

**Quick install:**
```bash
make install
```

Creates symlinks in `~/.local/bin` and configures tmux (if available).

📖 **[Detailed installation guide →](docs/INSTALL.md)**

## Usage

**Basic usage:**
```bash
# Review changes since main/master
claude-review

# Review against specific branch
claude-review --base-branch develop
```

**Tmux integration:**
```bash
# In tmux: prefix + r
# Opens review in a popup window
```

**Scripting:**
```bash
# Save to file (plain text, no colors)
claude-review > review.txt

# Use in CI/CD
if claude-review | grep -q "REJECT"; then
    echo "Review failed"
    exit 1
fi
```

📖 **[Full usage guide →](docs/USAGE.md)**
📖 **[Tmux integration guide →](docs/TMUX.md)**

## Prerequisites

- [Claude CLI](https://claude.ai/download) - Required
- Git - Required
- Bash - Required
- Tmux - Optional (for popup integration)
- Ansible - Optional (for installation)

## Documentation

- **[Installation Guide](docs/INSTALL.md)** - Installation methods, troubleshooting, PATH setup
- **[Usage Guide](docs/USAGE.md)** - Basic and advanced usage, piping, examples
- **[Tmux Integration](docs/TMUX.md)** - Popup setup, keybinding customization, workflow
- **[CLAUDE.md](CLAUDE.md)** - Architecture and development guide

## Project Structure

```
claude-review/
├── claude-review          # Main review script
├── claude-review-tmux     # Tmux popup wrapper
├── Makefile              # Easy installation & testing
├── install.yml           # Ansible installation
├── uninstall.yml         # Ansible uninstallation
└── docs/                 # Documentation
```

## Contributing

Contributions welcome! Please feel free to submit issues or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details

## Credits

Built with [Claude CLI](https://claude.ai/code) by Anthropic
