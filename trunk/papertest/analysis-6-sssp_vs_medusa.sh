OUTPUT_DIR=papertest/testout-6-sssp_vs_medusa

function GetTimeByGraph() {
count=0;
total=0;
for i in ${OUTPUT_DIR}/${GRAPH}-*; do
  step=$(sed -n '22p' $i | sed 's/^.*://');
  time=$(sed -n '$p' $i | sed 's/^.*://;s/ms *//');

  if [ -n "${time}" ]; then
    total=$(echo "${total}+${time}" | bc);
    count=$[count+1];
    # echo ${time} ${total} ${count}
  fi
done

echo $(echo "scale=3;${total}/${count}" | bc);
}

GRAPH=rmat
echo "rmat      " `GetTimeByGraph`

GRAPH=rand
echo "rand      " `GetTimeByGraph`

GRAPH=wikitalk
echo "wikitalk  " `GetTimeByGraph`

GRAPH=roadnetca
echo "roadnetca " `GetTimeByGraph`
