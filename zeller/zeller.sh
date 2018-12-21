#!/bin/sh
WEEK_DAY=("Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday")
YEAR_DEFAULT=1970
MONTH_DEFAULT=1
DATE_DEFAULT=1
: ${Y=${1:-$YEAR_DEFAULT}}
: ${M=${2:-$MONTH_DEFAULT}}
: ${D=${3:-$DATE_DEFAULT}}
echo $Y"/"$M"/"$D
echo ${WEEK_DAY[$(( ( $Y + $Y / 4 - $Y / 100 + $Y / 400 + ( 13 * $M + 8 ) / 5 + $D ) % 7 ))]}
