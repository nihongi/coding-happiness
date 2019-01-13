# FizzBuzz問題

1から100までの数字を出力する。
ただし、3で割り切れる場合は「Fizz」を、5で割り切れる場合は「Buzz」を、両方で割り切れる場合は「FizzBuzz」を出力する。

という有名な問題です。できる限り、判断文・実行文を減らすように工夫してみました。

## 工夫その１
```console
  if [ $(( ${i} % 3 )) -eq 0 ]; then
    s="Fizz"
  else
    unset s
  fi
  if [ $(( ${i} % 5 )) -eq 0 ]; then
    s=${s}"Buzz"
  fi
```
2つのif文で下記の4つの分類を行います。15で割り切れるかどうかの判断を行わない方法で、Wikipediaなどにも書かれています。

<table border="1">
<tr>
<th>3で割り切れる</th>
<th>5で割り切れる</th>
<th>sの内容</th>
</tr>
<tr>
<tr>
<td rowspan="2">yes</td>
<td>yes</td>
<td>FizzBuzz</td>
</tr>
<tr>
<td>no</td>
<td>Fizz</td>
</tr>
<tr>
<td rowspan="2">no</td>
<td>yes</td>
<td>Buzz</td>
</tr>
<tr>
<td>no</td>
<td>未定義</td>
</tr>
</table>

## 工夫その２
```console
  echo ${s-${i}}
```
この`-`は、左側が定義済みであれば左側の値を使用、未定義であれば右側の値を使用する、というシェル変数独特の記法です。実質的にこの中に判断文が入っているわけですが、見た目はif文を減らすことができます。

## 使い方
```console
$ sh fizzbuzz.sh
```

## 工夫その3
工夫その２を応用して、if文を全く使わないFizzBuzzを作ることができます。正解はfizzbuzz2.shをご覧ください。

以上です。