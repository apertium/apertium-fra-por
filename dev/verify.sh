#!/bin/sh -vx
./inconsistency.sh fr-pt > frptinconsistency.txt
./inconsistency-summary.sh frptinconsistency.txt fr-pt
./inconsistency.sh pt-fr > ptfrinconsistency.txt
./inconsistency-summary.sh ptfrinconsistency.txt pt-fr
