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
				
restart: run enter

reup: up enter

enter:
	docker exec -it festivals-database /bin/bash

up: rm-festivals-database net-up
	docker compose --file database.yml up --detach
        
down:
	docker compose --file database.yml down

net-up:
	echo net-up
	docker inspect festivals >/dev/null 2>&1 || \
		docker network create festivals
	
############# Helpers ###############
configset:
	-mkdir configset

var.lib.mysql:
	mkdir var.lib.mysql

collect: configset var.lib.mysql
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/festivals-database.crt configset/server.crt
	cp ../certificates/pki/private/festivals-database.key configset/server.key
	cp ../certificates/pki/private/ca.key.pem var.lib.mysql/ca-key.pem
	cp ../certificates/pki/ca.crt.pem var.lib.mysql/ca.pem
	cp ../certificates/pki/issued/festivals-database.crt.pem var.lib.mysql/client-cert.pem
	cp ../certificates/pki/private/festivals-database.key.pem var.lib.mysql/client-key.pem
	cp ../certificates/pki/private/festivals-database.key.pem var.lib.mysql/private_key.pem
	cp ../certificates/pki/issued/festivals-database.crt.pem var.lib.mysql/public_key.pem
	cp ../certificates/pki/issued/festivals-database.crt.pem var.lib.mysql/server-cert.pem
	cp ../certificates/pki/private/festivals-database.key.pem var.lib.mysql/server-key.pem
	openssl rsa -in var.lib.mysql/private_key.pem -pubout -outform PEM -out var.lib.mysql/public_key.pem

