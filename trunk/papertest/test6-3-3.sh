set -x

GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
MAXE=${MAXE:-16000000}
DELTAE=${DELTAE:-${NUMV}}
STEP=${STEP:-1000}

RUNFLAGS="\
  --single_gpu_id=1 \
  --num_gpus=1 \
  --input_file= \
  --hash_type=mod \
  --rand_num_reading_threads=4 \
  \
  --output_file= \
  --writer_type=dummy \
  --max_superstep=${STEP} \
  --num_threads_per_block=128 \
  --graph_type=${GRAPH} \
  --rand_num_vertex=${NUMV} \
"

OUTPUT_DIR=papertest/testout-6-3-3
mkdir ${OUTPUT_DIR}

# If 'full' is defined, whether 'share' or not makes no sence because there is only one array in message content.
#
# If 'rolling' is defined, theoratically speaking, whether 'share' or not makes little difference, so we eliminate one of them.

for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE}));
do
  ./out/page_rank/origin/main         ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/origin-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-share/main   ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/share-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-rolling/main ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/rolling-${GRAPH}-${NUMV}-${NUME}-${STEP}
done
