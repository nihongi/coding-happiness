#!/bin/bash

put() {
  # ${1}の${2}列目にクイーンを置く
  # 0列目は無条件に置ける
  if [[ ${2} -eq 0 ]]; then
    for i in {0..7}
    do
      put "${i}" 1
    done
  else
  # 1列目以降
    # もしi行目にクイーンを置いたら(${2}-1)列目までに衝突があるかを調べる
    # 衝突がなければクイーンを置いて次の列に行く
    board=(${1})
    for i in {0..7}
    do
      for j in `seq 0 $(( ${2} - 1 ))`  # j列目
      do
        if [[ ${board[j]} -eq ${i} ||\
              ${board[j]} -eq $(( ${i} + ${2} - ${j} )) ||\
              ${board[j]} -eq $(( ${i} - ${2} + ${j} )) ]]; then
          continue 2
        fi
      done
      # 衝突なし
      if [[ ${2} = 7 ]]; then
        echo "${1} ${i}"
      else
        put "${1} ${i}" $(( ${2} + 1 ))
      fi
    done
  fi
}

put "" 0
