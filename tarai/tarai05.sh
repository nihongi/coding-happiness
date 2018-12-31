#!/bin/sh
declare -A yz
st[0]="-1 a ${1} ${2} ${3}"

while true
do
  l=${#st[@]}
  ar=(${st[${l}-1]})
  unset st[${l}-1]
  echo "${ar[2]} ${ar[3]} ${ar[4]}"
  if [ ${ar[2]} -gt ${ar[3]} ]; then
    st[l-1]="$(( l - 2 )) a x y z"
    st[l]="$(( l - 1 )) x $(( ${ar[2]} - 1 )) ${ar[3]} ${ar[4]}"
    st[l+1]="$(( l - 1 )) y $(( ${ar[3]} - 1 )) ${ar[4]} ${ar[2]}"
    st[l+2]="$(( l - 1 )) z $(( ${ar[4]} - 1 )) ${ar[2]} ${ar[3]}"
  else
    if [ ${l} -eq 1 ]; then
      echo ${ar[3]}
      break
    elif [ ${ar[1]} = "a" ]; then
      par=(${st{${ar[0]}]})
      unset st[${l}-2]
      if []
    elif [ ${ar[1]} = "x" ]; then
      par=(${st[${ar[0]}]})
      st[${ar[0]}]="${par[0]} ${par[1]} ${ar[3]} ${par[3]} ${par[4]}"
    elif [ ${ar[1]} = "y" ]; then
      par=(${st[${ar[0]}]})
      st[${ar[0]}]="${par[0]} ${par[1]} ${par[2]} ${ar[3]} ${par[4]}"
    else
      par=(${st[${ar[0]}]})
      st[${ar[0]}]="${par[0]} ${par[1]} ${par[2]} ${par[3]} ${ar[3]}"
    fi
  fi
done

