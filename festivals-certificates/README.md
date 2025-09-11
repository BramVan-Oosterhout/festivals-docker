Creating the correct certificates for the servers so they can identify themselves can be challenging if you are not familiar with the Public Keu Infrastructure (PKI) and Transport Layer Security (TLS), commonly referred to by its legacy name Secure Cocket layer (SSL)

[`easyrsa`](https://easy-rsa.readthedocs.io/en/latest/) is a convenient way to generate certificates. But components of Festivals-App require certificates of different formats and the gateway-server addresses the backend by endpoint, rather than server names with different names. As a consequence, the certificates must include Subject Alternative Names (SANs) 

The Makefile in this directory takes care of all that. The Makefile defines a list of DOMAINS for which certificates will be generated. The domains are matching the Festivals-App server names (festivals-<server>). Make will check in the festivals-<server> directory for a file called `hostlist`. If `hostlist` exists, make assumes that the file contains the needed SANs for the server and will include them in the certificates.

The required certificates are copied to their required location as part of the configuration of each server.

See the DOCUMENTATION for detailed operation.