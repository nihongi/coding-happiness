#!/bin/sh
for i in `seq 3 3 100`
do
  a[${i}]="Fizz"
done

for i in `seq 5 5 100`
do
  a[${i}]="Buzz"
done

for i in `seq 15 15 100`
do
  a[${i}]="FizzBuzz"
done

for i in {1..100}
do
  echo ${a[${i}]-${i}}
done
