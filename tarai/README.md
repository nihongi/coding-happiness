# �|���֐�

bash�Œ|���֐����v�Z���Ă݂܂��B

## �܂��ʏ��
```bash:tarai01.sh
#!/bin/sh
tarai() {
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
�ċA�Ăяo���̂��тɃT�u�V�F�����N�����Ă��܂��B�����\�����v���v�����܂��B
```console
$ sh tarai01.sh 10 5 0
```
�Ԃ��Ă��܂���B�ʂ̒[������v���Z�X�����Ă݂��
```console
$ ps u -C sh
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
nihongi   5805  0.0  0.0 113176  1440 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5806  0.0  0.0 113176   384 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5807  0.0  0.0 113176   640 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5808  0.0  0.0 113176   612 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5809  0.0  0.0 113176   644 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   5810  0.0  0.0 113176   624 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   9947  0.0  0.0 113176   660 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi   9948  0.0  0.0 113176   636 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  19318  0.0  0.0 113176   668 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  19319  0.0  0.0 113176   652 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20209  0.0  0.0 113176   680 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20210  0.0  0.0 113176   664 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20211  0.0  0.0 113176   692 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20212  0.0  0.0 113176   676 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
nihongi  20213  0.0  0.0 113176   704 pts/0    S+   02:26   0:00 sh tarai01.sh 10 5 0
�ȉ��ȗ�
```
��������v���Z�X���オ���Ă���̂ŁA�����Ă���̂͊ԈႢ�Ȃ��悤�ł��B

## �����N���Ă���̂�
�֐����Ăяo���ꂽ�Ƃ��ɁA���̓p�����[�^���G���[�o�͂ɕ\�����鏈����ǉ����āA�����N���Ă��邩���Ă݂܂��B
```bash:tarai02.sh
  echo "${1} ${2} ${3}" >&2
```

```console
$ sh tarai02.sh 10 5 0
10 5 0
9 5 0
8 5 0
7 5 0
6 5 0
5 5 0
4 0 6
3 0 6
2 0 6
1 0 6
0 0 6
-1 6 1
5 1 0
4 1 0
�ȉ��ȗ�
```
(10, 5, 0)�ł͖����Ȃ̂�(5, 2, 0)���炢�ɓ��a��܂��B
```console
$ sh tarai02.sh 5 2 0 2> tarai.log
5
$ wc -l tarai.log
149 tarai.log
$ sort -u tarai.log | wc -l
37
```
149��̌Ăяo��������A���j�[�N�Ȃ��̂�37��ł��邱�Ƃ��킩��܂����B���ʂ��L���b�V������Ή��P�����҂ł��܂��B

## �L���b�V���ł��邩�H
�A�z�z��ŃL���b�V����낤�Ƃ��܂����������ł����B�O�Ɍ����悤�ɍċA�Ăяo�����ʃv���Z�X�ɓW�J����Ă��܂��̂ŁA�����A�z�z������ꂼ��̃v���Z�X����Q�Ƃ��邱�Ƃ��ł��܂���B

���{�I�ɏ������������K�v�����肻���ł��B����A�u�ċA���Ȃ��|���֐��v�����y���݂ɁB