YELLOW=\033[1;33m
GREEN=\033[1;32m
NC=\033[0m # No Color


all:
	@echo "$(YELLOW)Generating keys and config files...$(NC)"
	chmod +x generate_keys_configs.sh
	./generate_keys_configs.sh
	@echo "$(GREEN)done.$(NC)"
	@echo "$(YELLOW)Deploying docker stack...$(NC)"
	docker compose up
	@echo "$(GREEN)done.$(NC)"

clean:
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker compose down
	rm -rf keys
	@echo "$(GREEN)done.$(NC)"
