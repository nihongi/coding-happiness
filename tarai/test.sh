#!/bin/sh

declare -A cache
cache["1,2,3"]=0
cache["1,2,4"]=1

echo ${cache["1,2,4"]}
echo ${!cache[@]}
echo ${cache["3,2,1"]}

if [ ! -z ${cache["3,2,3"]} ]; then
  echo "Y"
else
  echo "N"
fi
