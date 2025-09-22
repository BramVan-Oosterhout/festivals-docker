#!/bin/sh

### MAKE SURE THE FOLLOWINH HOSTS ARE DEFINED
# gateway.festivals-gateway
# discovery.festivals-gateway
# api.festivals-gateway
# files.festivals-gateway
# api.festivalsapp.dev
# use : sudo sed -i '$r etc.hosts.external' /etc/hosts

JWT=$(docker exec -it festivals-checks /home/build/getJWT-check.sh)

./getURL-external-check.sh $JWT https://gateway.festivals-gateway/info

./getURL-external-check.sh $JWT https://discovery.festivals-gateway/info

./getURL-external-check.sh $JWT https://api.festivals-gateway/info

./getURL-external-check.sh $JWT https://files.festivals-gateway/info

./getURL-external-check.sh $JWT https://database.festivals-gateway/info

./getURL-external-check.sh $JWT https://discovery.festivals-gateway/services

./getURL-external-check.sh $JWT https://api.festivals-gateway/festivals

./getURL-external-check.sh $JWT https://files.festivals-gateway/files

./getURL-external-check.sh $JWT mysql://database.festivals-gateway

# the festivalsapp.dev  returns no answer. This is because the .dev domain 
# is a registered Top Level Domain (TLD). A .dev domain used on a server 
# connected to the internet will be handles by the Domain Name Server and
# the host cannot be found, UNLESS officially registered.
./getURL-external-check.sh $JWT https://api.festivalsapp.dev/info

echo '==========================================================================='
