var formula = ['t', process.argv[2], process.argv[3], process.argv[4]];

console.error(formula);

var p;

while(true) {
  if(! isNaN(formula[0])) break;
  p = 0;
  while(true) {
    if('t' == formula[p]) {
      if(isNaN(formula[p+1])) {
        p += 1;
        break;
      }
      else if(isNaN(formula[p+2]) {
        p += 2;
        break;
      }
      else
//  if ( p == formula.length ) break;
}
