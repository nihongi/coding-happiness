# 竹内関数

bashで竹内関数を計算してみます。(無謀)

## まず通常版
```bash:tarai01.sh
#!/bin/sh
tarai() {
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
```
再帰呼び出しのたびにサブシェルを起動しています。悪い予感がプンプンします。
```console
$ sh tarai01.sh 10 5 0
```
返ってきません。別の端末からプロセスを見てみると
```console
$ ps u -C sh
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
nihongi   5805  0.0  0.0 113176  1440 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5806  0.0  0.0 113176   384 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5807  0.0  0.0 113176   640 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5808  0.0  0.0 113176   612 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5809  0.0  0.0 113176   644 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5810  0.0  0.0 113176   624 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   9947  0.0  0.0 113176   660 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   9948  0.0  0.0 113176   636 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  19318  0.0  0.0 113176   668 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  19319  0.0  0.0 113176   652 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20209  0.0  0.0 113176   680 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20210  0.0  0.0 113176   664 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20211  0.0  0.0 113176   692 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20212  0.0  0.0 113176   676 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20213  0.0  0.0 113176   704 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
以下省略
```
たくさんプロセスが上がっているので、動いているのは間違いないようです。

## 何が起きているのか
関数が呼び出されたときに、入力パラメータをエラー出力に表示する処理を追加して、何が起きているか見てみます。
```bash:tarai02.sh
  echo "${1} ${2} ${3}" >&2
```

```console
$ sh tarai02.sh 10 5 0
10 5 0
9 5 0
8 5 0
7 5 0
6 5 0
5 5 0
4 0 6
3 0 6
2 0 6
1 0 6
0 0 6
-1 6 1
5 1 0
4 1 0
以下省略
```
(10, 5, 0)では無理なので(5, 2, 0)くらいに日和ります。
```console
$ sh tarai02.sh 5 2 0 2> tarai.log
5
$ wc -l tarai.log
149 tarai.log
$ sort -u tarai.log | wc -l
37
```
149回の呼び出しがあり、ユニークなものは37回であることがわかりました。結果をキャッシュすれば改善が期待できます。

## キャッシュできるか？
連想配列でキャッシュ作ろうとしましたが無理でした。前に見たように再帰呼び出しが別プロセスに展開されてしまうので、同じ連想配列をそれぞれのプロセスから参照することができません。(つづく)