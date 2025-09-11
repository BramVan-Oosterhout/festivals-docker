APP=festivals-checks
BUILD=docker buildx build

include ../develop.mk

all: checks up

certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/FestivalsAppDatabaseClient.crt api-client.crt
	cp ../festivals-certificates/pki/private/FestivalsAppDatabaseClient.key api-client.key

checks: certs
	${BUILD} -f checks.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

run:
	docker exec -it ${APP} /bin/bash -c "/home/build/all-check.sh"

