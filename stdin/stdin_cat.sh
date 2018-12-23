#!/bin/sh
s=$(cat)
echo "Recieved: "$s
echo "Length: "${#s}
for i in `seq 0 $(( ${#s} - 1 ))`
do
  printf "%d\n" \'${s:$i:1}
done
