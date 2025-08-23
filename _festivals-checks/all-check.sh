#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-n-check.sh $JWT https://festivals-identity-server:22580/version

./getURL-n-check.sh $JWT https://gateway.festivals-gateway/version

./getURL-n-check.sh $JWT https://festivals-fileserver:1910/version

./getURL-n-check.sh $JWT https://festivals-database:22397/version

./getURL-n-check.sh $JWT https://festivals-server:10439/version

./getURL-n-check.sh $JWT https://festivals-website:1910/version

echo '==========================================================================='
