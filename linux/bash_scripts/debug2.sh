#!/bin/bash
set -u
set -x
a=1
echo my PID is $$
set +x
b=2
set -x
echo a is $a b is $b c is $c
# if 
#     true
# then 
#     echo true is successful
# else
#     echo true is not successful
# fi