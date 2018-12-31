#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    tarai $(( ${1} - 1 )) ${2} ${3}
    x=${ret}
    tarai $(( ${2} - 1 )) ${3} ${1}
    y=${ret}
    tarai $(( ${3} - 1 )) ${1} ${2}
    z=${ret}
    tarai ${x} ${y} ${z}
    ret=${y}
  else
    ret=${2}
  fi
}

tarai ${1} ${2} ${3}
echo ${ret}

