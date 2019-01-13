#!/bin/sh

MC_HOST="localhost"
MC_PORT="11211"

mc_open() {
  coproc mc { telnet ${MC_HOST} ${MC_PORT}; } 2>/dev/null
  read <&"${mc[0]}"
  read <&"${mc[0]}"
  read <&"${mc[0]}"
}

mc_set() {
  echo "set ${1} 0 ${2} ${#3}" >&"${mc[1]}"
  echo "${3}" >&"${mc[1]}"
  read r <&"${mc[0]}"
  if [ "${r}" = "STORED" ]; then
    return 0
  else
    echo ${r}
    return 1
  fi
}

mc_get() {
  echo "get ${1}" >&"${mc[1]}"
  read <&"${mc[0]}"
  read v <&"${mc[0]}"
  read r <&"${mc[0]}"
  if [ ${r} = "END" ]; then
    echo -n ${v}
    return 0
  else
    return 1
  fi
}

mc_close() {
  echo "quit" >&"${mc[1]}"
}

mc_open
mc_set key 10 value
mc_get key
mc_close

