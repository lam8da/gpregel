GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
MAXE=${MAXE:-16000000}
DELTAE=${DELTAE:-1000000}

OUTPUT_DIR=papertest/testout-6-pg_origin-rolling_vs_coalesced-rolling-full

function PrintTime() {
  prepare=`sed -n '36p' ${FILE}`
  run=`sed -n '37p' ${FILE}`
  printf "%s,    %s\n" "${prepare}" "${run}"
}

echo "--------------- origin rolling --------------- "
for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE})); do
  FILE=${OUTPUT_DIR}/origin-rolling-${GRAPH}-${NUMV}-${NUME}-*
  PrintTime
done

echo ''
echo "--------------- origin rolling full --------------- "
for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE})); do
  FILE=${OUTPUT_DIR}/origin-rolling-full-${GRAPH}-${NUMV}-${NUME}-*
  PrintTime
done

echo ''
echo "--------------- coalesced rolling full --------------- "
for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE})); do
  FILE=${OUTPUT_DIR}/coalesced-rolling-full-${GRAPH}-${NUMV}-${NUME}-*
  PrintTime
done
