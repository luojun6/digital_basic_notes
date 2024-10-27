#!/bin/bash
message=$(nc -l 1234)
sleep 4
echo $messageback back to your > /dev/tcp/localhost/1235