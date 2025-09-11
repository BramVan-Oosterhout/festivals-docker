#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://gateway.festivals-gateway/info

./getURL-check.sh $JWT https://discovery.festivals-gateway/services

./getURL-check.sh $JWT https://api.festivals-gateway/festivals

./getURL-check.sh $JWT https://files.festivals-gateway/files

echo '==========================================================================='
