#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=(${stack[${1}]})
  case "${2}" in
    "x" )
       stack[${1}]="${3} ${tmp[1]} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}"
       ;;
    "y" )
       stack[${1}]="${tmp[0]} ${3} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}"
       ;;
    "z" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${3} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}"
       ;;
    "r" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${tmp[2]} ${3} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}"
       ;;
  esac
}

while true
do
  i=$(( ${#stack[@]} - 1 ))
  job=(${stack[i]})
  unset stack[i]
  echo "${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}" >&2
  if [ ${job[3]} = "r" ]; then
    if [ ${job[0]} -le ${job[1]} ]; then
      if [ ${i} -eq 0 ]; then
        echo ${job[1]}
        break
      fi
      replace ${job[4]} ${job[5]} ${job[1]}
    else
      stack[i]="${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]} ${job[6]} ${job[7]} ${job[8]}"
      if [ ${job[2]} = "z" ]; then
        stack[i+1]="${job[6]} ${job[7]} ${job[8]} r ${i} z"
      else
        stack[i+1]="x y z r ${i} r $(( ${job[2]} - 1 )) ${job[0]} ${job[1]}"
        stack[i+2]="$(( ${job[0]} - 1 )) ${job[1]} ${job[2]} r $(( ${i} + 1 )) x"
        stack[i+3]="$(( ${job[1]} - 1 )) ${job[2]} ${job[0]} r $(( ${i} + 1 )) y"
      fi
    fi
  else
    if [ ${i} -eq 0 ]; then
      echo ${job[3]}
      break
    else
      replace ${job[4]} ${job[5]} ${job[3]}
    fi    
  fi
done

