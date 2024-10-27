#!/bin/bash

for i in *.c
do 
    echo ${i%.c}
done