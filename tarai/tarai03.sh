#!/bin/sh
declare -A cache

tarai() {
#  echo "${1} ${2} ${3}" >&2
  if [ ! -z ${cache["${1},${2},${3}"]} ]; then
    echo -n ${cache["${1},${2},${3}"]}
    return 0
  fi  
  if [ ${1} -gt ${2} ]; then
    echo -n $(tarai $(tarai $(( ${1} - 1 )) ${2} ${3}) \
                    $(tarai $(( ${2} - 1 )) ${3} ${1}) \
                    $(tarai $(( ${3} - 1 )) ${1} ${2}))
  else
    cache["${1},${2},${3}"]=${2}
    echo "${1} ${2} ${3}" >&2
    echo ${cache["${1},${2},${3}"]} >&2
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo

echo ${cache["0,2,1"]}
