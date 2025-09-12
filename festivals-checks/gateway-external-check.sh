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

./getURL-external-check.sh $JWT https://discovery.festivals-gateway/services

./getURL-external-check.sh $JWT https://api.festivals-gateway/festivals

./getURL-external-check.sh $JWT https://files.festivals-gateway/files

./getURL-external-check.sh $JWT https://api.festivalsapp.dev/info

echo '==========================================================================='
