#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    echo -n $(tarai $(tarai $(( ${1} - 1 )) ${2} ${3}) \
                    $(tarai $(( ${2} - 1 )) ${3} ${1}) \
                    $(tarai $(( ${3} - 1 )) ${1} ${2}))
  else
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo
