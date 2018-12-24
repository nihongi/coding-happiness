#!/bin/sh
WEEK_DAY=("Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday")
NOW=($(date "+%Y %m %d"))
: ${Y=${1:-${NOW[0]}}}
: ${M=${2:-${NOW[1]}}}
: ${D=${3:-${NOW[2]}}}
echo $Y"/"$M"/"$D
echo ${WEEK_DAY[$(( ( $Y + $Y / 4 - $Y / 100 + $Y / 400 + ( 13 * $M + 8 ) / 5 + $D ) % 7 ))]}
