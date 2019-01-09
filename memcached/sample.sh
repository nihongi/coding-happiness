#!/bin/sh
. ./memcached.sh

# 接続開始
mc_open

# 値のsetは キー 有効期間 値 を指定
mc_set mykey1 10 myvalue1

# 値のgetは キー を指定
v1=$(mc_get mykey1)
echo "Value of mykey1 is ${v1}."

# 値をsetしてないキーでgetすると、結果は空文字
v2=$(mc_get mykey2)
if [ "${v2}" = "" ]; then
  echo "Value of mykey2 is empty."
else
  echo ${v2}
fi

# 接続終了
mc_close

