APP=festivals-checks
BUILD=docker buildx build 

include ../develop.mk

certs:
	cp ../certificates/pki/ca.crt .
	cp ../certificates/pki/issued/api-client.crt .
	cp ../certificates/pki/private/api-client.key .

checks: certs
	${BUILD} -f checks.dck --tag my/${APP} .

up:
	docker compose --file ${APP}.yml up --detach

down:
	docker compose --file ${APP}.yml down

