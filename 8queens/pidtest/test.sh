#!/bin/sh
echo ${BASHPID}
cat /etc/hosts >> out.${BASHPID}
