#!/bin/sh

JWT=$(./getJWT-check.sh)

echo '==========================================================================='
echo '   >>> https://festivalsapp.dev'

curl --cacert /usr/local/festivals-checks/ca.crt \
     https://festivalsapp.dev

./getURL-check.sh $JWT https://festivals-website:1910/info

echo '==========================================================================='
