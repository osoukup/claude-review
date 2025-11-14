# Usage Guide

Complete guide to using claude-review for AI-powered code reviews.

**[← Back to README](../README.md)**

## Table of Contents

- [Basic Usage](#basic-usage)
- [Command Line Options](#command-line-options)
- [Understanding Output](#understanding-output)
- [Piping and Scripting](#piping-and-scripting)
- [Makefile Commands](#makefile-commands)
- [Use Cases](#use-cases)
- [Tips and Best Practices](#tips-and-best-practices)

## Basic Usage

### Review Current Branch

Review all commits since main/master:

```bash
claude-review
```

The tool automatically:
1. Detects if you're using `main` or `master` as base branch
2. Extracts changes since that branch
3. Sends them to Claude for review
4. Displays a formatted report

### Review Against Specific Branch

```bash
claude-review --base-branch develop
claude-review --base-branch feature/base
```

## Command Line Options

```
Usage: claude-review [OPTIONS]

OPTIONS:
    -b, --base-branch BRANCH    Specify base branch (default: auto-detect main/master)
    -h, --help                  Show help message
    --version                   Show version information

EXAMPLES:
    claude-review                      # Review changes since main/master
    claude-review -b develop           # Review changes since develop branch
```

## Understanding Output

### Terminal Output (Interactive)

When run in a terminal, you get colorful, formatted output:

```
╔════════════════════════════════════════════════════════════╗
║          AI-Assisted Code Review with Claude               ║
╚════════════════════════════════════════════════════════════╝

Base branch:     main
Current branch:  feature/new-feature
Commits:         3

 ⠹  Analyzing changes with Claude...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Summary
Brief overview of changes

Issues Found

Critical Issues
  • src/auth.js:42: SQL injection vulnerability

Warnings
  • src/api.js:28: Inefficient database query

Suggestions
  • Consider adding unit tests for new functions

Recommendation
REJECT: Critical security issues must be fixed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Review completed successfully
```

### Piped Output (Non-Interactive)

When output is piped or redirected, you get clean text:

```bash
claude-review > review.txt
```

Output is:
- Plain text (no ANSI color codes)
- No decorative boxes or spinners
- Progress messages go to stderr (not in the file)
- Easy to parse and process

### Recommendations

The tool provides one of three recommendations:

- **REJECT** (Red) - Critical issues that must be fixed
- **POLISH** (Yellow) - Minor issues, author's discretion
- **ACCEPT** (Green) - No significant issues

## Piping and Scripting

### Save to File

```bash
# Save review to file
claude-review > review.txt

# Save with errors
claude-review > review.txt 2>&1
```

### Search Output

```bash
# Find critical issues
claude-review | grep -i "critical"

# Find specific file mentions
claude-review | grep "auth.js"

# Count issues
claude-review | grep -c "Issue"
```

### Use in Scripts

```bash
#!/bin/bash

# Exit if review finds critical issues
if claude-review | grep -q "REJECT"; then
    echo "❌ Code review failed - critical issues found"
    exit 1
fi

echo "✅ Code review passed"
```

### CI/CD Integration

```yaml
# GitHub Actions example
- name: AI Code Review
  run: |
    if claude-review | grep -q "REJECT"; then
      echo "::error::AI code review found critical issues"
      exit 1
    fi
```

```bash
# GitLab CI example
code-review:
  script:
    - claude-review > review.txt
    - if grep -q "REJECT" review.txt; then exit 1; fi
  artifacts:
    paths:
      - review.txt
    when: always
```

## Makefile Commands

The Makefile provides convenient shortcuts:

### Testing Commands

```bash
# Test in current directory
make test

# Test in specific repository
make test REPO=/path/to/repo

# Test against specific branch
make test-branch BRANCH=develop

# Test in different repo with custom branch
make test-branch REPO=/path/to/repo BRANCH=develop
```

### Utility Commands

```bash
# Show all available commands
make help

# Check dependencies
make check-deps

# Show claude-review help
make tool-help

# Show version
make version

# Run syntax checks
make dev-test

# Clean temporary files
make clean
```

## Use Cases

### Pre-Commit Reviews

Check your changes before committing:

```bash
# Review your work
claude-review

# If issues found, fix them
# ... make fixes ...

# Review again
claude-review
```

### Pre-PR Reviews

Validate changes before creating a pull request:

```bash
# Switch to your feature branch
git checkout feature/my-feature

# Review changes since main
claude-review

# Address any issues before creating PR
```

### Learning Tool

Understand potential issues in your code:

```bash
# Get AI feedback on your implementation
claude-review

# Learn from suggestions
# Read through warnings and suggestions
```

### Second Opinion

Get AI feedback on implementation choices:

```bash
# After implementing a feature
claude-review

# Consider the suggestions
# Decide which to implement
```

### Different Base Branches

```bash
# Review against develop branch
claude-review --base-branch develop

# Review against release branch
claude-review --base-branch release/v2.0

# Review against specific tag
claude-review --base-branch v1.0.0
```

## Tips and Best Practices

### When to Run Reviews

✅ **Good times:**
- Before committing
- Before creating a PR
- After implementing a complex feature
- When learning a new technology

❌ **Not ideal:**
- On very large changesets (>1000 lines)
- On generated code
- On third-party dependencies

### Interpreting Results

**Critical Issues:**
- Take seriously - likely real problems
- Fix before merging
- Security and logic errors

**Warnings:**
- Consider carefully
- May be valid concerns
- Use your judgment

**Suggestions:**
- Nice-to-haves
- Often about best practices
- Implement if time permits

### Large Changesets

For large changes, break into smaller PRs:

```bash
# Break work into smaller feature branches
# Review each PR separately for better results
# claude-review works best on <500 line changes
```

### Combine with Human Review

AI review complements (not replaces) human review:

1. Run `claude-review` first
2. Fix obvious issues
3. Still do peer review
4. AI catches different things than humans

### Save Reviews for Reference

```bash
# Save with timestamp
claude-review > "review-$(date +%Y%m%d-%H%M%S).txt"

# Save with branch name
claude-review > "review-$(git branch --show-current).txt"
```

## Limitations

- **Requires internet** - Claude CLI needs API access
- **Not instant** - Reviews take 10-30 seconds
- **AI limitations** - May miss context or make mistakes
- **Best for smaller changes** - Works best on <500 line changes
- **Not a replacement** - Complements human review

## Getting Help

```bash
# Show help
claude-review --help
make help

# Check if everything is working
make check-deps

# Test in a safe repo
make test REPO=/path/to/test/repo
```

---

**[← Back to README](../README.md)** • **[Installation Guide →](INSTALL.md)** • **[Tmux Integration →](TMUX.md)**
