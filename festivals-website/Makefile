# Create the festivals-website

APP=festivals-website
BUILD=docker buildx build
CONFIG_TEMPLATE_URL=https://raw.githubusercontent.com/Festivals-App/${APP}/refs/heads/master/config_template.toml

include ../develop.mk

all: base server up

base: ${APP}-node.conf
	${BUILD} -f base.dck --tag my/${APP}-base .

${APP}-node.conf:
	curl -L -o ${APP}-node.conf ${CONFIG_TEMPLATE_URL}

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

