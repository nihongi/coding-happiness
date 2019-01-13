#!/bin/sh

func() {
  if [ ${1} -eq 0 ]; then
    (func $(( ${1} + 1 )))&
    child=$!
    echo "debug1 ${child}" >&2
    wait ${child}
    cat /tmp/test.${child}
    # rm /tmp/test.${child}
  else
    echo "hoge" >> /tmp/test.${BASHPID}
  fi
}

func 0
