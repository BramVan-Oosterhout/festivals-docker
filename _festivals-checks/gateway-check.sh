#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://gateway.festivals-gateway/info

./getURL-check.sh $JWT https://discovery.festivals-gateway/services

echo '==========================================================================='
