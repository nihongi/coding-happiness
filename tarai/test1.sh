#!/bin/sh

coproc mc1 { telnet localhost 11211; }
coproc mc2 { telnet localhost 11211; }

echo "quit" >&"${mc1[1]}"
echo "quit" >&"${mc2[1]}"
