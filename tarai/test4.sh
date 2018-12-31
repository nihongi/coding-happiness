#!/bin/sh

replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

stack[0]="x y z r 0 x"
stack[1]="x y z r 0 y"
stack[2]="x y z r 0 z"
stack[3]="x y z r 0 r"
stack[4]="1 0 2 r 11 r"

replace 0 x 1
replace 1 y 2
replace 2 z 3
replace 3 r 4
replace 4 r 2

for i in {0..4}
do
  echo ${stack[${i}]}
done
