#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://festivals-fileserver:1910/info

./getURL-check.sh $JWT https://festivals-fileserver:1910/files

echo '==========================================================================='

echo POST https://festivals-fileserver:1910/images/upload
curl -X POST \
     -H "Content-Type: multipart/form-data" \
     -H "Api-Key: TEST_API_KEY_001" \
     -H "Authorization: Bearer $JWT" \
     --cert /usr/local/festivals-checks/api-client.crt \
     --key /usr/local/festivals-checks/api-client.key \
     --cacert /usr/local/festivals-checks/ca.crt \
     -F image=@fileserver-check.sh \
     https://festivals-fileserver:1910/images/upload | jq

echo '==========================================================================='

./getURL-check.sh $JWT https://festivals-fileserver:1910/files
