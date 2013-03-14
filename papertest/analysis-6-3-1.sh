function GetTimeByAlgoGraph() {
echo ''

if [ "${GRAPH}" != "" ]; then
  echo ${GRAPH}:
fi

for ((bs=128; bs<=1024; bs=bs+128)); do
  count=0;
  total=0;
  for i in papertest/testout-6-3-1/${ALGO}-${GRAPH}*${bs}-*; do
    step=$(sed -n '22p' $i | sed 's/^.*://');
    time=$(sed -n '28p' $i | sed 's/^.*://;s/ms *//');

    if [ -n "${time}" ]; then
      total=$(echo "${total}+${time}" | bc);
      count=$[count+1];
      # echo ${time} ${total} ${count}
    fi
  done

  echo ${bs} "  " $(echo "scale=3;${total}/${count}" | bc);
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
GRAPH=''
echo "-------------------------- ${ALGO} --------------------------"
GetTimeByAlgoGraph
