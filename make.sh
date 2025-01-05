#!/bin/sh
if [ -d $1 ]
then
    make -C $1 $2 $3 $4 $5 $6 $7 $8 $9
else
    mkdir $1
fi