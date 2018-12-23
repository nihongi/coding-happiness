#!/bin/sh
while read r
do
  echo "Recieved: "$r
  echo "Length: "${#r}
  for i in `seq 0 $(( ${#r} - 1 ))`
  do
    printf "%d\n" \'${r:$i:1}
  done
done
