# Create the festivals-UI

APP=festivals-UI
BUILD=docker buildx build
FOSWIKI_YML=https://raw.githubusercontent.com/timlegge/docker-foswiki/refs/heads/master/docker-compose.1-simple.yml

include ../develop.mk

all: base server up

base:
	curl -L -o ${APP}.yml ${FOSWIKI_YML}

certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/${APP}.crt .
	cp ../festivals-certificates/pki/private/${APP}.key .

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

