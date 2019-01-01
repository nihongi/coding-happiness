#!/bin/sh

j=10
sub1=(-1 0 1 2 3 4 5 6 7 8 9)
for i in {0..50000}
do
  k=${sub1[${i}]}
done
