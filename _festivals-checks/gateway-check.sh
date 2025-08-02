#!/bin/sh

JWT=$(curl -H "Api-Key: TEST_API_KEY_001" \
         -u "admin@email.com:we4711" \
         --cert /usr/local/festivals-checks/api-client.crt \
         --key /usr/local/festivals-checks/api-client.key \
         --cacert /usr/local/festivals-checks/ca.crt \
         https://festivals-identity-server:22580/users/login)

echo '=============================== INFO ============================================'

echo "   >>> https://gateway.festivals-gateway/info"
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://gateway.festivals-gateway/info | jq

echo
echo '============================== SERVICES ============================================='

echo "   >>> https://discovery.festivals-gateway/services"
curl -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     https://discovery.festivals-gateway/services | jq