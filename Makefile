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

.PHONY: setup
setup: ## Sets the executable permission for all .sh files.
	@echo "Setting execute permissions for all .sh files..."
	@find . -type f -name "*.sh" -exec chmod +x {} \; -exec echo "✓ Set executable: {}" \;
	@echo "Done!"

.PHONY: install
install: ## Run the install.sh script.
	@DOTFILE_HOME="$$(pwd)" ./scripts/install.sh

.PHONY: clean
clean: ## Revert dotfiles installation.
	@DOTFILE_HOME="$$(pwd)" ./scripts/clean.sh
