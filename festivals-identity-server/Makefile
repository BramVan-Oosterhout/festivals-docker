# Create the festivals-idenrity-server

APP=festivals-identity-server
BUILD=docker buildx build
CONFIG_TEMPLATE_URL=https://raw.githubusercontent.com/Festivals-App/festivals-identity-server/refs/heads/master/config_template.toml

include ../develop.mk

all: base server up

base: ${APP}.conf certs
	${BUILD} -f base.dck --tag my/${APP}-base .

${APP}.conf:
	curl -L -o ${APP}.conf ${CONFIG_TEMPLATE_URL}

certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/festivals-identity-server.crt .
	cp ../festivals-certificates/pki/private/festivals-identity-server.key .
	openssl x509 -in festivals-identity-server.crt \
				-out festivals-identity-server.authentication.publickey.pem -outform PEM
	openssl rsa -in festivals-identity-server.key -text | \
				tee festivals-identity-server.authentication.privatekey.pem

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up: net-up
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down


