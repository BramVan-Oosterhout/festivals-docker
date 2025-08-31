# Create the festivals-fileserver

APP=festivals-fileserver
BUILD=docker buildx build
CONFIG_TEMPLATE_URL=https://raw.githubusercontent.com/Festivals-App/${APP}/refs/heads/master/config_template.toml

include ../develop.mk

all: base server up

base: ${APP}.conf
	${BUILD} -f base.dck --tag my/${APP}-base .

${APP}.conf:
	curl -L -o ${APP}.conf ${CONFIG_TEMPLATE_URL}

certs:
	cp ../certificates/pki/ca.crt .
	cp ../certificates/pki/issued/${APP}.crt .
	cp ../certificates/pki/private/${APP}.key .

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

