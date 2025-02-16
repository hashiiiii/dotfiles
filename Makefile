.PHONY: help
help:
	@echo "--------------------------------------------------------------------------"
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_.-]+:.*?##/ { \
		printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	}' $(MAKEFILE_LIST)
	@echo "--------------------------------------------------------------------------"

.PHONY: chmod
setup: ## Sets the executable permission for all .sh files.
	@echo "Setting permissions (755) for all .sh files..."
	@find . -type f -name "*.sh" -exec chmod 755 {} \; -exec echo "✓ Set 755: {}" \;
	@echo "Done!"

.PHONY: install
install: ## Run the install.sh script.
	@DOTFILE_HOME="$$(pwd)" ./scripts/install.sh

.PHONY: restore
restore: ## Restore dotfiles from backup. Optional: specify BACKUP=timestamp
	@DOTFILE_HOME="$$(pwd)" BACKUP_TIMESTAMP="$(BACKUP)" ./scripts/restore.sh
