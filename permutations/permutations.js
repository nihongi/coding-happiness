// 元の数
var n = process.argv[2];

// 選ぶ数
var k = process.argv[3]

// 数字が使われたかどうか。used[0]は使わない
var used = new Array(n);

// 順列を入れる配列。p[0]～[k-1]を使う
var p = new Array(k-1);

// 場所posに数値iを入れる。選ぶ数に達していれば結果を出力して終了。
// 達していなければ、次の場所に数値を入れる
function put(pos, i, k) {
  p[pos] = i;
  if(pos == k - 1) {
    show();
  }
  else {
    used[i] = true;
    for(var j = 1; j <= n; j++) {
      if(!used[j]) {
        put(pos + 1, j, k);
      }
    }
    used[i] = false;
  }
}

// 結果を表示する
function show() {
  var str = p[0];
  for(var i = 1; i <= k - 1; i++) {
    str = str + " " + p[i];
  }
  console.log(str);
}

// 実行する
for(var i = 1; i <= n; i++) {
  put(0, i, k);
}
