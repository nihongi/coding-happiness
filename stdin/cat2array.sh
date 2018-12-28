#!/bin/sh
s=$(cat)
echo "Recieved: ${s}"
echo "Length: ${#s}"

array=(${s})
for i in `seq 0 $(( ${#array[@]} - 1))`
do
  echo "array[${i}] = ${array[${i}]}"
done
