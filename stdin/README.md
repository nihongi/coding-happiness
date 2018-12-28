# シェルスクリプトの標準入力
シェルスクリプトで標準入力を読み込む主な方法はreadとcatです。

## readで標準入力を読み込む
readは一行ずつ標準入力を読み込みます。試しに次のファイルを読み込んでみて、結果をアスキーコードで出力して見ます。
```
 A B    C  D
 E
F
```
このファイルには空白やタブを下記のように入れています。
```
<空白>A<空白>B<タブ>C<空白2個>D<改行><空白>E<空白><改行>F
```
```console:console
$ cat file.txt | sh stdin_read.sh
Recieved: A B   C  D
Length: 8
65
0
66
0
67
0
0
68
Recieved: E
Length: 1
69
Recieved: F
Length: 1
70
```
行頭や行末の空白は捨てられます。タブも空白もprintfでは0が出力されます。空白が2個並んだところは0が2個並びます。

## catで標準入力を読み込む
同じファイルをcatで読み込んで、結果をアスキーコードで出力してみます。
```console:console
$ cat file.txt | sh stdin_cat.sh
Recieved:  A B  C  D
 E
F
Length: 15
0
65
0
66
0
67
0
0
68
0
0
69
0
0
70
```
catはreadと違って先頭の空白が残ります。タブも空白もprintfで0になるところはreadと同じで、更に改行も0なります。

## 読み込んだ文字列を配列に入れる
上記の方法で読み込んだ文字列は`array=(${s})`で配列に入れることができます。
```console:console
$ cat file.txt | sh cat2array.sh
Recieved:  A B  C  D
 E
F
Length: 15
array[0] = A
array[1] = B
array[2] = C
array[3] = D
array[4] = E
array[5] = F
```
こうすると、先頭の空白も、空白が2個連続するところも無視されて、文字だけが配列に入ります。

## readでカラムを分けて読み込む
readは引数を複数にすると、カラムに分けて先頭の引数から順番に入れていきます。最後の引数には残りのカラムがすべて入ります。言葉で説明するのはわかりにくいので、実際にやってみます。
```console:file_read.sh
#!/bin/sh
exec {FD}</etc/hosts
while read -u ${FD} ip host aliases
do
  echo "IP address = ${ip}"
  echo "Hostname = ${host}"
  echo "Alias(es) = ${aliases}"
done
```
```console:console
$ sh file_read.sh
IP address = 127.0.0.1
Hostname = localhost
Alias(es) = localhost.localdomain localhost4 localhost4.localdomain4
IP address = ::1
Hostname = localhost
Alias(es) = localhost.localdomain localhost6 localhost6.localdomain6
```
以上です。
