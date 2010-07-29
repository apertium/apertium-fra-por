echo "==French->Portuguese===========================";
sh inconsistency.sh fr-pt > /tmp/frpt; sh inconsistency-summary.sh /tmp/frpt fr-pt
echo ""
echo "==Portuguese->French===========================";
sh inconsistency.sh pt-fr > /tmp/ptfr; sh inconsistency-summary.sh /tmp/ptfr pt-fr
