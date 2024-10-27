#!/bin/bash
./ans.sh &
export TIMEFORMAT='%3R'
sleep 1 # give ans.sh some time to get going and start listening
N1=$SECONDS
echo hi >/dev/tcp/localhost/1234
ans=$(nc -l 1235) # nc means netcap
echo ans=$ans, elasped=$(($SECONDS-$N1))