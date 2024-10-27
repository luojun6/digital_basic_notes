#!/bin/bash

function f {
    typeset A
    A=2
    echo A=$A
}

A=2
f
echo after f. A = $A