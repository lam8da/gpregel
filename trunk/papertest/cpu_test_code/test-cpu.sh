# set -x

source ./papertest/vid_with_most_out_edge.sh
source ./papertest/make_helper_code.sh
source ./papertest/helper_script.sh
set +x

TESTCASE_DIR=papertest/test_cases

function Run_SSSP_BFS() {
  echo ------ ${GRAPH_SUFFIX} ------
  SHORT_INPUT_FILE_NAME=${GRAPH_SUFFIX}-raw.graph
  ORIGIN=${TESTCASE_DIR}/${SHORT_INPUT_FILE_NAME}
  
  for ((i=0; i<2; i=i+1)); do
    for ((j=0; j<3; j=j+1)); do
      ${GRAPH_GEN} ${ORIGIN} ${ALGORITHM} ${VID[${i}]} | ${HELPER_OUT_DIR}/bfs_cpu.out
    done
  done
}

function RunPageRank() {
  for GRAPH_SUFFIX in rmat rand wikitalk roadnetca; do
    ORIGIN=${TESTCASE_DIR}/${GRAPH_SUFFIX}-raw.graph
    echo ------ ${GRAPH_SUFFIX} ------

    for ((i=0; i<3; i=i+1)); do
      ${GRAPH_GEN} ${ORIGIN} ${ALGORITHM} | ${HELPER_OUT_DIR}/pg_cpu.out
    done
  done
}

# ------------------------------------ build executive files ------------------------------------
SRC_DIR=papertest/cpu_test_code
NVCC='/usr/local/cuda-5.0/bin/nvcc -m64 -O3 -gencode arch=compute_20,code=sm_20 -I/usr/local/cuda-5.0/include -I/usr/local/cuda-5.0/samples/common/inc'

# ALGORITHM=sssp
# Run_SSSP_BFS_OnAllGraph

echo ------------------------------------- bfs --------------------------------------

${NVCC} -c ${SRC_DIR}/bfs.cc -o ${HELPER_OUT_DIR}/bfs.o
${NVCC} -c ${SRC_DIR}/bfs_cpu.cc -o ${HELPER_OUT_DIR}/bfs_cpu.o
${NVCC} -o ${HELPER_OUT_DIR}/bfs_cpu.out ${HELPER_OUT_DIR}/bfs.o ${HELPER_OUT_DIR}/bfs_cpu.o

ALGORITHM=bfs
Run_SSSP_BFS_OnAllGraph

echo ------------------------------------- pg --------------------------------------

${NVCC} ${SRC_DIR}/page_rank.cc -o ${HELPER_OUT_DIR}/pg_cpu.out

ALGORITHM=pg
RunPageRank
