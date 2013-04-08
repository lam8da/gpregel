set -x

source ./papertest/make_helper_code.sh

OUTPUT_DIR=papertest/find_source_root_out
TESTCASE_DIR=papertest/test_cases
INC_DIR=papertest/cpu_test_code

mkdir -p ${OUTPUT_DIR}

function Run_SSSP_BFS_OnAllGraph() {
  GRAPH_SUFFIX=rmat
  LEVEL_THRESHOLD=7
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=rand
  LEVEL_THRESHOLD=7
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=wikitalk
  LEVEL_THRESHOLD=10
  Run_SSSP_BFS
  
  GRAPH_SUFFIX=roadnetca
  LEVEL_THRESHOLD=116
  Run_SSSP_BFS
}

NVCC='/usr/local/cuda-5.0/bin/nvcc -m64 -O3 -gencode arch=compute_20,code=sm_20 -I/usr/local/cuda-5.0/include -I/usr/local/cuda-5.0/samples/common/inc'

# ALGORITHM=sssp
# Run_SSSP_BFS_OnAllGraph

echo ------------------------------------- bfs --------------------------------------

${NVCC} -c ${INC_DIR}/bfs.cc -o ${HELPER_OUT_DIR}/bfs.o
${NVCC} -I papertest/cpu_test_code -c ${HELPER_SRC_DIR}/find_bfs_max_level.cc -o ${HELPER_OUT_DIR}/find_bfs_max_level.o
${NVCC} -o ${HELPER_OUT_DIR}/find_bfs_max_level.out ${HELPER_OUT_DIR}/bfs.o ${HELPER_OUT_DIR}/find_bfs_max_level.o

function Run_SSSP_BFS() {
  echo ------ ${GRAPH_SUFFIX} ------
  ORIGIN=${TESTCASE_DIR}/${GRAPH_SUFFIX}-raw.graph
  ${GRAPH_GEN} ${ORIGIN} ${ALGORITHM} 0 | ${HELPER_OUT_DIR}/find_bfs_max_level.out ${OUTPUT_DIR}/bfs-${GRAPH_SUFFIX} ${LEVEL_THRESHOLD}
}

ALGORITHM=bfs
Run_SSSP_BFS_OnAllGraph
