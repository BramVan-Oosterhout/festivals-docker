
EASYRSA=/usr/share/easy-rsa

## NOTE
DOMAINS_NEW= localhost \
		$(shell cd ..; ls -d festivals* )

DOMAINS= localhost \
		festivals-identity \
		festivals-database \
		festivals-fileserver \
		festivals-gateway \
		festivals-server 
		
DOMAINS_OLD= localhost \
		gateway.festivalsapp.dev \
		identity-0.festivalsapp.dev \
		festivals-0.festivalsapp.dev \
		database-0.festivalsapp.dev \
		fileserver-0.festivalsapp.dev \
		website-0.festivalsapp.dev \
		mysql.festivalsapp.dev \
		festivalsapp.org \
		test.dev

KEYS = $(patsubst %,%.key,${DOMAINS})
CRTS = $(patsubst %,%.crt,${DOMAINS})
PEMS = $(patsubst %,%.pem,${CRTS} ${KEYS})

vpath %.key pki/private
vpath %.crt pki/issued
vpath %.pem pki/private:pki/issued

# Certificate reference: https://www.microfocus.com/documentation/enterprise-developer/ed60/ED-Eclipse/BKCJCJCERTS001.html

test:
	echo ${DOMAINS_NEW}



all: ${PEMS}
crts: ${CRTS}
		
%.crt %.key : 
	if [ -e ../$*/hostlist ]; then echo "--subject-alt-name=../$*/hostlist exists"; fi
	./easyrsa --passin=file:pwd build-serverClient-full $* nopass
#	./easyrsa --passin=file:pwd --passout=file:pwd build-serverClient-full $* nopass

%.key.pem : %.key
	openssl rsa -in pki/private/$*.key -text > pki/private/$@

%.crt.pem : %.crt
	openssl x509 -outform PEM -in pki/issued/$*.crt > pki/issued/$@

init: clean pwd easyrsa
	./easyrsa init-pki
	EASYRSA_BATCH=1 ./easyrsa --passout=file:pwd --passin=file:pwd build-ca
	openssl rsa -in pki/private/ca.key -text > pki/private/ca.key.pem
	openssl x509 -outform PEM -in pki/ca.crt > pki/ca.crt.pem

clean:
	-rm -r pki easyrsa pwd
	
easyrsa:
	sudo apt-get update && sudo apt-get -y install easy-rsa
	cp -r ${EASYRSA}/* .

pwd:
	echo 'insecure' > pwd

verify:
	openssl rsa -inform PEM -check -noout -in pki/private/ca.key.pem
	openssl rsa -inform PEM -check -noout -in pki/private/mysql.festivalsapp.dev.key.pem
	openssl rsa -inform PEM -check -noout -in pki/private/client.mysql.festivalsapp.dev.key.pem
	openssl rsa -inform PEM -check -noout -in pki/private/mysql.festivalsapp.dev.private_key.pem
	openssl rsa -inform PEM -pubin -noout -in pki/private/mysql.festivalsapp.dev.public_key.pem
	openssl verify -CAfile pki/issued/ca.crt.pem pki/issued/ca.crt.pem
	openssl verify -CAfile pki/issued/ca.crt.pem -purpose sslserver  pki/issued/mysql.festivalsapp.dev.crt.pem
	openssl verify -CAfile pki/issued/ca.crt.pem -purpose sslclient pki/issued/client.mysql.festivalsapp.dev.crt.pem

verify_ext:
	openssl x509 -inform PEM -purpose -noout -in pki/issued/ca.crt.pem
	openssl x509 -inform PEM -purpose -noout -in pki/issued/mysql.festivalsapp.dev.crt.pem
	openssl x509 -inform PEM -purpose -noout -in pki/issued/client.mysql.festivalsapp.dev.crt.pem
	

########## HOW MYSQL CERTIFICATES ARE MARKED 
## public_key: -----BEGIN PUBLIC KEY-----
## private_key: -----BEGIN PRIVATE KEY-----
## client-key: -----BEGIN PRIVATE KEY-----
## client-cert: -----BEGIN CERTIFICATE-----
## server-key: -----BEGIN PRIVATE KEY-----
## server-cert: -----BEGIN CERTIFICATE-----
	