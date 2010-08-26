TMPDIR=/tmp

if [[ $1 = "pt-fr" ]]; then

lt-expand ../apertium-fr-pt.pt.dix | grep -v '<prn><enc>' | grep -e ':>:' -e '\w:\w' | sed 's/:>:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ../apertium-fr-pt.pt-fr.t1x  ../pt-fr.t1x.bin  ../pt-fr.autobil.bin |
        apertium-interchunk ../apertium-fr-pt.pt-fr.t2x  ../pt-fr.t2x.bin |
        apertium-postchunk ../apertium-fr-pt.pt-fr.t3x  ../pt-fr.t3x.bin  | tee $TMPDIR/tmp_testvoc2.txt |
        lt-proc -d ../pt-fr.autogen.bin > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

elif [[ $1 = "fr-pt" ]]; then

lt-expand ../fr.dix | grep -v '<prn><enc>' | grep -e ':>:' -e '\w:\w' | sed 's/:>:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ../apertium-fr-pt.fr-pt.t1x  ../fr-pt.t1x.bin  ../fr-pt.autobil.bin |
        apertium-interchunk ../apertium-fr-pt.fr-pt.t2x  ../fr-pt.t2x.bin |
        apertium-postchunk ../apertium-fr-pt.fr-pt.t3x  ../fr-pt.t3x.bin  | tee $TMPDIR/tmp_testvoc2.txt |
        lt-proc -d ../fr-pt.autogen.bin > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'


else
	echo "sh inconsistency.sh <direction>";
fi
