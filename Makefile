YELLOW=\033[1;33m
GREEN=\033[1;32m
NC=\033[0m # No Color

.PHONY: all configs stack clean

all: configs stack

configs: 
	@echo "$(YELLOW)Generating keys and config files...$(NC)"
	chmod +x generate_keys_configs.sh
	./generate_keys_configs.sh
	@echo "$(GREEN)done.$(NC)"

.image: generate_keys_configs.sh html/* entrypoint.sh Dockerfile
	@echo "$(YELLOW)Rebuilding image...$(NC)"
	docker compose build --no-cache nginx-vpn
	touch .image
	@echo "$(GREEN)done.$(NC)"

stack: .image
	@echo "$(YELLOW)Deploying docker stack...$(NC)"
	docker compose up -d  
	@echo "$(GREEN)done.$(NC)"

clean:
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker compose down
	rm -rf keys
	@echo "$(GREEN)done.$(NC)"

clean-stamps:
	rm .image
