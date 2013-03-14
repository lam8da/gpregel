GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
NUME=${NUME:-16000000}
DELTAE=${DELTAE:-NUMV}

echo "------------ origin ------------"
for ((e=${NUMV}; e<=${NUME}; e+=${DELTAE})); do
  sed -n '34p' papertest/testout-6-3-3/origin-${GRAPH}-${NUMV}-${e}-1000
done

echo "------------ share ------------"
for ((e=${NUMV}; e<=${NUME}; e+=${DELTAE})); do
  sed -n '34p' papertest/testout-6-3-3/share-${GRAPH}-${NUMV}-${e}-1000
done

echo "------------ rolling ------------"
for ((e=${NUMV}; e<=${NUME}; e+=${DELTAE})); do
  sed -n '34p' papertest/testout-6-3-3/rolling-${GRAPH}-${NUMV}-${e}-1000
done
