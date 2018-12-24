#!/bin/sh
fact() {
  if [ $1 = 1 ]; then
    return 1
  else
    fact $(($1 - 1))
    return $(($1 * $?))
  fi
}

fact $1
echo $?
