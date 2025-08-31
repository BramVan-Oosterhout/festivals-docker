#!/bin/sh
echo '==========================================================================='
echo "   >>> $2"
curl -s \
     -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $1" \
     --cert ./api-client.crt \
     --key ./api-client.key \
     --cacert ./ca.crt \
     $2 | jq