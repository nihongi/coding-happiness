# Androidのアンロックパターンの数を数える
## 内容

Androidのアンロックパターンは、3×3の9つの点を一筆書きで結んでいくというものです。
可能な結び方は次の通りです。

1. 縦か横か斜めで隣接している場合
2. 桂馬飛びでつながる場合
3. すでに通過済みの点を飛び越えてつながる場合 (未通過の点を飛び越えようとすると、その点が先につながってしまう)

各点に、下記のように番号をつけて点の結び方の例を示すと、

	789
	456
	123
	
1. 7-8, 7-4, 7-5など
2. 7-2, 4-3など
3. 8-9-7, 5-6-8-2など

となります。

こういったつなぎ方で、一筆書きで、４つ以上の点を結ぶというのがアンロックパターンのルールです。

有効なパターンが何通りあるかプログラムで数えてみました。結果は389,112通りです。
つまり、5桁から6桁の暗証番号と同じ安全性ということになります。

内訳は以下の通り。

	長さ4: 1624
	長さ5: 7152
	長さ6: 26016
	長さ7: 72912
	長さ8: 140704
	長さ9: 140704

それぞれが8の倍数になっているのは、1つのパターンに対して、90°ずつ回転して4パターン、左右反転してから90°ずつ回転して4パターンと、合計8パターンが作れるからです。

## プログラム
順列を生成するプログラムを応用したものです。

android-unlock-pattern.html をダウンロードしてブラウザで開けば結果が出ます。