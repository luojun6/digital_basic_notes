#!/bin/bash

if test -x /bin/ls
then
    if
    [ ! -w /etc/hosts ]
    then
        if
        echo about to look for foobar
        grep -q foobar /etc/passwd
        then
            echo foobar found in /etc/passwd
        fi
            echo foobar not fould
fi
else 
echo OH no, /bin/ls not executable.
fi