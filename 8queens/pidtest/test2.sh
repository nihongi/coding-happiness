#!/bin/sh
echo ${BASHPID}
OUT=$(</etc/hosts); echo ${OUT} >> out.${BASHPID}
