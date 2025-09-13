# create docker images for Festivals-App

APP=undefined
# APP=festivals-metwork creates the docker network
# APP=festivals-identity-server creates the identity server
# ... etc ...

export BUILD=docker buildx build --progress=plain --no-cache
export ROOT=$(shell pwd)

include allservers.mk

ubuntu:
	${BUILD} -f ubuntu.dck --tag festivals-ubuntu .

certificates:
	${MAKE} -C festivals-certificates init all

festivals%: FORCE
	${MAKE} -C $@ all

checks:
	${MAKE} -C festivals-checks all run

upload:
	${MAKE} -C festivals-upload upload

FORCE: