# Helper functions
define print_header
	@echo ""
	@echo "-------------------$(1)-------------------"
	@echo ""
endef

define print_success
	@echo "✓ $(1)"
endef

define print_warning
	@echo "⚠ $(1)"
endef

define print_error
	@echo "✗ $(1)"
endef

init: 
	@$(call print_header)
	@touch .env
	@$(call print_success,Created .env file)
	@cp .env.example .env
	@$(call print_success,Copied example .env file)
	@sed -i "s/INV_HMAC_KEY=/INV_HMAC_KEY=$$(pwgen 20 1)/" .env
	@sed -i "s/INV_COMPANION_KEY=/INV_COMPANION_KEY=$$(pwgen 16 1)/" .env
	@$(call print_success,Generated HMAC and Companion keys)
	@$(call print_header)
	@$(call print_success,Successfully initialized project!)
	@echo ""
	@echo "Please edit the .env file with your desired configuration before running 'make build'"

build:
	@if [ -z "$(1)" ]; then $(call print_error,Usage: make build [development|release]); exit 1; fi
	@$(call print_header,Building Invidious)
	@./scripts/patch.sh
	@$(call print_success,Applied patches)
	@./scripts/build.sh $(1)
	@$(call print_success,$(1) build created successfully)
	@echo ""
	@$(call print_success,Build complete)

start:
	@$(call print_info,Starting Docker containers...)
	@docker compose up -d
	@$(call print_success,Containers are up and running)

update:
	@echo "Pulling latest changes for submodules..."
	@$(call print_info,Updating Invidious submodules...)
	@./scripts/update.sh
	@$(call print_success,Invidious submodules updated successfully)

create-network:
	@./scripts/create-network.sh
	@$(call print_success,Gluetun network created)
	@echo "Follow this guide: https://docs.invidious.io/gluetun/"

init-db:
	@echo "Initializing database..."
	@./scripts/init-db.sh
	@$(call print_success,Database initialized successfully)

deploy-database:
	@echo "Deploying database..."
	@./scripts/deploy-database.sh
	@$(call print_success,Database deployed successfully)

message:
	@if [ ! -f .env ]; then $(call print_error,.env file not found. Run 'make init' first.); exit 1; fi
	@if [ -z "$(content)" ]; then $(call print_error,Usage: make message content=\"your message here\"); exit 1; fi
	@sed -i "s|INV_BANNER_MSG=.*|INV_BANNER_MSG=\"<p style='font-size:0.75em; text-align:center;'>$(content)</p>\"|" .env
	@$(call print_success,Banner message updated: $(content))

clear-message:
	@if [ ! -f .env ]; then $(call print_error,.env file not found. Run 'make init' first.); exit 1; fi
	@sed -i "s|INV_BANNER_MSG=.*|INV_BANNER_MSG=\"\"|" .env
	@$(call print_success,Banner message cleared)

docs:
	@$(call print_header,Docs)
	@echo "Repo: https://github.com/Jonathandah/invidious"
	@echo "Invidious docs: https://docs.invidious.io/"
	@echo "Invidious with Gluetun docs: https://docs.invidious.io/gluetun/"
