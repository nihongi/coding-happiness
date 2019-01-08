#!/bin/sh

board="0000000000000000000000000000000000000000000000000000000000000000"

put() {
  # ${1}の${2}列目にクイーンを置く
  # 0列目は無条件に置ける
  if [ ${2} -eq 0 ]; then
    children=""
    for i in {0..7}
    do
      tmp=${1:0:$(( ${2} + 8 * ${i} ))}"1"${1:$(( ${2} + 8 * ${i} + 1 ))}
      (put ${tmp} 1)&
      children="${children} $!"
    done
    wait ${children}
    for i in ${children}
    do
      if [ -e /tmp/nq.${i} ]; then
        cat /tmp/nq.${i}
        rm /tmp/nq.${i}
      fi
    done
  else
  # 1列目以降
    # もしi行目にクイーンを置いたら(${2}-1)列目までに衝突があるかを調べる
    # 衝突がなければクイーンを置いて次の列に行く
    children=""
    tmpfiles=""
    for i in {0..7}
    do
      for j in `seq 0 $(( ${2} - 1 ))`  # j列目
      do
        # 横方向
        if [ "${1:$(( ${j} + 8 * ${i} )):1}" = "1" ]; then
          continue 2
        fi
        # 斜め上方向
        if [ $(( ${i} + ${j} - ${2} )) -ge 0 ]; then
          if [ "${1:$(( ${j} + 8 * ( ${i} + ${j} - ${2} ) )):1}" = "1" ]; then
            continue 2
          fi
        fi
        # 斜め下方向
        if [ $(( ${i} + ${2} - ${j} )) -le 7 ]; then
          if [ "${1:$(( ${j} + 8 * ( ${i} + ${2} - ${j} ) )):1}" = "1" ]; then
            continue 2
          fi
        fi
      done
      # 衝突なし
      tmp=${1:0:$(( ${2} + 8 * ${i} ))}"1"${1:$(( ${2} + 8 * ${i} + 1 ))}
      if [ ${2} = 7 ]; then
        pid=${BASHPID}
        echo ${tmp} >> /tmp/nq.${pid}
        echo "debug2 ${pid}" >&2
      else
        (put ${tmp} $(( ${2} + 1 )))&
        children="${children} $!"
      fi
    done
    wait ${children}
    pid=${BASHPID}
    for i in ${children}
    do
      if [ -e /tmp/nq.${i} ]; then
        cat /tmp/nq.${i} >> /tmp/nq.${pid}
        echo "debug3 ${pid}" >&2
        rm /tmp/nq.${i}
      fi
    done
  fi
}

put ${board} 0
