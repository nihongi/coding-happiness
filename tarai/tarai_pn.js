// var formula = ['t', process.argv[2], process.argv[3], process.argv[4]];
// var formula=process.argv[2];

var formula = ['t','t', '1', '1', '0', 't', '0', '0', '2', 't', '-1', '2', '1'];
//var formula = ['t', '1', '1', '0'];
console.error(formula);

var p;       // ポインタ
var start;   // 計算する部分の開始位置
var end;     // 計算する部分の終了位置
//var tmp_end; // 計算する部分の仮の終了位置
var result;  // 計算する部分の計算結果、未定の場合は-10000

//while(true) {  // 式の変形結果が数値になるまで繰り返す
//  if(! isNaN(formula[0])) break;
  p = 0;
//  result = -10000;
  set_range:
  while(true) {  // 計算可能な式の開始位置と終了位置を決める
    if('t' == formula[p]) {
      if(isNaN(formula[p + 1])) {
        p += 1;
//        continue;
      }
      else if(isNaN(formula[p + 2])) {
        p += 2;
//        continue;
      }
      else {  // 「t, <数値>, <数値>, <式 or 数値>」を見つけた
        if(formula[p + 1] <= formula[p + 2]) {
          // x <= y の場合
          result = formula[p + 2];
        }
        start = p;
        end = p + 3;
        p = end;
        while(true) {  // 式の終了位置を探す
          if(! isNaN(formula[p])) {
            if(p == end) {
              break set_range;
            }
          }
          else {
            if('t' == formula[p]) {
              end += 3;
            }
            else { // 's' == formula[p]
              end += 1;
            }
          }
          p += 1;
        }
      }
    }
    else if('s' == formula[p]) {
      if(isNaN(formula[p + 1])) {
        p += 1;
      }
      else {  // 「s, <数値>」を見つけた
        start = p;
        end = p + 1;
        result = formula[p + 1] - 1;
        break;
      }
    }
    else {
      p += 1;
    }
  }

console.error("start = %d, end = %d", start, end);
  // 計算可能な式の開始位置と終了位置が決まった

  // resultが計算済みの場合 (式を縮める方向)

  // resultが未計算の場合 zは start+3からendまで


//}
