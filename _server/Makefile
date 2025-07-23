# create docker image for festivals-database

server: 
	echo mkdir server
	mkdir server

install.sh:
	curl -L -o install.sh https://github.com/Festivals-App/festivals-server/raw/main/operation/install.sh

base: rm-base install.sh
	docker build --progress=plain --no-cache -f base.dck --tag my/base_server .
rm-base:
	-docker rmi my/base_server

configure: collect
	docker build --progress=plain --no-cache -f configure.dck --tag my/server .

rm-festivals-server:
	-docker rm -f festivals-server

run: rm-festivals-server
	docker run --name festivals-server \
				--detach \
				my/server
				
restart: run enter

reup: up enter

enter:
	docker exec -it festivals-server /bin/bash

up: rm-festivals-server net-up
	docker compose --file server.yml up --detach
        
down:
	docker compose --file server.yml down

net-up:
	echo net-up
	docker inspect festivals >/dev/null 2>&1 || \
		docker network create festivals
	
############# Helpers ###############
configset:
	-mkdir configset

collect: configset
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/festivals-server.crt configset/server.crt
	cp ../certificates/pki/private/festivals-server.key configset/server.key
	cp ../certificates/pki/private/festivals-database.key.pem configset/database-client.key
	cp ../certificates/pki/issued/festivals-database.crt.pem configset/database-client.crt

update:
	mkdir update

update-exe: update
	cp ../../festivals-server/festivals-server update/.
	docker cp update/festivals-server festivals-server:/usr/local/bin/.
