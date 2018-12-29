#!/bin/sh
declare -A cache
cache["${1},${2},${3}"]=5

if [ ! -z ${cache["${1},${2},${3}"]} ]; then
    echo ${cache["${1},${2},${3}"]}
fi
