#!/bin/sh
for i in {1..100}
do
  if [ $(( ${i} % 3 )) -eq 0 ]; then
    s="Fizz"
  else
    unset s
  fi
  if [ $(( ${i} % 5 )) -eq 0 ]; then
    s=${s}"Buzz"
  fi
  echo ${s-${i}}
done
