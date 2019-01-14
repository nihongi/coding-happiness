# シェルスクリプトからmemcachedを使う

シェルスクリプトの中でtelnetを使いmemcachedにアクセスします。telnetを操作する方法はexpectとcoprocの2通りで実施します。

## expect

telnetとのやり取りをexpectのスクリプトで記述します。値を入れたり出したりするたびにtelnetのセッションを作成するので、あまり使い勝手が良くありません。

```bash:expect_memcached.sh
#!/bin/sh

expect -c "
set timeout 20
spawn telnet localhost 11211
expect \"'^]'.\"
send \"set mykey 0 60 7\rmyvalue\r\"
expect \"STORED\"
send \"quit\r\"
"

result=($(expect -c "
set timeout 20
spawn telnet localhost 11211
expect \"'^]'.\"
send \"get mykey\r\"
expect \"END\"
send \"quit\r\"
"))

for i in `seq 0 ${#result[@]}`
do
  echo ${result[${i}]}
done
```
## coproc

coprocでtelnetを起動して、telnetの標準入力と標準出力をシェルスクリプトから使えるようにします。これは、一連の処理を一つのtelnetのセッションで実行できるので、expectより効率的です。シェルスクリプトにincludeして使うことを想定して、ライブラリのようにしました。ソースコードは memcached.sh を見てください。

## 使い方

```bash:sample.sh
#!/bin/sh
. ./memcached.sh

# 接続開始
mc_open

# 値のsetは キー 有効期間 値 を指定
mc_set mykey1 10 myvalue1

# 値のgetは キー を指定
key="mykey1"
v1=$(mc_get ${key})
echo "Value of ${key} is ${v1}."

# 値をsetしてないキーでgetすると、結果は空文字
key="mykey2"
v2=$(mc_get ${key})
if [ "${v2}" = "" ]; then
  echo "Value of mykey2 is empty."
else
  echo ${v2}
fi

# 接続終了
mc_close
```
