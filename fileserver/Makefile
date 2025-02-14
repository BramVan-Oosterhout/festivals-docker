# create docker image for festivals-database

fileserver: 
	echo mkdir fileserver
	mkdir fileserver

install.sh:
	curl -L -o install.sh https://github.com/Festivals-App/festivals-fileserver/raw/master/operation/install.sh

base: rm-base install.sh
	docker build --progress=plain --no-cache -f base.dck --tag my/base_fileserver .
rm-base:
	-docker rmi my/base_fileserver

configure: collect
	docker build --progress=plain --no-cache -f configure.dck --tag my/fileserver .

rm-festivals-fileserver:
	-docker rm -f festivals-fileserver

run: rm-festivals-fileserver
	docker run --name festivals-fileserver \
				--detach \
				my/fileserver
				
restart: run enter

reup: up enter

enter:
	docker exec -it festivals-fileserver /bin/bash

up: rm-festivals-fileserver net-up
	docker compose --file fileserver.yml up --detach
        
down:
	docker compose --file fileserver.yml down

net-up:
	echo net-up
	docker inspect festivals >/dev/null 2>&1 || \
		docker network create festivals
	
############# Helpers ###############
configset:
	-mkdir configset

collect: configset
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/festivals-fileserver.crt configset/server.crt
	cp ../certificates/pki/private/festivals-fileserver.key configset/server.key
