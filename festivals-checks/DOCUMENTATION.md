the festivals=checks  container provides a number of sheel scripts to evperiment with and verify the operation of a particular server. 

The scripts use two scripts to support the operation:

getJWT-check.sh retrieves the JWT token for the test admin user admin@email.com and password.

getURL-check.sh uses the JWT to obtain access and retrieve the data from the referred server endpoint.

A typical sequence of operation is:
```
#!/bin/sh
JWT=$(./getJWT-check.sh)
./getURL-check.sh $JWT https://gateway.festivals-gateway/info

```
This sequence verifies three things:
1. The JWT can be obtained from the festivals-identity-server
2. The url gateway.festivals-gateway is routed correctly to the server
3. The server returns the expected information for the /info endpoint

All scripts use `curl -s` to access the servers silently. For debugging  `curl -v` has proven invaluable. `curl -v` displays the negotiations to verify the certificates, the HTTP request and the HTTP response. This is particularly useful when experinenting with certificates, bexause if the certificate verification fails, the server does not even log an incoming request.

## The <server>-check scripts
In addition to all-check.sh, there is one script for each server. These scripts must be executed inside the festivals=cheks container.

| script | endpoint(s) |
| === | === |
| database-check.sh | /info |
| fileserver-check.sh | /info, /files. /upload |
| gateway-check.sh | /info, /services, /festivals, /files |
| identity-check.sh | /info, /users |
| server-check.sh | /infp, 'festivals, /events, /events/1/artist |
| website-check.sh | /info |

## The gateway-external-check.sh script
The gateway-external-check.sh can be executed directly from the command line. To operate correctly:
*    port 443 on the hose must be mapped to port 443 on the festivals-gateway container;  and 
*   the hosts must be defined in `/etc/hosts`:
```
127.0.1.1       gateway.festivals-gateway
127.0.1.1       discovery.festivals-gateway
127.0.1.1       api.festivals-gateway
127.0.1.1       files.festivals-gateway
127.0.1.1       api.festivalsapp.dev
```
These hosts are defined in file `etc.hosts.external` and can be added to `/etc/hosts` with:
```
sudo sed -i '$r etc.hosts.external' /etc/hosts
```
`gateway-external-check.sh` will verify the following URLs:
*   gateway.festivals-gateway/info
*   discovery.festivals-gateway/services
*   api.festivals-gateway/festivals
*   files.festivals-gateway/files
*   api.festivalsapp.dev/info



