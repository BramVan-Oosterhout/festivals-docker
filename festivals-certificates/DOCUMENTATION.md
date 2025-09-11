# Operation
The Makefile defines the DOMAINS for which certificates are required. Update the list to meet your needs. Subject Alternative Names (SANs) can be defined in the appropriate `hostlist` file.

Certificate generation requires a password. This is set to 'insecure' in the Makefile. You can change it there if you so desire.

The Makefile supports the following targets.

| Targwt | Action |
| === | === |
| init | removes all previous;y created keys and easyrsa infrastructure, recreates the password, re-installs easyrsa and initialises the infrastructure. You should do this only once, since this process creates the Certification Authority (CA) and ots associated, unique certificates. Repeating this step will invalidate all previous;y generated certificates. They will need to be re-issued. |
| all | generates certificates for all servers listed in DOMAINS. SANs are included from the ../<domain>/hostlist file.  |

You may need to regenerate a set of certificates (for instance when you need to add a SAN to the sertificate). To regenerate the certificates for a particular domain you can use the following command:

```
sudo rm `find . -name "<domain name>*"`  # Note the back ticks.
make all
```
