# Create the festivals-database

APP=festivals-database
BUILD=docker buildx build
CONFIG_TEMPLATE_URL=https://raw.githubusercontent.com/Festivals-App/${APP}/refs/heads/main/config_template.toml

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
	openssl x509 -in ca.crt -out ca.pem -outform PEM
	openssl x509 -in ${APP}.crt -out server-cert.pem -outform PEM
	openssl rsa -in ${APP}.key -text > server-key.pem

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

