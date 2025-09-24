festivals-checks is a server container to experiment with and verufy the operation of the festivals-<server> servers. The checks are implemented in shell scripts. For instance, the following commands display the version of each running serverL
```
# From the command line:
docker exec -it festivals-<server> /bin/bash -c "/home/build/all-check.sh"

# or enter the container  and execute the script:
make enter
./all-check.sh
```
If all servers are up and operational, ./all-check.sh will respond with:
```
   >>> https://festivals-identity-server:22580/version: v0.8.5
   >>> https://gateway.festivals-gateway/version: v2.2.1
   >>> https://festivals-fileserver:1910/version: v1.5.1
   >>> https://festivals-database:22397/version: v1.5.7
   >>> https://festivals-server:10439/version: v1.7.2
   >>> https://festivals-website:1910/version: v1.6.11

```

This implementation is based on the example provided in the Testing section of the operation/DEPLOYMENT.md document for each server in the Festivals-App repository. See (festivals-server operation)[https://github.com/Festivals-App/festivals-server/blob/main/operation/DEPLOYMENT.md] for an example.

See [DOCUMENTATION](https://github.com/BramVan-Oosterhout/festivals-docker/blob/main/festivals-checks/DOCUMENTATION.md) for a list of checks.
