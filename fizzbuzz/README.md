# FizzBuzz���

1����100�܂ł̐������o�͂���B
�������A3�Ŋ���؂��ꍇ�́uFizz�v���A5�Ŋ���؂��ꍇ�́uBuzz�v���A�����Ŋ���؂��ꍇ�́uFizzBuzz�v���o�͂���B

�Ƃ����L���Ȗ��ł��B�ł������A���f���E���s�������炷�悤�ɍH�v���Ă݂܂����B

## �H�v���̂P
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
2��if���ŉ��L��4�̕��ނ��s���܂��B15�Ŋ���؂�邩�ǂ����̔��f���s��Ȃ����@�ŁAWikipedia�Ȃǂɂ�������Ă��܂��B

<table border="1">
<tr>
<th>3�Ŋ���؂��</th>
<th>5�Ŋ���؂��</th>
<th>s�̓��e</th>
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
<td>����`</td>
</tr>
</table>

## �H�v���̂Q
```console
  echo ${s-${i}}
```
����`-`�́A����������ς݂ł���΍����̒l���g�p�A����`�ł���ΉE���̒l���g�p����A�Ƃ����V�F���ϐ��Ɠ��̋L�@�ł��B�����I�ɂ��̒��ɔ��f���������Ă���킯�ł����A�����ڂ�if�������炷���Ƃ��ł��܂��B

## �g����
```console
$ sh fizzbuzz.sh
```

## �H�v����3
�H�v���̂Q�����p���āAif����S���g��Ȃ�FizzBuzz����邱�Ƃ��ł��܂��B������fizzbuzz2.sh���������������B

�ȏ�ł��B