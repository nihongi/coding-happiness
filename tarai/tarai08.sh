#!/bin/sh
. ./memcached.sh

tarai() {
  echo "${1} ${2} ${3} ${BASHPID}" >&2
  mc_open
  if [ "$(mc_get \"${1},${2},${3}\")" = "" ]; then
    if [ "${1}" -gt "${2}" ]; then
      (tarai $(( ${1} - 1 )) ${2} ${3})&
      children=$!
      (tarai $(( ${2} - 1 )) ${3} ${1})&
      children="${children} $!"
      (tarai $(( ${3} - 1 )) ${1} ${2})&
      children="${children} $!"
      wait ${children}
      x=$(mc_get $(( ${1} - 1 )) ${2} ${3})
      y=$(mc_get $(( ${2} - 1 )) ${3} ${1})
      z=$(mc_get $(( ${3} - 1 )) ${1} ${2})
      (tarai ${x} ${y} ${z})&
      wait $!
      r=$(mc_get ${x} ${y} ${z})
      mc_set "${1},${2},${3}" 300 ${r}
    else
      mc_set "${1},${2},${3}" 300 ${2}
    fi
  fi
  mc_close
}

tarai ${1} ${2} ${3}
echo $(mc_get ${1} ${2} ${3})

