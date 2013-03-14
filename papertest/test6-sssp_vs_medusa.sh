set -x

source ./papertest/vid_with_most_out_edge.sh

function Random() {
  num=$(date +%s%N);
  echo $[num % $1];
}

RUNFLAGS="\
  --graph_type=file \
  --hash_type=mod \
  --max_superstep=999999999 \
  --num_gpus=1 \
  --num_threads_per_block=128 \
  --output_file= \
  --rand_num_reading_threads=4 \
  --rand_num_vertex=0 \
  --rand_num_edge=0 \
  --writer_type=dummy \
"

OUTPUT_DIR=papertest/testout-6-sssp_vs_medusa
mkdir ${OUTPUT_DIR}

function RunGraph() {
  SHORT_INPUT_FILE_NAME=${SUFFIX}-shortest_path.graph
  ORIGIN=papertest/test_cases/${SHORT_INPUT_FILE_NAME}
  INPUT=${OUTPUT_DIR}/${SHORT_INPUT_FILE_NAME}
  
  for ((i=0; i<10; i=i+1)); do
    head -n 2 ${ORIGIN} > ${INPUT}
    echo ${VID[${i}]} >> ${INPUT}
    sed -n '4,$p' ${ORIGIN} >> ${INPUT}
  
    for ((j=0; j<10; j=j+1)); do
      ./out/shortest_path/origin-rolling/main ${RUNFLAGS} --input_file=${INPUT} > ${OUTPUT_DIR}/${SUFFIX}-${i}-${j}
    done
  done
}

SUFFIX=rmat
VID=(${RMAT_VID[@]:0})
RunGraph

SUFFIX=rand
VID=(${RAND_VID[@]:0})
RunGraph

SUFFIX=wikitalk
VID=(${WIKITALK_VID[@]:0})
RunGraph

SUFFIX=roadnetca
VID=(${ROADNETCA_VID[@]:0})
RunGraph
