#!/bin/sh

if [ ${1} -eq 2 ]; then
  exit 0
fi

coproc mc { telnet localhost 11211; }

(sh test2.sh $(( ${1} + 1 )))&
wait $!

echo "quit" >&"${mc[1]}"

