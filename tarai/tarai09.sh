#!/bin/sh

. ./memcached.sh

echo "${1} ${2} ${3} ${BASHPID}" >&2
mc_open
r=$(mc_get "${1},${2},${3}")
if [ -z "${r}" ]; then
  if [ "${1}" -gt "${2}" ]; then
    (sh tarai09.sh $(( ${1} - 1 )) ${2} ${3})&
    children=$!
    (sh tarai09.sh $(( ${2} - 1 )) ${3} ${1})&
    children="${children} $!"
    (sh tarai09.sh $(( ${3} - 1 )) ${1} ${2})&
    children="${children} $!"
    wait ${children}
    x=$(mc_get "$(( ${1} - 1 )),${2},${3}")
    y=$(mc_get "$(( ${2} - 1 )),${3},${1}")
    z=$(mc_get "$(( ${3} - 1 )),${1},${2}")
    (sh tarai09.sh ${x} ${y} ${z})&
    wait $!
    r=$(mc_get "${x},${y},${z}")
    mc_set "${1},${2},${3}" 300 ${r}
  else
    mc_set "${1},${2},${3}" 300 ${2}
  fi
fi
mc_close


