MC_HOST="localhost"
MC_PORT="11211"

mc_open() {
  mypid=${BASHPID}
  eval "coproc mc${mypid} { telnet ${MC_HOST} ${MC_PORT}; } 2>/dev/null"
  # telnet接続時の出力を読み飛ばす (最後が'^]'.なら終わり)
  eval "mc_out=\${mc${mypid}[0]}"
  eval "mc_in=\${mc${mypid}[1]}"
  while read -t 3 r <&"${mc_out}"
  do
    if [ "${r:$(( ${#r[@]} - 7 )):5}" = "'^]'." ]; then
      break
    fi
  done
}

mc_set() {
  local r
  echo "set ${1} 0 ${2} ${#3}" >&"${mc_in}"
  echo "${3}" >&"${mc_in}"
  read -t 3 r <&"${mc_out}"
  if [ "${r}" = "STORED" ]; then
    return 0
  else
    echo ${r} >&2
    return 1
  fi
}

mc_get() {
  local i r v
  echo "get ${1}" >&"${mc_in}"
  for i in {0..2}      # 値があれば3行目、無ければ1行目が"END"
  do
    read -t 3 r <&"${mc_out}"
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
  echo "quit" >&"${mc_in}"
}


