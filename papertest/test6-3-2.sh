set -x

source ./papertest/vid_with_most_out_edge.sh

BLOCK_SIZE=128

RUNFLAGS="\
  --graph_type=file \
  --hash_type=mod \
  --num_gpus=1 \
  --output_file= \
  --rand_num_reading_threads=4 \
  --rand_num_vertex=0 \
  --rand_num_edge=0 \
  --writer_type=dummy \
  --num_threads_per_block=${BLOCK_SIZE} \
"

TESTCASE_DIR=papertest/test_cases
OUTPUT_DIR=papertest/testout-6-3-2
mkdir ${OUTPUT_DIR}

function Run_SSSP_BFS() {
  SHORT_INPUT_FILE_NAME=${GRAPH_SUFFIX}-${ALGORITHM}.graph
  ORIGIN=${TESTCASE_DIR}/${SHORT_INPUT_FILE_NAME}
  INPUT=${OUTPUT_DIR}/${SHORT_INPUT_FILE_NAME}
  
  for ((i=0; i<2; i=i+1)); do
    head -n 2 ${ORIGIN} > ${INPUT}
    echo ${VID[${i}]} >> ${INPUT}  # source
    sed -n '4,$p' ${ORIGIN} >> ${INPUT}

    for ((j=0; j<5; j=j+1)); do
      ./out/${ALGORITHM}/origin-rolling/main ${RUNFLAGS} \
        --max_superstep=999999999 \
        --input_file=${INPUT} \
        > ${OUTPUT_DIR}/${ALGORITHM}-origin-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}-${j}

      ./out/${ALGORITHM}/sorted-rolling/main ${RUNFLAGS} \
        --max_superstep=999999999 \
        --input_file=${INPUT} \
        > ${OUTPUT_DIR}/${ALGORITHM}-sorted-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}-${j}
    done
  done
}

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

function RunPageRank() {
  for GRAPH_SUFFIX in rmat rand wikitalk roadnetca; do
    INPUT=${TESTCASE_DIR}/${GRAPH_SUFFIX}-page_rank.graph

    for ((i=0; i<5; i=i+1)); do
      ./out/page_rank/origin-rolling/main ${RUNFLAGS} \
        --max_superstep=30 \
        --input_file=${INPUT} \
        > ${OUTPUT_DIR}/page_rank-origin-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}

      ./out/page_rank/sorted-rolling/main ${RUNFLAGS} \
        --max_superstep=30 \
        --input_file=${INPUT} \
        > ${OUTPUT_DIR}/page_rank-sorted-${GRAPH_SUFFIX}-${BLOCK_SIZE}-${i}
    done
  done
}

function RunBip() {
  INPUT=${TESTCASE_DIR}/bip.graph

  for ((i=0; i<5; i=i+1)); do
    ./out/bipartite_matching/origin-rolling/main ${RUNFLAGS} \
      --max_superstep=999999999 \
      --input_file=${INPUT} \
      > ${OUTPUT_DIR}/bipartite_matching-origin-${BLOCK_SIZE}-${i}

    ./out/bipartite_matching/sorted-rolling/main ${RUNFLAGS} \
      --max_superstep=999999999 \
      --input_file=${INPUT} \
      > ${OUTPUT_DIR}/bipartite_matching-sorted-${BLOCK_SIZE}-${i}
  done
}

ALGORITHM=shortest_path
Run_SSSP_BFS_OnAllGraph

ALGORITHM=breadth_first_search
Run_SSSP_BFS_OnAllGraph

RunPageRank

RunBip
