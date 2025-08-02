# Create the festivals-server

APP=festivals-server
BUILD=docker buildx build
CONFIG_TEMPLATE_URL=https://raw.githubusercontent.com/Festivals-App/${APP}/refs/heads/main/config_template.toml

include ../develop.mk

base: ${APP}.conf
	${BUILD} -f base.dck --tag my/${APP}-base .

${APP}.conf:
	curl -L -o ${APP}.conf ${CONFIG_TEMPLATE_URL}

certs:
	cp ../certificates/pki/ca.crt .
	cp ../certificates/pki/issued/${APP}.crt .
	cp ../certificates/pki/private/${APP}.key .
	cp ../certificates/pki/issued/FestivalsAppDatabaseClient.crt database-client.crt
	cp ../certificates/pki/private/FestivalsAppDatabaseClient.key database-client.key

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

