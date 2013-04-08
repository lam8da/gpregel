function Random() {
  num=$(date +%s%N);
  echo $[num % $1];
}

# Needed arguments:
# 1. RMAT_VID
# 2. RAND_VID
# 3. WIKITALK_VID
# 4. ROADNETCA_VID
# 5. Run_SSSP_BFS
function Run_SSSP_BFS_OnAllGraph() {
  GRAPH_SUFFIX=rmat
  VID=(${RMAT_VID[@]:0})
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=rand
  VID=(${RAND_VID[@]:0})
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=wikitalk
  VID=(${WIKITALK_VID[@]:0})
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=roadnetca
  VID=(${ROADNETCA_VID[@]:0})
  Run_SSSP_BFS
}

# Needed arguments:
# 1. FILES
# 2. LINE
function GetAverageTimeByLine() {
  count=0;
  total=0;
  
  for i in ${FILES}; do
    time=$(sed -n ${LINE} $i | sed 's/^.*://;s/ms *//');
    if [ -n "${time}" ]; then
      total=$(echo "${total}+${time}" | bc);
      count=$[count+1];
    fi
  done
  
  echo $(echo "scale=3;${total}/${count}" | bc);
}

