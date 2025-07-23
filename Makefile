# create docker images for Festivals-App

APP=undefined
# APP=festivals-metwork creates the docker network
# APP=festivals-identity-server creates the identity server
# ... etc ...

export BUILD=docker buildx build --progress=plain --no-cache

ubuntu:
	${BUILD} -f ubuntu.dck --tag festivals-ubuntu .

base:
	${MAKE} base -C ${APP}

net-up:
	${MAKE} net-up -C ${APP}

server:
	${MAKE} server -C ${APP}

up: 
	${MAKE} up ${APP}

down:
	${MAKE} down ${APP
	}
###############################
gateway: 
	echo mkdir gateway
	mkdir gateway

install.sh:
	curl -L -o install.sh https://github.com/Festivals-App/festivals-gateway/raw/main/operation/install.sh

#base: rm-base install.sh
#	docker build --progress=plain --no-cache -f base.dck --tag my/base_gateway .
rm-base:
	-docker rmi my/base_gateway

configure: collect
	docker build --progress=plain --no-cache -f configure.dck --tag my/gateway .

rm-festivals-gateway:
	-docker rm -f festivals-gateway

run: rm-festivals-gateway
	docker run --name festivals-gateway \
				--detach \
				my/gateway
				
restart: run enter

reup: up enter

enter:
	docker exec -it festivals-gateway /bin/bash

_up: rm-festivals-gateway net-up
	docker compose --file gateway.yml up --detach
        
down:
	docker compose --file gateway.yml down

net-up.OFF:
	echo net-up
	docker inspect festivals >/dev/null 2>&1 || \
		docker network create festivals
	
############# Helpers ###############
configset:
	-mkdir configset

collect: configset
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/festivals-gateway.crt configset/server.crt
	cp ../certificates/pki/private/festivals-gateway.key configset/server.key


update:
	mkdir update

update-exe: update
	cp ../../festivals-gateway/festivals-gateway update/festivals-gateway
	docker cp update/festivals-gateway festivals-gateway:/usr/local/bin/festivals-gateway
