
# Name of application container
application_container_name = rightmartgroupexam-php-1

help: ## Show this help
	@echo "Available commands:"
	@grep -h -E '^[a-zA-Z0-9_\/-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-35s$(INDENT)\033[0m %s\n", $$1, $$2}'

build: ## Build containerized application
	docker compose build --no-cache

start: ## Start containerized application
	docker compose up -d

stop: ## Stop containerized application
	docker compose down --remove-orphans

bash: ## Bash into containerized application
	docker exec -it $(application_container_name) bash

db_migrate: ## Run database migration
	docker exec $(application_container_name) bin/console doctrine:migrations:migrate

db_diff_migrate: ## Run doctrine diff and migrate
	docker exec $(application_container_name) bin/console doctrine:migrations:diff --no-interaction

db_test_migrate: ## Run migration for app_test database
	docker exec $(application_container_name) bin/console doctrine:database:create --env=test

cache_clear: ## Cache clear
	docker exec $(application_container_name) bin/console cache:clear

setup: \
	db_migrate

sync_logs: ## Run service log syncer
	docker exec $(application_container_name) bin/console service_log:sync
	docker exec $(application_container_name) bin/console messenger:consume async -vv

watch:
	docker exec $(application_container_name) npm run watch
