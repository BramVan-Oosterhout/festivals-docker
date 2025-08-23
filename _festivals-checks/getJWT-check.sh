#!/bin/sh

JWT=$(curl -s \
         -H "Api-Key: TEST_API_KEY_001" \
         -u "admin@email.com:we4711" \
         --cert /usr/local/festivals-checks/api-client.crt \
         --key /usr/local/festivals-checks/api-client.key \
         --cacert /usr/local/festivals-checks/ca.crt \
         https://festivals-identity-server:22580/users/login)

echo $JWT
