GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-50000}
MAXE=${MAXE:-150000}
DELTAE=${DELTAE:-10000}

OUTPUT_DIR=papertest/testout-6-pg_origin-rolling_vs_coalesced-rolling-full

echo "--------------- origin rolling --------------- "
for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE})); do
  sed -n '35p' ${OUTPUT_DIR}/origin-rolling-${GRAPH}-${NUMV}-${NUME}*
done

echo ''

echo "--------------- coalesced rolling full --------------- "
for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE})); do
  sed -n '35p' ${OUTPUT_DIR}/coalesced-rolling-full-${GRAPH}-${NUMV}-${NUME}*
done
