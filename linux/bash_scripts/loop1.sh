#!/bin/bash
while true
do 
    x=$((x+1))
    /bin/pwd > /dev/null
    if [ $x -gt 50000 ]
        echo "Program Completed."
    then    
        exit
    fi
done