#!/bin/sh
declare -A cache
#cache["${1},${2},${3}"]=${2}

func() {
  echo "${1},${2},${3}"
  cache["${1},${2},${3}"]=${2}
  echo "関数内: ${cache["${1},${2},${3}"]}"
}

func ${1} ${2} ${3}
echo "関数外: ${cache["${1},${2},${3}"]}"
echo ${cache["1,2,3"]}
echo ${#cache[@]}
