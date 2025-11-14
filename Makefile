.PHONY: help install uninstall test test-local version check-deps clean dev-test

# Default target - show available commands
.DEFAULT_GOAL := help

# Variables
SCRIPT_NAME := claude-review
REPO ?= .

help: ## Show this help message
	@echo "Claude-Review - AI-Assisted Code Review Tool"
	@echo ""
	@echo "Usage: make [target] [REPO=/path/to/repo]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make install              # Install using Ansible"
	@echo "  make test                 # Test in current directory"
	@echo "  make test REPO=/path/to/repo  # Test in specific repository"
	@echo "  make tool-help            # Show claude-review help"

install: ## Install claude-review to user space using Ansible
	@echo "Installing claude-review to ~/.local/bin..."
	ansible-playbook ansible/install.yml
	@echo ""
	@echo "Installation complete! Run 'claude-review --help' to get started."
	@echo "In tmux: Use prefix + r to open in popup window"

uninstall: ## Uninstall claude-review using Ansible
	@echo "Uninstalling claude-review from ~/.local/bin..."
	ansible-playbook ansible/uninstall.yml
	@echo ""
	@echo "Uninstallation complete!"

test: ## Run claude-review in specified repository (use REPO=/path/to/repo)
	@echo "Testing claude-review in repository: $(REPO)"
	@if [ ! -d "$(REPO)" ]; then \
		echo "Error: Directory $(REPO) does not exist"; \
		exit 1; \
	fi
	@cd "$(REPO)" && $(PWD)/src/$(SCRIPT_NAME)

test-local: ## Run claude-review in current repository (shortcut for test REPO=.)
	@$(MAKE) test REPO=.

test-branch: ## Run claude-review with custom base branch (use REPO=/path BRANCH=develop)
	@if [ -z "$(BRANCH)" ]; then \
		echo "Error: BRANCH variable is required. Usage: make test-branch BRANCH=develop"; \
		exit 1; \
	fi
	@echo "Testing claude-review in repository: $(REPO) against branch: $(BRANCH)"
	@if [ ! -d "$(REPO)" ]; then \
		echo "Error: Directory $(REPO) does not exist"; \
		exit 1; \
	fi
	@cd "$(REPO)" && $(PWD)/src/$(SCRIPT_NAME) --base-branch $(BRANCH)

tool-help: ## Show claude-review help message
	@./src/$(SCRIPT_NAME) --help

version: ## Show claude-review version
	@./src/$(SCRIPT_NAME) --version

check-deps: ## Check if all dependencies are installed
	@echo "Checking dependencies..."
	@command -v git >/dev/null 2>&1 || { echo "  ✗ git not found"; exit 1; }
	@echo "  ✓ git found"
	@command -v claude >/dev/null 2>&1 || { echo "  ⚠ claude CLI not found (required for running)"; }
	@command -v claude >/dev/null 2>&1 && echo "  ✓ claude CLI found"
	@command -v ansible-playbook >/dev/null 2>&1 || { echo "  ⚠ ansible not found (required for install/uninstall)"; }
	@command -v ansible-playbook >/dev/null 2>&1 && echo "  ✓ ansible found"
	@command -v tmux >/dev/null 2>&1 || { echo "  ⚠ tmux not found (optional - for popup integration)"; }
	@command -v tmux >/dev/null 2>&1 && echo "  ✓ tmux found"
	@echo ""
	@echo "Dependencies check complete!"

clean: ## Remove temporary files
	@echo "Cleaning up temporary files..."
	@find . -type f -name "*.tmp" -delete
	@find . -type f -name "*~" -delete
	@echo "Cleanup complete!"

dev-test: ## Run a quick development test (checks script syntax)
	@echo "Running development tests..."
	@bash -n src/$(SCRIPT_NAME) && echo "✓ Bash syntax check passed" || exit 1
	@bash -n src/$(SCRIPT_NAME)-tmux && echo "✓ Bash syntax check passed (tmux wrapper)" || exit 1
	@echo "All tests passed!"
