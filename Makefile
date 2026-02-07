SHELL := /usr/bin/bash

# Color codes (Move these to the top so they are defined before they are used)
RESET = \033[0m
GREEN = \033[32m
YELLOW = \033[33m
RED = \033[31m
BLUE = \033[34m

# Timestamp format: [YYYY-MM-DD HH:MM:SS]
timestamp := $(shell date "+[%Y-%m-%d %H:%M:%S]")

# Helper functions for logging with colors and timestamp
define log_info
	printf "%s [INFO] %s\n" "$(timestamp)" "$(1)"
endef

define log_success
	printf "%s $(GREEN)[SUCCESS]$(RESET) %s\n" "$(timestamp)" "$(1)"
endef

define log_warning
	printf "%s $(YELLOW)[WARNING]$(RESET) %s\n" "$(timestamp)" "$(1)"
endef

define log_error
	printf "%s $(RED)[ERROR]$(RESET) %s\n" "$(timestamp)" "$(1)"
endef

# Targets
init: 
	@echo ""
	@touch .env
	@$(call log_success,Created .env file)
	@cp .env.example .env
	@$(call log_success,Copied example .env file)
	@sed -i "s/INV_HMAC_KEY=/INV_HMAC_KEY=$$(pwgen 20 1)/" .env
	@sed -i "s/INV_COMPANION_KEY=/INV_COMPANION_KEY=$$(pwgen 16 1)/" .env
	@$(call log_success,Generated HMAC and Companion keys)
	@$(call log_success,Successfully initialized project!)
	@echo ""
	@echo "Please edit the .env file with your desired configuration before running 'make build'"

build-image:
	@if [ -z "$(ENV)" ]; then $(call log_error,Usage: make build [development|release]); exit 1; fi
	@$(call log_info,Building Invidious)
	@./scripts/patch.sh
	@$(call log_success,Applied patches)
	@./scripts/build.sh $(ENV)
	@$(call log_success,$(ENV) build created successfully)
	@echo ""
	@$(call log_success,Build complete)

start:
	@echo "Starting Docker containers..."
	@docker compose up -d
	@$(call log_success,Containers are up and running)

update:
	@echo "Pulling latest changes for submodules..."
	@./scripts/update.sh
	@$(call log_success,Invidious submodules updated successfully)

create-patch:
	@echo "Creating patch for Invidious..."
	@./scripts/create-patch.sh
	@$(call log_success,Patch created successfully)

create-network:
	@echo "Creating Gluetun network..."
	@./scripts/create-network.sh
	@$(call log_success,Gluetun network created)
	@echo "Follow this guide: https://docs.invidious.io/gluetun/"

init-db:
	@echo "Initializing database..."
	@./scripts/init-db.sh
	@$(call log_success,Database initialized successfully)

deploy-db:
	@echo "Deploying database..."
	@./scripts/deploy-database.sh
	@$(call log_success,Database deployed successfully)

message:
	@if [ ! -f .env ]; then $(call log_error,.env file not found. Run 'make init' first.); exit 1; fi
	@if [ -z "$(CONTENT)" ]; then $(call log_error,Usage: make message CONTENT=\"your message here\"); exit 1; fi
	@sed -i "s|INV_BANNER_MSG=.*|INV_BANNER_MSG=\"<p style='font-size:0.75em; text-align:center;'>$(CONTENT)</p>\"|" .env
	@$(call log_success,Banner message updated: $(CONTENT))

clear-message:
	@if [ ! -f .env ]; then $(call log_error,.env file not found. Run 'make init' first.); exit 1; fi
	@sed -i "s|INV_BANNER_MSG=.*|INV_BANNER_MSG=\"\"|" .env
	@$(call log_success,Banner message cleared)

docs:
	@echo ""
	@echo "Read more at:"
	@echo ""
	@echo "Repo: https://github.com/Jonathandah/invidious"
	@echo "Invidious docs: https://docs.invidious.io/"
	@echo "Invidious with Gluetun docs: https://docs.invidious.io/gluetun/"


