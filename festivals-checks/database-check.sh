#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://festivals-database:22397/info

echo '==========================================================================='
