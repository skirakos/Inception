all: create_dirs up

create_dirs:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress

re: fclean all

up:
	@docker compose -f ./srcs/docker-compose.yml up -d --build 

down:
	@docker compose -f ./srcs/docker-compose.yml down

clean: down
	@docker volume ls -q | grep -E 'srcs_adminer_volume|srcs_db_volume|srcs_redis_volume|srcs_wp_volume' | xargs -r docker volume rm
	@rm -rf /home/$(USER)/data/wordpress
	@rm -rf /home/$(USER)/data/mariadb

fclean: clean
	@docker images -q | xargs -r docker rmi -f

.PHONY: all re up down create_dirs fclean clean
