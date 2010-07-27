#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='WORKS'
fi

./wiki-tests.sh Regression fr pt  | grep -C $C "$GREP"

echo ""

./wiki-tests.sh Regression pt fr  | grep -C $C "$GREP"


