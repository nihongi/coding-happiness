#!/bin/sh
exec {FD}</etc/hosts
while read -u ${FD} ip host aliases
do
  echo "IP address = ${ip}"
  echo "Hostname = ${host}"
  echo "Alias(es) = ${aliases}"
done
