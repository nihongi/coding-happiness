# �ċA����|���֐���������

�ċA���Ȃ��|���֐��̍�����( https://qiita.com/nihongi/items/cb8ba21562d430d4fc63 )�̑����ł��B�O��A�`���ς�肷���Ē|���֐������������킩��Ȃ��Ȃ��Ă����̂ŁA���_�ɕԂ�܂��B

## �������|���֐�

```bash:tarai02.sh
#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    echo -n $(tarai $(tarai $(( ${1} - 1 )) ${2} ${3}) \
                    $(tarai $(( ${2} - 1 )) ${3} ${1}) \
                    $(tarai $(( ${3} - 1 )) ${1} ${2}))
  else
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo
```

�O��܂ł̒m���ŁA�x���]���͌��ʐ��A�x���]��������΃������͕s�v�Ƃ������Ƃ��킩��܂����B�܂��A��L�̃R�[�h�����������ό`���܂��B

```bash:tarai06.sh
#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    x=$(tarai $(( ${1} - 1 )) ${2} ${3})
    y=$(tarai $(( ${2} - 1 )) ${3} ${1})
    z=$(tarai $(( ${3} - 1 )) ${1} ${2})
    echo -n $(tarai ${x} ${y} ${z})
  else
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo
```
�����ƍċA�Ăяo�����Ă��܂��B�O����tarai�ɓn��������\�ߌv�Z����悤�ɕς��������ł��B

## �g���W���Ȃ��V���[�g�J�b�g

�����ŁA`x<=y`�ł����Tarai(x, y, z)�̌��ʂ�y���Ƃ킩���Ă���̂ŁAtarai�̌Ăяo�����ȗ��ł��܂��B������x���]���Ƃ������A�V���[�g�J�b�g�ł��ˁB

```bash:tarai07.sh
#!/bin/sh
tarai() {
  echo "${1} ${2} ${3}" >&2
  if [ ${1} -gt ${2} ]; then
    x=$(tarai $(( ${1} - 1 )) ${2} ${3})
    y=$(tarai $(( ${2} - 1 )) ${3} ${1})
    if [ ${x} -gt ${y} ]; then
      z=$(tarai $(( ${3} - 1 )) ${1} ${2})
      echo -n $(tarai ${x} ${y} ${z})
    else
      echo -n ${y}
    fi
  else
    echo -n ${2}
  fi
}

tarai ${1} ${2} ${3}
echo
```
�O��̃X�^�b�N�łƎ��Ԃ��r���Ă݂܂��B

```console
$ time sh tarai05.sh 100 50 0 2>/dev/null
100

real    0m4.218s
user    0m3.912s
sys     0m0.303s
$ time sh tarai07.sh 100 50 0 2>/dev/null
100

real    0m7.628s
user    0m2.107s
sys     0m5.505s
```
�X�^�b�N�ł̕��������ł����A����̍ċA�V���[�g�J�b�g�ł������������Ă��܂��B�X�^�b�N�łł͂قƂ�ǂ̎��Ԃ�user���[�h�Ȃ̂ɑ΂��āA�ċA�V���[�g�J�b�g�łł́Asys���[�h�̎��Ԃ��傫���Ƃ����_�������[���ł��B

## bash�̌��E��

����ρA�����ƃ��_���Ȍ���ł���������ǂ���ˁB(���z)
