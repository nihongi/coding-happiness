#!/bin/sh
for i in {1..100}
do
  unset s
  if [ $(( ${i} % 3 )) -eq 0 ]; then
    s="fizz"
  fi
  if [ $(( ${i} % 5 )) -eq 0 ]; then
    s=${s}"buzz"
  fi
  t=${s-${i}}
  echo ${t}
done
