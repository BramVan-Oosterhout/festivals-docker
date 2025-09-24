#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://festivals-identity-server:22580/info

./getURL-check.sh $JWT https://festivals-identity-server:22580/users

echo '==========================================================================='

echo POST https://festivals-identity-server:22580/users/signup
curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Api-Key: TEST_API_KEY_001" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     -d '{ "email": "me@home.local", "password": "insecure" }' \
     https://festivals-identity-server:22580/users/signup

echo

./getURL-check.sh $JWT https://festivals-identity-server:22580/users

echo '==========================================================================='
