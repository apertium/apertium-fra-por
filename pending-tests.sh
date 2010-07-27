#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='WORKS'
fi

./wiki-tests.sh Pending fr pt  | grep -C $C "$GREP"

echo ""

./wiki-tests.sh Pending pt fr  | grep -C $C "$GREP"


