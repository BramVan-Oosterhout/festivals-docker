# Create the festivals-UI

APP=festivals-ui
BUILD=docker buildx build
FOSWIKI_YML=https://raw.githubusercontent.com/timlegge/docker-foswiki/refs/heads/master/docker-compose.1-simple.yml
FOSWIKI_ENTRYPOINT=https://raw.githubusercontent.com/timlegge/docker-foswiki/refs/heads/master/docker-entrypoint.sh

include ../develop.mk

all: base server up

${APP}.yml:
	curl -L -o ${APP}.yml ${FOSWIKI_YML}

base: ${APP}.yml
	${BUILD} -f base.dck --tag my/${APP}-base .

entrypoint.sh:
	curl -L -o entrypoint.sh ${FOSWIKI_ENTRYPOINT}

certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/api-client.crt .
	cp ../festivals-certificates/pki/private/api-client.key .

server: certs entrypoint.sh
	${BUILD} -f configure.dck --tag my/${APP} . 

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

