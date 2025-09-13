# Create the festivals-upload

APP=festivals-upload
BUILD=docker buildx build

include ../develop.mk


certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/api-client.crt .
	cp ../festivals-certificates/pki/private/api-client.key .

upload: certs	
	./festivals-upload.pl

upload_demo: base server up

base:
	${BUILD} -f base.dck --tag my/${APP}-base .

server: certs
	${BUILD} -f configure.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down


