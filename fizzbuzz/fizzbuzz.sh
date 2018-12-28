#!/bin/sh
for i in {1..100}
do
  unset s
  if [ $(expr ${i} % 3) -eq 0 ]; then
    s="fizz"
  fi
  if [ $(expr ${i} % 5) -eq 0 ]; then
    s=${s}"buzz"
  fi
  t=${s-${i}}
  echo ${t}
done
