#!/bin/sh

JWT=$(./getJWT-check.sh)

./getURL-check.sh $JWT https://festivals-server:10439/info

./getURL-check.sh $JWT https://festivals-server:10439/festivals

./getURL-check.sh $JWT https://festivals-server:10439/festivals/1/events

./getURL-check.sh $JWT https://festivals-server:10439/events/1/artist

echo '==========================================================================='
