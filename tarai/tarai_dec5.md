# 竹内関数をメモ化と並列処理で...

「再帰する竹内関数も高速化」( https://qiita.com/nihongi/items/ad3b8fd5382bc9e9cf80 )の続きです。メモ化のためにmemcachedを使います。bashからmemcachedを使う方法は「シェルスクリプトからmemcachedを使う」( https://qiita.com/nihongi/items/b0db5d577825ac870ae7 )に書いた通りです。最新のソースは https://github.com/nihongi/coding-happiness/blob/develop/memcached/memcached.sh にあります。

正しい竹内関数の定義は次の通りです。(表記はいろいろありますが、ここではクヌースの論文に近い表記にしました)
```
tarai(x, y, z) = if x <= y then y
                 else tarai(tarai(x-1, y, z),
                            tarai(y-1, z, x),
                            tarai(z-1, x, y))
```

## メモの仕様

第一引数～第三引数をカンマでつないだ文字列をKeyとして、taraiの計算結果をValueとしたKey-Valueをmemcachedに登録します。具体的には`"4,2,0"`がKey、`"4"`がValueのようになります。

## 処理概要

関数の再帰呼び出しとcoproc(memcachedにアクセスするために使用)を一緒に使うとうまく動きませんでした。そこで、再帰呼び出しはshコマンドで全く別のスコープで動かすようにしました。

まずはじめに入力されたパラメータのメモがあるかチェックします。

```bash
if [ -z $(mc_get "${1},${2},${3}") ]; then
```
メモが既にあれば何もせずに処理を終了します。メモが空の場合には、taraiの計算に入ります。x<=yであれば結果はyなので、それをメモに追加して終了します。

上記以外の場合に、再帰の計算を行います。まず、内側の3つのtaraiをバックグラウンドのジョブで計算します。

```bash
    (sh taraip.sh $(( ${1} - 1 )) ${2} ${3})&
    (sh taraip.sh $(( ${2} - 1 )) ${3} ${1})&
    (sh taraip.sh $(( ${3} - 1 )) ${1} ${2})&
```
3つのジョブが終わるのをwaitコマンドで待ち、その後に結果をメモから読み出します。

```bash
    x=$(mc_get "$(( ${1} - 1 )),${2},${3}")
    y=$(mc_get "$(( ${2} - 1 )),${3},${1}")
    z=$(mc_get "$(( ${3} - 1 )),${1},${2}")
```
このx,y,zを外側のtaraiに食わせます。

```bash
    (sh taraip.sh ${x} ${y} ${z})&
```
先ほどと同様に、waitでジョブの終了を待ってから、結果を読み出し、これを新しい結果としてメモに書きます。

## ソースコード全体

```bash:taraip.sh
#!/bin/sh

. ./memcached.sh

echo "${1} ${2} ${3}" >&2
mc_open
if [ -z $(mc_get "${1},${2},${3}") ]; then
  if [ "${1}" -gt "${2}" ]; then
    (sh taraip.sh $(( ${1} - 1 )) ${2} ${3})&
    children=$!
    (sh taraip.sh $(( ${2} - 1 )) ${3} ${1})&
    children="${children} $!"
    (sh taraip.sh $(( ${3} - 1 )) ${1} ${2})&
    children="${children} $!"
    wait ${children}
    x=$(mc_get "$(( ${1} - 1 )),${2},${3}")
    y=$(mc_get "$(( ${2} - 1 )),${3},${1}")
    z=$(mc_get "$(( ${3} - 1 )),${1},${2}")
    (sh taraip.sh ${x} ${y} ${z})&
    wait $!
    r=$(mc_get "${x},${y},${z}")
    mc_set "${1},${2},${3}" 300 ${r}
  else
    mc_set "${1},${2},${3}" 300 ${2}
  fi
fi
mc_close
```
## 実行結果

実行します。

```console
$ time sh taraip.sh 8 4 0 2>/dev/null
```
他の端末からプロセスを見てみると

```console
$ ps u -C sh
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
nihongi  27786  0.0  0.0 113180  1520 pts/0    S+   19:34   0:00 sh taraip.sh 8 4 0
nihongi  27787  0.0  0.0 113180   608 pts/0    S+   19:34   0:00 sh taraip.sh 8 4 0
nihongi  27790  0.0  0.0 113180  1516 pts/0    S+   19:34   0:00 sh taraip.sh 7 4 0
nihongi  27791  0.0  0.0 113180  1516 pts/0    S+   19:34   0:00 sh taraip.sh 3 0 8
nihongi  27793  0.0  0.0 113180   604 pts/0    S+   19:34   0:00 sh taraip.sh 7 4 0
nihongi  27794  0.0  0.0 113180   604 pts/0    S+   19:34   0:00 sh taraip.sh 3 0 8
nihongi  27802  0.0  0.0 113180  1516 pts/0    S+   19:34   0:00 sh taraip.sh 6 4 0
nihongi  27803  0.0  0.0 113180  1520 pts/0    S+   19:34   0:00 sh taraip.sh 2 0 8
nihongi  27804  0.0  0.0 113180  1520 pts/0    S+   19:34   0:00 sh taraip.sh 3 0 7
nihongi  27807  0.0  0.0 113180  1520 pts/0    S+   19:34   0:00 sh taraip.sh 7 3 0
nihongi  27808  0.0  0.0 113180   604 pts/0    S+   19:34   0:00 sh taraip.sh 6 4 0
nihongi  27809  0.0  0.0 113180   608 pts/0    S+   19:34   0:00 sh taraip.sh 3 0 7
nihongi  27810  0.0  0.0 113180   608 pts/0    S+   19:34   0:00 sh taraip.sh 7 3 0
nihongi  27811  0.0  0.0 113180   608 pts/0    S+   19:34   0:00 sh taraip.sh 2 0 8
(以下省略)
```
たくさん立ち上がっています。各プロセスがtelnetでmemcachedに接続してるので、ちゃんと動くか心配になります。tarai(8,4,0)では意外と早く終わりました。結果はmemcachedにtelnetして見ます。

```console
real    0m3.089s
user    0m4.829s
sys     0m3.231s
$ telnet localhost 11211
Trying ::1...
Connected to localhost.
Escape character is '^]'.
get 8,4,0
VALUE 8,4,0 0 1
8
END
```
ちゃんと結果が入っていました。続けてもう一回実行してみると、

```console
$ time sh taraip.sh 8 4 0 2>/dev/null

real    0m0.006s
user    0m0.002s
sys     0m0.002s
```
爆速です。(これぞキャッシュヒット！！！)

## 8 4 0くらいが限界みたい

tarai(12, 6, 0)をやってみたらこのざまです。

```
taraip.sh: fork: retry: Resource temporarily unavailable
taraip.sh: fork: retry: Resource temporarily unavailable
./memcached.sh: fork: retry: No child processes
taraip.sh: fork: retry: Resource temporarily unavailable
./memcached.sh: fork: retry: No child processes
./memcached.sh: fork: retry: No child processes
```

プロセスをforkできなくなって、ぐだぐだになりました。止めるには`pkill -f "sh taraip.sh"
`を実行します。1台だとtarai(8, 4, 0)くらいが限界のようです。台数増やして、shコマンドをsshで飛ばせばもっと行けると思いますが、それは今後の課題に取っておきます。

