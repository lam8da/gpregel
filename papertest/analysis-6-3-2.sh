source ./papertest/helper_script.sh

function GetByGraph() {
FILES="papertest/testout-6-3-2/${ALGO}-origin-${GRAPH}*"
t1=`GetAverageTimeByLine`

FILES="papertest/testout-6-3-2/${ALGO}-sorted-${GRAPH}*"
t2=`GetAverageTimeByLine`

printf "%-9s --- origin: %9.3f, sorted: %9.3f\n" ${GRAPH} ${t1} ${t2}
}

function GetByAlgo() {
echo -------------- ${ALGO} --------------
LINE="31p"

GRAPH=rmat
GetByGraph

GRAPH=rand
GetByGraph

GRAPH=wikitalk
GetByGraph

GRAPH=roadnetca
GetByGraph

echo ''
}

ALGO=shortest_path
GetByAlgo

ALGO=breadth_first_search
GetByAlgo

ALGO=page_rank
GetByAlgo

GRAPH='bip'
ALGO=bipartite_matching
echo -------------- ${ALGO} --------------
LINE="32p"
GetByGraph
