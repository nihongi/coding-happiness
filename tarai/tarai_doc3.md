# �ċA���Ȃ��|���֐��̍�����

�ċA���Ȃ��|���֐�( https://qiita.com/nihongi/items/785319a005c44add7ba1 )�̑����ł��B

## �T�u�V�F�����g��Ȃ�

replace�̒��ŃT�u�V�F���Ǝg���Ă����Ƃ�����C�����܂��B���ꁫ���C���O�B

```bash:�C���O
replace() {
  # ${1}�Ԗڂ̃X�^�b�N�̕���${2}�𐔎�${3}�ɒu��������
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

```

�����̒u�������Ȃ̂ŕ��ʂ�sed���g�������Ȃ�Ƃ���ł����A���ꂾ�Ƃǂ����Ă��T�u�V�F���ɂȂ��Ă��܂��A�x���Ȃ錴���ɂȂ肻���ł��B������sed���g��Ȃ������ɏC�����܂����B

```bash:�C����
replace() {
  # ${1}�Ԗڂ̃X�^�b�N�̕���${2}�𐔎�${3}�ɒu��������
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
��r���Ă݂�ƁA

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
����A22�b����C��3�b��܂ŏk�܂�܂����B�T�u�V�F������ׂ��B

## �x���]��

�|���֐���`if x>y then {...} else y`�����������z���g�킸�Ɍv�Z�ł��邱�Ƃ��킩��܂��B�����ŁA���x��y���v�Z����z���K�v���ǂ������ɂ߂āA�K�v�ȏꍇ�ɂ����v�Z����Ƃ����悤�ɏ��������P���܂��B���̂��߂�job�̒�`���g�����܂��B

```
job[0]: ���p�����[�^�̐��l�A����̏ꍇ��"x"
job[1]: ���p�����[�^�̐��l�A����̏ꍇ��"y"
job[2]: ��O�p�����[�^�̐��l�A����̏ꍇ��"z"
job[3]: tarai�̌v�Z���ʂ̐��l�A����̏ꍇ��"r"
job[4]: �v�Z����r�̑�����job(�X�^�b�N�̉��Ԗڂ�)
job[5]: �v�Z����r�̑����("x", "y", "z", "r")
job[6]: (optional:job[2]������̏ꍇ�̂�) z���v�Z����tarai�̑��p�����[�^
job[7]: (optional:job[2]������̏ꍇ�̂�) z���v�Z����tarai�̑��p�����[�^
job[8]: (optional:job[2]������̏ꍇ�̂�) z���v�Z����tarai�̑�O�p�����[�^
```
�����̎菇�͎��̒ʂ�ł��B

* �X�^�b�N����job�����o��
    * r���v�Z�ς݂̏ꍇ
        * ���ꂪ�ŏ���job�ł���ΏI��
        * �����łȂ���΁A�v�Z���ʂ̑����ɑ������
    * r���v�Z�ς݂łȂ��ꍇ
        * r�������Ɍv�Z�\��(���Ȃ킿x<=y��)��yes
            * ���ꂪ�Ō�̃W���u�̏ꍇ�͂����ŏI��
            * �����łȂ���΁A�v�Z���ʂ̑�����y��������
        * r�������Ɍv�Z�\��(���Ȃ킿x<=y��)��no
            * job���X�^�b�N�ɖ߂�
            * z�͌v�Z�ς݂���yes
                * r���v�Z���邽�߂̐V����job(3��)���X�^�b�N�ɒǉ�����
            * z�͌v�Z�ς݂���no
                * z���v�Z���邽�߂̐V����job(1��)���X�^�b�N�ɒǉ�����

�v���Ă݂܂��B

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
Tarai(8,4,0)��3.7�b����0.02�b�ƁA�߂���߂��ᑬ���Ȃ�܂����BTarai(100,50,0)�ł������I�Ȏ��ԂŌv�Z�ł���悤�ɂȂ�܂����B

���O�̍s�������邱�ƂŃ��[�v�̉񐔂��킩��܂��B

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
tarai(8, 4, 0)�̏ꍇ�A���P�O�ɂ�15756�񂾂������[�v�����P��ɂ�65��Ɍ������Ă��܂��B�����Ԃ�Ɩ��ʂȌv�Z�����Ă������Ƃ��킩��܂��Btarai(10, 5, 0)�ł́A���[�v��10001��܂��܂����B

## �������͕s�v

�v�Z���ʂ�A�z�z�񓙂ɓ���Čv�Z�ς݂̂��̂͂�����Q�Ƃ���悤�ɂ����炳��ɑ����Ȃ�ł��傤��?

���͓�����No�ł��B
�܂� x<=y �̏ꍇ�� tarai(x, y, z) = y �Ȃ̂Ń����������Ă������Ɍv�Z�ł��܂��B���������L���Ȃ̂́Ax>y �ł�����r������ȃW���u�ɂ��Ă݂̂ł��B���ꂪ���񂠂��������ׂ܂��B

```console
$ awk '{if($4=="r" && $1>$2) print $1" "$2" "$3}' tarai.log | wc -l
2500
```

���傤��2500��ł��B���̒��Ń��j�[�N�Ȃ��̂��������邩�����Ă݂��

```console
$ awk '{if($4=="r" && $1>$2) print $1" "$2" "$3}' tarai.log | sort -u | wc -l
2500
```

�Ȃ�Ƃ��ׂă��j�[�N�ł����B�܂�A�v�Z���ʂ������ɓ��ꂽ�Ƃ���ŁA������g���P�[�X�͂Ȃ��Ƃ������Ƃ��킩��܂����B

## �\�[�X
�Ō�ɂ����܂ł̃\�[�X�S�̂��ڂ��Ă����܂��B

```bash:tarai05.sh
#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}�Ԗڂ̃X�^�b�N�̕���${2}�𐔎�${3}�ɒu��������
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
