# 再帰しない竹内関数

bashで竹内関数( https://qiita.com/nihongi/items/21a4a215920150ef7eb8 )の続きです。

## ジョブの定義
スタックにジョブを積んでいって上から処理していく方式に変更します。まず、ジョブの形式を定義します。

```
job[0]: 第一パラメータの数値、未定の場合は"x"
job[1]: 第二パラメータの数値、未定の場合は"y"
job[2]: 第三パラメータの数値、未定の場合は"z"
job[3]: taraiの計算結果の数値、未定の場合は"r"
job[4]: 計算結果rの代入先のjob(スタックの何番目か)
job[5]: 計算結果rの代入先("x", "y", "z", "r")
```
処理の手順は次の通りです。

* スタックからjobを取り出す
  * rが計算済みの場合
      * これが最初のjobであれば終了
      * そうでなければ、計算結果の代入先に代入する
  * rが計算済みでない場合
      * rがすぐに計算可能か(すなわちx<=yか)→yes
          * これが最後のジョブの場合はここで終了
          * そうでなければ、計算結果の代入先にyを代入する
      * rがすぐに計算可能か(すなわちx<=yか)→no
          * jobをスタックに戻す
          * rを計算するための新たなjob(tarai4つ分)をスタックに追加する

要するに、スタックの一番上を処理して、結果が出た場合は、スタックの途中にでも結果を入れていくというスタイルです。

ソースです。

```bash:tarai03.sh
#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

while true
do
  i=$(( ${#stack[@]} - 1 ))
  job=(${stack[i]})
  unset stack[i]
  echo "${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}" >&2
  if [ ${job[3]} = "r" ]; then
    if [ ${job[0]} -le ${job[1]} ]; then
      if [ ${i} -eq 0 ]; then
        echo ${job[1]}
        break
      fi
      replace ${job[4]} ${job[5]} ${job[1]}
    else
      stack[i]="${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}"
      stack[i+1]="x y z r ${i} r"
      stack[i+2]="$(( ${job[0]} - 1 )) ${job[1]} ${job[2]} r $(( ${i} + 1 )) x"
      stack[i+3]="$(( ${job[1]} - 1 )) ${job[2]} ${job[0]} r $(( ${i} + 1 )) y"
      stack[i+4]="$(( ${job[2]} - 1 )) ${job[0]} ${job[1]} r $(( ${i} + 1 )) z"
    fi
  else
    if [ ${job[4]} -eq -1 ]; then
      echo ${job[3]}
      break
    else
      replace ${job[4]} ${job[5]} ${job[3]}
    fi
  fi
done
```
これで処理が速くなったか試してみます。
まず、通常の再帰版

```console
$ time sh tarai02.sh 8 4 0 2>/dev/null
8

real    0m7.462s
user    0m4.598s
sys     0m2.849s
```
通常版は7.5秒くらいでした。次に今回のスタック版

```console
$ time sh tarai03.sh 8 4 0 2>/dev/null
8

real    0m22.137s
user    0m14.284s
sys     0m7.808s
```
22秒？ あれ？

次回、竹内関数のキャッシュと遅延評価をお楽しみに。
