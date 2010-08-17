#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
    C=$1
    GREP='WORKS'
fi

sh wiki-tests.sh Pending fr pt update | grep -C $C "$GREP"
sh wiki-tests.sh Pending pt fr update | grep -C $C "$GREP"


