#!/bin/bash

make -C /lib/modules/$(uname -r)/build M=$PWD modules

# insmod ./lab.ko 
# insmod ./lab4.ko
# rmmod lab lab4
# dmesg | tail