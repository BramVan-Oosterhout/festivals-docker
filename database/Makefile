# create docker image for festivals-database

database: 
	echo mkdir database
	mkdir database

install.sh: install-node.sh
	curl -L -o install.sh https://github.com/Festivals-App/festivals-database/raw/main/operation/install_database.sh

install_node.sh: 
	curl -o install_node.sh https://raw.githubusercontent.com/Festivals-App/festivals-database/main/operation/install_node.sh

base: rm-base
	docker build --progress=plain --no-cache -f base.dck --tag my/base_database .
rm-base:
	-docker rmi my/base_database

configure: collect
	docker build --progress=plain --no-cache -f configure.dck --tag my/database .

rm-festivals-database:
	-docker rm -f festivals-database

run: rm-festivals-database
	docker run --name festivals-database \
				--detach \
				my/database
				
restart: run
	docker exec -it festivals-database /bin/bash


net-up:
	echo net-up
	docker network create festivals
	
############# Helpers ###############
configset:
	-mkdir configset

collect: configset
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/localhost.crt configset/server.crt
	cp ../certificates/pki/private/localhost.key configset/server.key
	cp ../../festivals-database/config_template.toml festivals-database-node.conf
