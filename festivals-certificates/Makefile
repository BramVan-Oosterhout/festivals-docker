
EASYRSA=/usr/share/easy-rsa

DOMAINS= localhost \
		festivals-identity-server \
		festivals-database \
		festivals-fileserver \
		festivals-gateway \
		festivals-server \
		festivals-website \
		api-client \
		FestivalsAppDatabaseClient

KEYS = $(patsubst %,%.key,${DOMAINS})
CRTS = $(patsubst %,%.crt,${DOMAINS})
PEMS = $(patsubst %,%.pem,${CRTS} ${KEYS})

vpath %.key pki/private
vpath %.crt pki/issued
vpath %.pem pki/private:pki/issued

# Certificate reference: https://www.microfocus.com/documentation/enterprise-developer/ed60/ED-Eclipse/BKCJCJCERTS001.html

all: ${PEMS}
crts: ${CRTS}
		
%.crt %.key : 
	$(eval SAN=$(shell cat ../$*/hostlist))
#	if [ -e ../$*/hostlist ]; then echo "--subject-alt-name=../$*/hostlist exists"; fi
	./easyrsa ${SAN} --passin=file:pwd build-serverClient-full "$*" nopass
#	./easyrsa --passin=file:pwd --passout=file:pwd build-serverClient-full $* nopass

%.key.pem : %.key
	openssl rsa -in pki/private/$*.key --passin=file:pwd -text > pki/private/$@

%.crt.pem : %.crt
	openssl x509 -outform PEM -in pki/issued/$*.crt > pki/issued/$@

init: clean pwd easyrsa
	./easyrsa init-pki
	EASYRSA_BATCH=1 ./easyrsa --passout=file:pwd --passin=file:pwd build-ca
	openssl rsa -in pki/private/ca.key --passin=file:pwd -text > pki/private/ca.key.pem
	openssl x509 -outform PEM -in pki/ca.crt > pki/ca.crt.pem

clean:
	-rm -r pki easyrsa pwd
	
easyrsa:
	sudo apt-get update && sudo apt-get -y install easy-rsa
	cp -r ${EASYRSA}/* .

pwd:
	echo 'insecure' > pwd

########## HOW MYSQL CERTIFICATES ARE MARKED 
## public_key: -----BEGIN PUBLIC KEY-----
## private_key: -----BEGIN PRIVATE KEY-----
## client-key: -----BEGIN PRIVATE KEY-----
## client-cert: -----BEGIN CERTIFICATE-----
## server-key: -----BEGIN PRIVATE KEY-----
## server-cert: -----BEGIN CERTIFICATE-----
	