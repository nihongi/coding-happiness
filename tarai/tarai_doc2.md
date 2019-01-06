# �ċA���Ȃ��|���֐�

bash�Œ|���֐�( https://qiita.com/nihongi/items/21a4a215920150ef7eb8 )�̑����ł��B

## �W���u�̒�`
�X�^�b�N�ɃW���u��ς�ł����ďォ�珈�����Ă��������ɕύX���܂��B�܂��A�W���u�̌`�����`���܂��B

```
job[0]: ���p�����[�^�̐��l�A����̏ꍇ��"x"
job[1]: ���p�����[�^�̐��l�A����̏ꍇ��"y"
job[2]: ��O�p�����[�^�̐��l�A����̏ꍇ��"z"
job[3]: tarai�̌v�Z���ʂ̐��l�A����̏ꍇ��"r"
job[4]: �v�Z����r�̑�����job(�X�^�b�N�̉��Ԗڂ�)
job[5]: �v�Z����r�̑����("x", "y", "z", "r")
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
          * r���v�Z���邽�߂̐V����job(tarai4��)���X�^�b�N�ɒǉ�����

�v����ɁA�X�^�b�N�̈�ԏ���������āA���ʂ��o���ꍇ�́A�X�^�b�N�̓r���ɂł����ʂ����Ă����Ƃ����X�^�C���ł��B

�\�[�X�ł��B

```bash:tarai03.sh
#!/bin/sh
stack[0]="${1} ${2} ${3} r -1 r"

replace() {
  # ${1}�Ԗڂ̃X�^�b�N�̕���${2}�𐔎�${3}�ɒu��������
  tmp=$(echo ${stack[${1}]} | sed -e s/${2}/${3}/)
  stack[${1}]=${tmp}
}

while true
do
  i=$(( ${#stack[@]} - 1 ))
  job=(${stack[i]})
  unset stack[i]
  echo "${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}" >&2
  if [ ${job[3]} = "r" ]; then
    if [ ${job[0]} -le ${job[1]} ]; then
      if [ ${i} -eq 0 ]; then
        echo ${job[1]}
        break
      fi
      replace ${job[4]} ${job[5]} ${job[1]}
    else
      stack[i]="${job[0]} ${job[1]} ${job[2]} ${job[3]} ${job[4]} ${job[5]}"
      stack[i+1]="x y z r ${i} r"
      stack[i+2]="$(( ${job[0]} - 1 )) ${job[1]} ${job[2]} r $(( ${i} + 1 )) x"
      stack[i+3]="$(( ${job[1]} - 1 )) ${job[2]} ${job[0]} r $(( ${i} + 1 )) y"
      stack[i+4]="$(( ${job[2]} - 1 )) ${job[0]} ${job[1]} r $(( ${i} + 1 )) z"
    fi
  else
    if [ ${job[4]} -eq -1 ]; then
      echo ${job[3]}
      break
    else
      replace ${job[4]} ${job[5]} ${job[3]}
    fi
  fi
done
```
����ŏ����������Ȃ����������Ă݂܂��B
�܂��A�ʏ�̍ċA��

```console
$ time sh tarai02.sh 8 4 0 2>/dev/null
8

real    0m7.462s
user    0m4.598s
sys     0m2.849s
```
�ʏ�ł�7.5�b���炢�ł����B���ɍ���̃X�^�b�N��

```console
$ time sh tarai03.sh 8 4 0 2>/dev/null
8

real    0m22.137s
user    0m14.284s
sys     0m7.808s
```
22�b�H ����H

����A�|���֐��̃L���b�V���ƒx���]�������y���݂ɁB
