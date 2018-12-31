#!/bin/sh

j=3

if [ ${j} = "r" ]; then
  echo "yes"
else
  echo "no"
fi

j="-1"
if [ ${j} -eq -1 ]; then
  echo "yes"
else
  echo "no"
fi

