#!/bin/sh
echo -n "   >>> $2: "
curl -s \
     -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $1" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     $2
echo
