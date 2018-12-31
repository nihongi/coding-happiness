#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

debug() {
  for j in `seq ${#stack[@]} -1 0`
  do
    echo ${stack[${j}]} >&2
  done
  echo >&2
}

while true
do
  i=$(( ${#stack[@]} - 1 ))
  job=(${stack[i]})
  unset stack[i]
  echo "job ${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}" >&2
#  debug
  if [ ${job[3]} = "r" ]; then
    if [ ${job[0]} -le ${job[1]} ]; then
      if [ ${i} -eq 0 ]; then
        echo ${job[1]}
        break
      fi
      replace ${job[4]} ${job[5]} ${job[1]}
    else
      stack[i]="${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}"
      stack[i+1]="x y z r ${i} r"
      stack[i+2]="$(( ${job[0]} - 1 )) ${job[1]} ${job[2]} r $(( ${i} + 1 )) x"
      stack[i+3]="$(( ${job[1]} - 1 )) ${job[2]} ${job[0]} r $(( ${i} + 1 )) y"
      stack[i+4]="$(( ${job[2]} - 1 )) ${job[0]} ${job[1]} r $(( ${i} + 1 )) z"
    fi
  else
    if [ ${job[4]} -eq -1 ]; then
      echo ${job[3]}
      break
    else
      replace ${job[4]} ${job[5]} ${job[3]}
    fi    
  fi
done

