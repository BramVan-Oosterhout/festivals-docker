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
	sleep 5
checks:
	${MAKE} -C festivals-checks all run

upload_demo:
	${MAKE} -C festivals-upload base server up

prompt:
	@echo Open web site with http://localhost:8765
	@echo Login as user: admin with password: insecure.

FORCE: