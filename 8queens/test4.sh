#!/bin/sh

for i in {0..4}
do
  if [ -f /tmp/tmp ]; then
    echo ${BASHPID}
  fi
done
