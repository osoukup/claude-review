# Tmux Integration Guide

Complete guide to using claude-review with tmux popup integration.

**[← Back to README](../README.md)**

## Table of Contents

- [Overview](#overview)
- [How It Works](#how-it-works)
- [Setup](#setup)
- [Usage](#usage)
- [Customization](#customization)
- [Workflow Tips](#workflow-tips)
- [Troubleshooting](#troubleshooting)

## Overview

The tmux integration provides a seamless popup experience for code reviews:

- Press `prefix + r` to trigger a review
- Review opens in a popup window (80% x 75% by default)
- Navigate away and return to the review anytime
- Reuses sessions - no duplicate reviews
- Auto-detects git repository root

**Visual:**
```
┌────────────────────────────────────────────────────────────┐
│                    Tmux Popup (80% x 75%)                  │
│                                                            │
│  ╔═══════════════════════════════════════════════════╗     │
│  ║     AI-Assisted Code Review with Claude           ║     │
│  ╚═══════════════════════════════════════════════════╝     │
│                                                            │
│  Summary                                                   │
│  Changes look good...                                      │
│                                                            │
│  Recommendation                                            │
│  ACCEPT: No significant issues                             │
│                                                            │
│  Press Enter to close...                                   │
└────────────────────────────────────────────────────────────┘
```

## How It Works

### Architecture

1. **Keybinding** (`prefix + r`) calls `claude-review-tmux` wrapper
2. **Wrapper** detects git repo root and creates session name
3. **Session** is created or attached (if already exists)
4. **Popup** displays the session with `claude-review` running
5. **Pause** at end lets you read results before closing

### Session Management

Each repository gets its own named session:

```bash
# Session names are based on repository
myproject-claude-review
api-server-claude-review
website-claude-review
```

Benefits:
- **No duplicates**: Pressing `prefix + r` again attaches to existing review
- **Persistent**: Close popup, review continues in background
- **Resume**: Return to review anytime

## Setup

### Automatic Setup (Recommended)

The installation automatically configures tmux:

```bash
make install
```

This adds to your `~/.tmux.conf`:

```bash
# BEGIN ANSIBLE MANAGED BLOCK - claude-review
# claude-review integration - AI-assisted code review in tmux popup
# Trigger with prefix + r
# Creates or attaches to a named session in a popup window
bind-key r run-shell "$HOME/.local/bin/claude-review-tmux '#{pane_current_path}'"
# END ANSIBLE MANAGED BLOCK - claude-review
```

### Manual Setup

If you prefer to configure manually:

```bash
# Add to ~/.tmux.conf
bind-key r run-shell "$HOME/.local/bin/claude-review-tmux '#{pane_current_path}'"

# Reload config
tmux source-file ~/.tmux.conf
```

## Usage

### Basic Workflow

1. **Start review**: Press `prefix + r` (e.g., `Ctrl+b` then `r`)
2. **Wait**: Spinner shows while Claude analyzes (10-30 seconds)
3. **Read results**: Scrollthrough the review
4. **Close or keep**: Press Enter to close, or navigate away

### Navigate During Review

While review is running:

```bash
# Navigate to other windows (review continues in background)
prefix + 1    # Go to window 1
prefix + 2    # Go to window 2

# Return to any window
prefix + w    # Show window list, select review
```

### Reattach to Running Review

If you closed the popup while review was running:

```bash
# Press prefix + r again
# Popup reopens and attaches to the running review session
```

### Close Review Session

When review is complete:

```bash
# Press Enter when prompted
# This closes the session and popup
```

Or manually kill the session:

```bash
# List sessions
tmux list-sessions | grep claude-review

# Kill specific session
tmux kill-session -t myproject-claude-review
```

## Customization

### Change Keybinding

Edit `install.yml` before installation:

```yaml
tmux_keybinding: "r"       # Change to your preferred key
```

Or manually edit `~/.tmux.conf`:

```bash
# Use 'R' instead of 'r'
bind-key R run-shell "$HOME/.local/bin/claude-review-tmux '#{pane_current_path}'"
```

Then reload:

```bash
tmux source-file ~/.tmux.conf
```

### Customize Popup Size

**Before installation**, edit `install.yml`:

```yaml
tmux_popup_width: "80%"    # Default: 80%
tmux_popup_height: "75%"   # Default: 75%
```

**Runtime override** (environment variables):

```bash
# Add to ~/.bashrc or ~/.zshrc
export CLAUDE_REVIEW_POPUP_WIDTH="90%"
export CLAUDE_REVIEW_POPUP_HEIGHT="85%"

# Then reload shell
source ~/.bashrc
```

**Per-session override**:

```bash
# Set before starting tmux
CLAUDE_REVIEW_POPUP_WIDTH="100%" tmux
```

### Custom Popup Positioning

Edit the wrapper script directly (`claude-review-tmux`):

```bash
# Change from centered (default)
tmux display-popup -E -w "$popup_width" -h "$popup_height" -x C -y C ...

# To top-left
tmux display-popup -E -w "$popup_width" -h "$popup_height" -x 0 -y 0 ...

# To bottom-right
tmux display-popup -E -w "$popup_width" -h "$popup_height" -x R -y R ...
```

## Workflow Tips

### Efficient Review Process

```bash
# 1. Make changes in your editor
# ... code ...

# 2. Trigger review (prefix + r)
# 3. Continue working while review runs
# ... keep coding ...

# 4. Review completes, popup stays
# 5. Check results when ready

# 6. Press Enter to close when done
```

### Multiple Repositories

Each repository gets its own session:

```bash
# In project A, press prefix + r
# → Creates "projectA-claude-review" session

# Switch to project B, press prefix + r
# → Creates "projectB-claude-review" session

# Both reviews can run simultaneously!
```

### Quick Check

```bash
# Trigger review
prefix + r

# Glance at recommendation
# (scroll to bottom if needed)

# Press Enter to close
```

### Deep Review

```bash
# Trigger review
prefix + r

# Review completes
# Read through all sections

# Navigate away to implement fixes
prefix + 1  # Go to editor window

# Return to review for reference
prefix + w  # Window list, select review

# Keep review open while fixing issues
# Close when done: prefix + w, select review, press Enter
```

## Troubleshooting

### Keybinding Not Working

**Check if tmux is running:**
```bash
echo $TMUX
# Should show something like: /tmp/tmux-1000/default,12345,0
```

**Check if keybinding is configured:**
```bash
grep claude-review ~/.tmux.conf
```

**Reload tmux configuration:**
```bash
tmux source-file ~/.tmux.conf
```

**Test keybinding:**
```bash
# In tmux, press: prefix + ?
# Search for your keybinding (e.g., 'r')
# Should show: run-shell ... claude-review-tmux
```

### Popup Doesn't Appear

**Tmux version:**
```bash
tmux -V
# Popups require tmux 3.2+
```

**Upgrade if needed:**
```bash
# Fedora/RHEL
sudo dnf upgrade tmux

# Ubuntu/Debian
sudo apt upgrade tmux

# macOS
brew upgrade tmux
```

### Session Already Exists Error

This shouldn't happen (the wrapper handles it), but if it does:

```bash
# List sessions
tmux list-sessions

# Kill old session
tmux kill-session -t myproject-claude-review

# Try again
```

### Review Runs in Background Instead

If review doesn't show in popup:

```bash
# List sessions
tmux list-sessions | grep claude-review

# Attach manually
tmux attach -t myproject-claude-review
```

### Popup Size Wrong

Check environment variables:

```bash
echo $CLAUDE_REVIEW_POPUP_WIDTH
echo $CLAUDE_REVIEW_POPUP_HEIGHT
```

Override:

```bash
unset CLAUDE_REVIEW_POPUP_WIDTH
unset CLAUDE_REVIEW_POPUP_HEIGHT
```

## Advanced Usage

### Multiple Keybindings

```bash
# In ~/.tmux.conf

# Default review (main branch)
bind-key r run-shell "$HOME/.local/bin/claude-review-tmux '#{pane_current_path}'"

# Review against develop
bind-key R run-shell "cd '#{pane_current_path}' && $HOME/.local/bin/claude-review --base-branch develop"
```

### Integration with Other Tools

```bash
# Run tests before review
bind-key T run-shell "cd '#{pane_current_path}' && make test && $HOME/.local/bin/claude-review-tmux '#{pane_current_path}'"
```

### Script the Workflow

```bash
#!/bin/bash
# review-and-commit.sh

# Run review
claude-review > /tmp/review.txt

# If approved, commit
if grep -q "ACCEPT" /tmp/review.txt; then
    git commit -m "feat: new feature"
else
    echo "Review not approved, fix issues first"
    cat /tmp/review.txt
fi
```

---

**[← Back to README](../README.md)** • **[Installation Guide →](INSTALL.md)** • **[Usage Guide →](USAGE.md)**
