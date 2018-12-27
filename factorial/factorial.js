var n = process.argv[2];

function factorial(i) {
  if(i == 1) {
    return 1;
  }
  else {
    return i * factorial(i - 1)
  }
}

console.log(factorial(n));
