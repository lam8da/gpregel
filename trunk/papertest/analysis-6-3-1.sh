source ./papertest/helper_script.sh

function GetTimeByAlgoGraph() {
echo ''

if [ "${GRAPH}" != "bip" ]; then
  LINE="27p"  # rmat, rand, wikitalk, roadnetca
  echo ${GRAPH}:
else
  LINE="28p"  # bip
fi

for ((bs=128; bs<=1024; bs=bs+128)); do
  FILES="papertest/testout-6-3-1/${ALGO}-${GRAPH}-${bs}-*"
  GetAverageTimeByLine
done
}

function GetTimeByAlgo() {
echo "-------------------------- ${ALGO} --------------------------"

GRAPH=rmat
GetTimeByAlgoGraph

GRAPH=rand
GetTimeByAlgoGraph

GRAPH=wikitalk
GetTimeByAlgoGraph

GRAPH=roadnetca
GetTimeByAlgoGraph

echo ''
}

ALGO=shortest_path
GetTimeByAlgo

ALGO=breadth_first_search
GetTimeByAlgo

ALGO=page_rank
GetTimeByAlgo

ALGO=bipartite_matching
GRAPH='bip'
echo "-------------------------- ${ALGO} --------------------------"
GetTimeByAlgoGraph
