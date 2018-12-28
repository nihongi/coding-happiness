#!/bin/sh
for i in {1..100}
do
  if [ $(( ${i} % 3 )) -eq 0 ]; then
    s="fizz"
  else
    unset s
  fi
  if [ $(( ${i} % 5 )) -eq 0 ]; then
    s=${s}"buzz"
  fi
  echo ${s-${i}}
done
