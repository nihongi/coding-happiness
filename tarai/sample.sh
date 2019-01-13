#!/bin/sh
. ./memcached.sh

# 接続開始
mc_open

#if [ ! -z mc ]; then
#  echo "Already open." >&2
#fi
#echo ${mc[@]} >&2

# 値のsetは キー 有効期間 値 を指定
mc_set mykey1 10 myvalue1
mc_set mykey2 10 myvalue2

# 値のgetは キー を指定
v1=$(mc_get mykey1)
echo "Value of mykey1 is ${v1}."

key="mykey2"
v2=$(mc_get "${key}")
echo "Value of ${key} is ${v2}."

# 接続終了
mc_close

#echo ${mc[@]} >&2
