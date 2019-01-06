# 再帰しない竹内関数の高速化

再帰しない竹内関数( https://qiita.com/nihongi/items/785319a005c44add7ba1 )の続きです。

## サブシェルを使わない

replaceの中でサブシェルと使っていたところを修正します。これ↓が修正前。

```bash:修正前
replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

```

文字の置き換えなので普通にsedを使いたくなるところですが、これだとどうしてもサブシェルになってしまい、遅くなる原因になりそうです。ここをsedを使わない処理に修正しました。

```bash:修正後
replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=(${stack[${1}]})
  case "${2}" in
    "x" )
       stack[${1}]="${3} ${tmp[1]} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]}"
       ;;
    "y" )
       stack[${1}]="${tmp[0]} ${3} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]}"
       ;;
    "z" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${3} ${tmp[3]} ${tmp[4]} ${tmp[5]}"
       ;;
    "r" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${tmp[2]} ${3} ${tmp[4]} ${tmp[5]}"
       ;;
  esac
}

```
比較してみると、

```console
$ time sh tarai03.sh 8 4 0 2>/dev/null
8

real    0m22.863s
user    0m14.046s
sys     0m8.768s
$ time sh tarai04.sh 8 4 0 2>/dev/null
8

real    0m3.776s
user    0m3.495s
sys     0m0.279s
```
あら、22秒が一気に3秒台まで縮まりました。サブシェル恐るべし。

## 遅延評価

竹内関数の`if x>y then {...} else y`だけを見るとzを使わずに計算できることがわかります。そこで、先にxとyを計算してzが必要かどうか見極めて、必要な場合にだけ計算するというように処理を改善します。そのためにjobの定義を拡張します。

```
job[0]: 第一パラメータの数値、未定の場合は"x"
job[1]: 第二パラメータの数値、未定の場合は"y"
job[2]: 第三パラメータの数値、未定の場合は"z"
job[3]: taraiの計算結果の数値、未定の場合は"r"
job[4]: 計算結果rの代入先のjob(スタックの何番目か)
job[5]: 計算結果rの代入先("x", "y", "z", "r")
job[6]: (optional:job[2]が未定の場合のみ) zを計算するtaraiの第一パラメータ
job[7]: (optional:job[2]が未定の場合のみ) zを計算するtaraiの第二パラメータ
job[8]: (optional:job[2]が未定の場合のみ) zを計算するtaraiの第三パラメータ
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
            * zは計算済みか→yes
                * rを計算するための新たなjob(3つ)をスタックに追加する
            * zは計算済みか→no
                * zを計算するための新たなjob(1つ)をスタックに追加する

計ってみます。

```console
$ time sh tarai05.sh 8 4 0 2>/dev/null
8

real    0m0.022s
user    0m0.016s
sys     0m0.005s
$ time sh tarai05.sh 20 10 0 2>/dev/null
20

real    0m0.116s
user    0m0.107s
sys     0m0.009s
$ time sh tarai05.sh 100 50 0 2>/dev/null
100

real    0m2.801s
user    0m2.565s
sys     0m0.235s
```
Tarai(8,4,0)で3.7秒から0.02秒と、めちゃめちゃ速くなりました。Tarai(100,50,0)でも現実的な時間で計算できるようになりました。

ログの行数を見ることでループの回数がわかります。

```console
$ sh tarai04.sh 8 4 0 2>tarai.log
8
$ wc -l tarai.log
15756 tarai.log
$ sh tarai05.sh 8 4 0 2>tarai.log
8
$ wc -l tarai.log
65 tarai.log
$ sh tarai05.sh 100 50 0 2>tarai.log
100
$ wc -l tarai.log
10001 tarai.log
```
tarai(8, 4, 0)の場合、改善前には15756回だったループが改善後には65回に激減しています。ずいぶんと無駄な計算をしていたことがわかります。tarai(10, 5, 0)では、ループが10001回まわりました。

## メモ化は不要

計算結果を連想配列等に入れて計算済みのものはそれを参照するようにしたらさらに速くなるでしょうか?

実は答えはNoです。
まず x<=y の場合は tarai(x, y, z) = y なのでメモが無くてもすぐに計算できます。メモ化が有効なのは、x>y でかつ結果rが未定なジョブについてのみです。これが何回あったか調べます。

```console
$ awk '{if($4=="r" && $1>$2) print $1" "$2" "$3}' tarai.log | wc -l
2500
```

ちょうど2500回です。この中でユニークなものがいくつあるか数えてみると

```console
$ awk '{if($4=="r" && $1>$2) print $1" "$2" "$3}' tarai.log | sort -u | wc -l
2500
```

なんとすべてユニークでした。つまり、計算結果をメモに入れたところで、それを使うケースはないということがわかりました。

## ソース
最後にここまでのソース全体を載せておきます。

```bash:tarai05.sh
#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}番目のスタックの文字${2}を数字${3}に置き換える
  tmp=(${stack[${1}]})
  case "${2}" in
    "x" )
       stack[${1}]="${3} ${tmp[1]} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp
[8]}"
       ;;
    "y" )
       stack[${1}]="${tmp[0]} ${3} ${tmp[2]} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp
[8]}"
       ;;
    "z" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${3} ${tmp[3]} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp
[8]}"
       ;;
    "r" )
       stack[${1}]="${tmp[0]} ${tmp[1]} ${tmp[2]} ${3} ${tmp[4]} ${tmp[5]} ${tmp[6]} ${tmp[7]} ${tmp
[8]}"
       ;;
  esac
}

while true
do
  i=$(( ${#stack[@]} - 1 ))
  job=(${stack[i]})
  unset stack[i]
  echo "${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]} ${tmp[6]} ${tmp[7]} ${tmp[8]}" >&2
  if [ ${job[3]} = "r" ]; then
    if [ ${job[0]} -le ${job[1]} ]; then
      if [ ${i} -eq 0 ]; then
        echo ${job[1]}
        break
      fi
      replace ${job[4]} ${job[5]} ${job[1]}
    else
      stack[i]="${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]} ${job[6]} ${job[7]} ${job[8]}"
      if [ ${job[2]} = "z" ]; then
        stack[i+1]="${job[6]} ${job[7]} ${job[8]} r ${i} z"
      else
        stack[i+1]="x y z r ${i} r $(( ${job[2]} - 1 )) ${job[0]} ${job[1]}"
        stack[i+2]="$(( ${job[0]} - 1 )) ${job[1]} ${job[2]} r $(( ${i} + 1 )) x"
        stack[i+3]="$(( ${job[1]} - 1 )) ${job[2]} ${job[0]} r $(( ${i} + 1 )) y"
      fi
    fi
  else
    if [ ${i} -eq 0 ]; then
      echo ${job[3]}
      break
    else
      replace ${job[4]} ${job[5]} ${job[3]}
    fi
  fi
done
```
