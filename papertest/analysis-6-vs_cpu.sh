source ./papertest/helper_script.sh

FORMATLAB=${FORMATLAB:-''}

function GetByGraph() {
LINE='22p'
gpu_step=`GetAverageTimeByLine`

LINE='26p'
cpu_prepare=`GetAverageTimeByLine`

LINE='27p'
cpu_run=`GetAverageTimeByLine`

LINE='32p'
gpu_prepare=`GetAverageTimeByLine`

LINE='33p'
gpu_run=`GetAverageTimeByLine`

cpu_total=$(echo "scale=3;${cpu_prepare}+${cpu_run}" | bc)
gpu_total=$(echo "scale=3;${gpu_prepare}+${gpu_run}" | bc)

if [ "${FORMATLAB}" != "" ]; then
  printf "%-9s --- [%9.4f %9.4f %9.4f %9.4f];\n" \
    ${GRAPH} ${cpu_prepare} ${cpu_run} ${gpu_prepare} ${gpu_run}
else
  printf "%-9s --- cpu (prepare %9.4f, run %9.4f, total %9.4f); gpu (step %9.4f, prepare %9.4f, run %9.4f, total %9.4f)\n" \
    ${GRAPH} ${cpu_prepare} ${cpu_run} ${cpu_total} ${gpu_step} ${gpu_prepare} ${gpu_run} ${gpu_total}
fi
}

function GetByAlgo() {
echo -------------- ${ALGO} ${SCHEME} --------------

GRAPH=rmat
FILES="papertest/testout-6-3-2/${ALGO}-${SCHEME}-${GRAPH}-*[0-9]"
GetByGraph

GRAPH=rand
FILES="papertest/testout-6-3-2/${ALGO}-${SCHEME}-${GRAPH}-*[0-9]"
GetByGraph

GRAPH=wikitalk
FILES="papertest/testout-6-3-2/${ALGO}-${SCHEME}-${GRAPH}-*[0-9]"
GetByGraph

GRAPH=roadnetca
FILES="papertest/testout-6-3-2/${ALGO}-${SCHEME}-${GRAPH}-*[0-9]"
GetByGraph

echo ''
}

SCHEME=origin
ALGO=shortest_path
GetByAlgo

SCHEME=origin
ALGO=breadth_first_search
GetByAlgo

SCHEME=origin
ALGO=page_rank
GetByAlgo

SCHEME=origin-full
ALGO=page_rank
GetByAlgo
