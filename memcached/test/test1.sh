#!/bin/sh

expect -c "
set timeout 20
spawn telnet localhost 11211
expect \"'^]'.\"
send \"set mykey 0 60 7\rmyvalue\r\"
expect \"STORED\"
send \"quit\r\"
"

expect -c "
set timeout 20
spawn telnet localhost 11211
expect \"'^]'.\"
send \"get mykey\r\"
expect \"END\"
send \"quit\r\"
"
