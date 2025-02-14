# create docker image for festivals-database

identity: 
	echo mkdir identity
	mkdir identity

install.sh: 
	curl -L -o install.sh https://github.com/Festivals-App/festivals-identity-server/raw/master/operation/install.sh

base: rm-base
	docker build --progress=plain --no-cache -f base.dck --tag my/base_identity .
rm-base:
	-docker rmi my/base_identity

configure: collect
	docker build --progress=plain --no-cache -f configure.dck --tag my/identity .

rm-festivals-identity:
	-docker rm -f festivals-identity

run: rm-festivals-identity
	docker run --name festivals-identity \
				--detach \
				my/identity
				
restart: run enter

reup: up enter

enter:
	docker exec -it festivals-identity /bin/bash

up: rm-festivals-identity
	docker compose --file identity.yml up --detach
        
down:
	docker compose --file identity.yml down


net-up:
	echo net-up
	docker network create festivals


	
############# Helpers ###############
configset:
	-mkdir configset

collect: configset
	##FOR MYSQL
	cp ../certificates/pki/ca.crt.pem configset/ca.pem
	cp ../certificates/pki/private/ca.key.pem configset/ca-key.pem
	cp ../certificates/pki/issued/localhost.crt.pem configset/.
	cp ../certificates/pki/private/localhost.key.pem configset/.

	## FOR IDENTITY SERVER
	cp ../certificates/pki/issued/localhost.crt.pem configset/authentication.pem
	cp ../certificates/pki/private/localhost.key.pem configset/authentication-key.pem
	cp ../certificates/pki/ca.crt configset/ca.crt
	cp ../certificates/pki/issued/festivals-identity.crt configset/server.crt
	cp ../certificates/pki/private/festivals-identity.key configset/server.key
#	cp ../../festivals-identity-server/config_template.toml CONFIGURATION MISMATCH WITH EXECUTABLE

update:
	mkdir update
update-exe: update
	cp ../../festivals-identity-server/festivals-identity-server update/festivals-identity-server
	docker cp update/festivals-identity-server festivals-identity:/usr/local/bin/festivals-identity-server

######################
##
## NOTE: public key == certificate; private key == key
# X509 defines the format of the public key certificate
# The public key is encrypted with the RSA algorithm ( or other: DSA, ECDSA ...)
# The public key can be in a container. The container has the PEM format
# Private keys are usually stored in PEM containers
# Ref: https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file/9717#9717

## EASYRSA
# ./easyrsa --passout=file:pwd --passin=file:pwd build-ca
# - ca.key = -----BEGIN ENCRYPTED PRIVATE KEY----- {etc}
# - ca.crt = -----BEGIN CERTIFICATE-----    {etc}
# openssl rsa -in pki/private/ca.key -text > pki/private/ca.key.pem
#  - ca.key.pem = Private-Key: (2048 bit, 2 primes)
#              ... -----BEGIN PRIVATE KEY----- {etc}
# openssl x509 -outform PEM -in pki/ca.crt > pki/ca.crt.pem
#  - ca.crt/pem = -----BEGIN CERTIFICATE----- {etc}
# ./easyrsa --passin=file:pwd build-serverClient-full $* nopass
# - localhost.key = -----BEGIN PRIVATE KEY----- {etc}
# - localhost.crt = Certificate:
#                 -----BEGIN CERTIFICATE----- {etc}
# openssl rsa -in pki/private/$*.key -text > pki/private/$@
# - localhost.key.pem = Private-Key: (2048 bit, 2 primes)
#                     -----BEGIN PRIVATE KEY----- {etc}
# openssl x509 -outform PEM -in pki/issued/$*.crt > pki/issued/$@
# - localhost,crt.pem = -----BEGIN CERTIFICATE-----







