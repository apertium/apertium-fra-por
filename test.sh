#!/bin/sh

echo "uma advertência > un avertissement"
echo "uma advertência" | apertium pt-fr
echo ""

echo "esse gato > ce chat"
echo "esse gato" | apertium pt-fr
echo ""

echo "este gato > ce chat-ci"
echo "este gato" | apertium pt-fr
echo ""

echo "aquele gato > ce chat-là"
echo "aquele gato" | apertium pt-fr
echo ""

echo "o gato branco > le chat blanc"
echo "o gato branco" | apertium pt-fr
echo ""

echo "uma advertência nova > un nouveau avertissement"
echo "uma advertência nova" | apertium pt-fr
echo ""

echo "uma advertência grande > un grand avertissement"
echo "uma advertência grande" | apertium pt-fr
echo ""

echo "tanto cabelo quanto você > autant de cheveux que vous"
echo "tanto cabelo quanto você" | apertium pt-fr
echo ""

echo "tão pequeno quanto ele > aussi petit que lui"
echo "tão pequeno quanto ele" | apertium pt-fr
echo ""

echo "en ville > na cidade"
echo "en ville" | apertium fr-pt
echo ""

echo "en France > na França"
echo "en France" | apertium fr-pt
echo ""

echo "On ne parle pas > Não se fala"
echo "On ne parle pas" | apertium fr-pt
echo ""

echo "Não se fala > On ne parle pas"
echo "Não se fala" | apertium pt-fr
echo ""

echo "É grande > C'est grand";
echo "É grande" | apertium pt-fr
echo ""

echo "Se ele queria, o faria > S'il voulait, il le ferait";
echo "Se ele queria, o faria" | apertium pt-fr
echo ""

exit

echo "du vôtre" | apertium -d . fr-pt-tagger
echo "";

echo "du vôtre" | apertium fr-pt
echo "";

echo "le vôtre" | apertium -d . fr-pt-tagger
echo "";

echo "le vôtre" | apertium fr-pt
echo "";

echo "o vosso" | apertium -d . pt-fr-tagger
echo "";

echo "o vosso" | apertium pt-fr
echo "";

echo "ao vosso" | apertium -d . pt-fr-tagger
echo "";

echo "ao vosso" | apertium pt-fr
echo "";