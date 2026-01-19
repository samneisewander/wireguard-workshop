YELLOW=\033[1;33m
GREEN=\033[1;32m
NC=\033[0m # No Color

WIREGUARD_DIR=wireguard
PRESENTER_DIR=presenter-materials

.PHONY: all configs stack clean

all: configs stack

configs: 
	@echo "$(YELLOW)Generating keys and config files...$(NC)"
	chmod +x generate_keys_configs.sh
	./generate_keys_configs.sh
	@echo "$(GREEN)done.$(NC)"

stack:
	@echo "$(YELLOW)Deploying docker stack...$(NC)"
	docker compose up -d  
	@echo "$(GREEN)done.$(NC)"

clean:
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker compose down
	rm -rf $(WIREGUARD_DIR) $(PRESENTER_DIR)
	@echo "$(GREEN)done.$(NC)"
