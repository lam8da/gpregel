BLOCK_SIZE=128

function GetAverageTime() {
count=0;
total=0;

for i in papertest/testout-6-3-2/${ALGO}-${SCHEME}-${GRAPH}*; do
  step=$(sed -n '22p' $i | sed 's/^.*://');
  time=$(sed -n '28p' $i | sed 's/^.*://;s/ms *//');

  if [ -n "${time}" ]; then
    total=$(echo "${total}+${time}" | bc);
    count=$[count+1];
    # echo ${time} ${total} ${count}
  fi
done

echo $(echo "scale=3;${total}/${count}" | bc);
}

function GetByGraph() {
SCHEME=origin
t1=`GetAverageTime`

SCHEME=sorted
t2=`GetAverageTime`

echo "   ---   origin: " ${t1} "     sorted: " ${t2}
}

function GetByAlgo() {
echo -------------- ${ALGO} --------------

GRAPH=rmat
echo "rmat     " `GetByGraph`

GRAPH=rand
echo "rand     " `GetByGraph`

GRAPH=wikitalk
echo "wikitalk " `GetByGraph`

GRAPH=roadnetca
echo "roadnetca" `GetByGraph`

echo ''
}

ALGO=shortest_path
GetByAlgo

ALGO=breadth_first_search
GetByAlgo

ALGO=page_rank
GetByAlgo

GRAPH=''
ALGO=bipartite_matching
echo -------------- ${ALGO} --------------
echo "bip      " `GetByGraph`
