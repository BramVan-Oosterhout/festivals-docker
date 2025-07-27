#!/bin/sh

JWT=$(curl -v -v -H "Api-Key: TEST_API_KEY_001" \
         -u "admin@email.com:we4711" \
         --cert /usr/local/festivals-checks/api-client.crt \
         --key /usr/local/festivals-checks/api-client.key \
         --cacert /usr/local/festivals-checks/ca.crt \
         https://festivals-identity-server:22580/users/login)

echo '==========================================================================='

curl -v -v -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://gateway.festivals-gateway/info

echo
echo '==========================================================================='
#curl -H "Api-Key: TEST_API_KEY_001" \
#     -H "Authorization: Bearer $JWT" \
#     --cert /opt/homebrew/etc/pki/issued/api-client.crt \
#     --key /opt/homebrew/etc/pki/private/api-client.key \
#     --cacert /opt/homebrew/etc/pki/ca.crt \
#     https://gateway.festivalsapp.home/info