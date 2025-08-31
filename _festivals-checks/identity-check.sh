#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://festivals-identity-server:22580/info

./getURL-check.sh $JWT https://festivals-identity-server:22580/users

echo '==========================================================================='
