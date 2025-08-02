#!/bin/sh

JWT=$(curl -s -H "Api-Key: TEST_API_KEY_001" \
         -u "admin@email.com:we4711" \
         --cert /usr/local/festivals-checks/api-client.crt \
         --key /usr/local/festivals-checks/api-client.key \
         --cacert /usr/local/festivals-checks/ca.crt \
         https://festivals-identity-server:22580/users/login)

echo -n "   >>> https://festivals-identity-server:22580/version: "
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://festivals-identity-server:22580/version
echo 

echo -n "   >>> https://gateway.festivals-gateway/version: "
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://gateway.festivals-gateway/version
echo

echo -n "   >>> https://festivals-fileserver:1910/version: "
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://festivals-fileserver:1910/version
echo 

echo -n "   >>> https://festivals-database:22397/version: "
curl -s -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://festivals-database:22397/version 
echo

echo -n "   >>> https://festivals-server:1910/version: "
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://festivals-server:10439/version
echo 
