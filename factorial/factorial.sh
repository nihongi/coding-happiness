#!/bin/sh
fact() {
  if [ ${1} = 1 ]; then
    echo -n 1
  else
    echo -n $(( ${1} * $(fact $((${1} - 1))) ))
  fi
}

fact ${1}
echo
