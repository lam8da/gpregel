set -x

source ./papertest/vid_with_most_out_edge.sh
source ./papertest/make_helper_code.sh
source ./papertest/helper_script.sh

RUNFLAGS="\
  --hash_type=mod \
  --num_gpus=1 \
  \
  --output_file= \
  --rand_num_edge=0 \
  --rand_num_reading_threads=4 \
  --rand_num_vertex=0 \
  --single_gpu_id=1 \
  --writer_type=dummy \
"

TESTCASE_DIR=papertest/test_cases
OUTPUT_DIR=papertest/testout-6-3-1
mkdir -p ${OUTPUT_DIR}

function Run_SSSP_BFS() {
  ORIGIN=${TESTCASE_DIR}/${GRAPH_SUFFIX}-raw.graph
  
  for ((BLOCK_SIZE=128; BLOCK_SIZE<=1024; BLOCK_SIZE+=128)); do
    for ((i=0; i<2; i=i+1)); do
      for ((j=0; j<5; j=j+1)); do
        ${GRAPH_GEN} ${ORIGIN} ${ALGORITHM} ${VID[${i}]} | \
        ./out/${ALGORITHM}/origin-rolling/main ${RUNFLAGS} \
          --graph_type=console \
          --input_file= \
          --max_superstep=999999999 \
          --num_threads_per_block=${BLOCK_SIZE} \
          > ${OUTPUT_DIR}/${ALGORITHM}-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}-${j}
      done
    done
  done
}

function RunPageRank() {
  for GRAPH_SUFFIX in rmat rand wikitalk roadnetca; do
    ORIGIN=${TESTCASE_DIR}/${GRAPH_SUFFIX}-raw.graph

    for ((BLOCK_SIZE=128; BLOCK_SIZE<=1024; BLOCK_SIZE+=128)); do
      for ((i=0; i<5; i=i+1)); do
        ${GRAPH_GEN} ${ORIGIN} ${ALGORITHM} | \
        ./out/${ALGORITHM}/origin-rolling/main ${RUNFLAGS} \
          --graph_type=console \
          --input_file= \
          --max_superstep=30 \
          --num_threads_per_block=${BLOCK_SIZE} \
          > ${OUTPUT_DIR}/${ALGORITHM}-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}
      done
    done
  done
}

function RunBip() {
  GRAPH_SUFFIX=bip
  ORIGIN=${TESTCASE_DIR}/bip.graph

  for ((BLOCK_SIZE=128; BLOCK_SIZE<=1024; BLOCK_SIZE+=128)); do
    for ((i=0; i<5; i=i+1)); do
      ./out/${ALGORITHM}/origin-rolling/main ${RUNFLAGS} \
        --graph_type=file \
        --input_file=${ORIGIN} \
        --max_superstep=999999999 \
        --num_threads_per_block=${BLOCK_SIZE} \
        > ${OUTPUT_DIR}/${ALGORITHM}-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}
    done
  done
}

ALGORITHM=shortest_path
Run_SSSP_BFS_OnAllGraph

ALGORITHM=breadth_first_search
Run_SSSP_BFS_OnAllGraph

ALGORITHM=page_rank
RunPageRank

ALGORITHM=bipartite_matching
RunBip
