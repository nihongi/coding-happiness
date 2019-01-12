MC_HOST="localhost"
MC_PORT="11211"

mc_open() {
  if [ -z ${mc} ]; then
    coproc mc { telnet ${MC_HOST} ${MC_PORT}; } 2>/dev/null
    # telnet接続時の出力を読み飛ばす (最後が'^]'.なら終わり)
    while read -t 3 r <&"${mc[0]}"
    do
      if [ "${r:$(( ${#r[@]} - 7 )):5}" = "'^]'." ]; then
        break
      fi
    done
  fi
}

mc_set() {
  local r
  echo "set ${1} 0 ${2} ${#3}" >&"${mc[1]}"
  echo "${3}" >&"${mc[1]}"
  read -t 3 r <&"${mc[0]}"
  if [ "${r}" = "STORED" ]; then
    return 0
  else
    echo ${r} >&2
    return 1
  fi
}

mc_get() {
  local i r v
  echo "get ${1}" >&"${mc[1]}"
  for i in {0..2}      # 値があれば3行目、無ければ1行目が"END"
  do
    read -t 3 r <&"${mc[0]}"
    if [ "${r}" = "END" ]; then
      echo -n ${v}
      break
    else
      v=${r}
    fi
  done
  return 0
}

mc_close() {
  if [ ! -z ${mc} ]; then
    echo "quit" >&"${mc[1]}"
    unset mc
  fi
}


