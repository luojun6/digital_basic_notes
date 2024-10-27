#!/bin/bash
# echo no trap
echo sleeping 5, no trap
sleep 5
trap "" INT 
echo ignore interrupt INT
sleep 5
# trap INT with an echo message function
trap "echo You interrupted me now" INT
echo sleeping 5 with INT mesasage
sleep 5