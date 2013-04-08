source ./papertest/helper_script.sh

OUTPUT_DIR=papertest/testout-6-3-2
LINE='$p'

function GetByGraph() {
FILES="${OUTPUT_DIR}/${ALGO}-origin-${GRAPH}-*[0-9]"
printf "%-9s %s\n" ${GRAPH} `GetAverageTimeByLine`
}

function GetByAlgo() {
echo ----------------------- ${ALGO} -----------------------

GRAPH=rmat
GetByGraph

GRAPH=rand
GetByGraph

GRAPH=wikitalk
GetByGraph

GRAPH=roadnetca
GetByGraph
}

ALGO=shortest_path
GetByAlgo

ALGO=breadth_first_search
GetByAlgo
