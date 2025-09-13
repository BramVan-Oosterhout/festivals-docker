

certs:
	cp ../festivals-certificates/pki/ca.crt .
	cp ../festivals-certificates/pki/issued/api-client.crt .
	cp ../festivals-certificates/pki/private/api-client.key .

upload: certs	
	./festivals-upload.pl
