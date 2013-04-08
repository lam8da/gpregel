set -x

GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
MAXE=${MAXE:-16000000}
DELTAE=${DELTAE:-1000000}
STEP=${STEP:-30}

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

OUTPUT_DIR=papertest/testout-6-pg_origin-rolling_vs_coalesced-rolling-full
mkdir ${OUTPUT_DIR}

# If 'full' is defined, whether 'share' or not makes no sence because there is only one array in message content.
#
# If 'rolling' is defined, theoratically speaking, whether 'share' or not makes little difference, so we eliminate one of them.

for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE}));
do
  ./out/page_rank/origin-rolling/main         ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/origin-rolling-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-rolling-full/main    ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/origin-rolling-full-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-rolling-full/main ${RUNFLAGS} --rand_num_edge=${NUME} > ${OUTPUT_DIR}/coalesced-rolling-full-${GRAPH}-${NUMV}-${NUME}-${STEP}
done
