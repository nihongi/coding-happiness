#!/bin/sh
WEEK_DAY=("Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday")
DAY=($(echo ${1} | sed -e 's/\// /g'))
TODAY=($(date "+%Y %m %d"))
Y=${DAY[0]:-${TODAY[0]}}
M=${DAY[1]:-${TODAY[1]}}
D=${DAY[2]:-${TODAY[2]}}
echo "${Y}/${M}/${D}"
echo ${WEEK_DAY[$(( ( ${Y} + ${Y} / 4 - ${Y} / 100 + ${Y} / 400 + ( 13 * ${M} + 8 ) / 5 + ${D} ) % 7 ))]}
