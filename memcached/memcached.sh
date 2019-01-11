MC_HOST="localhost"
MC_PORT="11211"

mc_open() {
  coproc mc { telnet ${MC_HOST} ${MC_PORT}; } 2>/dev/null
  # telnet接続時の出力を3行分読み飛ばす
  read <&"${mc[0]}"    # Trying ::1...
  read <&"${mc[0]}"    # Connected to localhost.
  read <&"${mc[0]}"    # Escape character is '^]'.
}

mc_set() {
  local r
  echo "set ${1} 0 ${2} ${#3}" >&"${mc[1]}"
  echo "${3}" >&"${mc[1]}"
  read r <&"${mc[0]}"
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
    read r <&"${mc[0]}"
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
  echo "quit" >&"${mc[1]}"
}


