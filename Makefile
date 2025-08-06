# create docker images for Festivals-App

APP=undefined
# APP=festivals-metwork creates the docker network
# APP=festivals-identity-server creates the identity server
# ... etc ...

export BUILD=docker buildx build --progress=plain --no-cache
export ROOT=$(shell pwd)
SERVERS=festivals-identity-server festivals-gateway \
	festivals-fileserver festivals-database festivals-server

all: ubuntu certificates ${SERVERS} checks

ubuntu:
	${BUILD} -f ubuntu.dck --tag festivals-ubuntu .

certificates: FORCE
	${MAKE} -C certificates init all

festivals%: FORCE
	${MAKE} -C $@ all

checks:
	${MAKE} -C _festivals-checks all run


base:
	${MAKE} -C ${APP} base

net-up:
	${MAKE} -C ${APP} net-up

server:
	${MAKE} -C ${APP} server

up: 
	${MAKE}  ${APP} up

down:
	${MAKE} down ${APP
	}

FORCE: