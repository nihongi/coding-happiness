#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    x=$(tarai $(( ${1} - 1 )) ${2} ${3})
    y=$(tarai $(( ${2} - 1 )) ${3} ${1})
    z=$(tarai $(( ${3} - 1 )) ${1} ${2}) 
    echo -n $(tarai ${x} ${y} ${z}) 
  else
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo
