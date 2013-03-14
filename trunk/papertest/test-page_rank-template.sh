set -x

GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
MAXE=${MAXE:-16000000}
DELTAE=${DELTAE:-${NUMV}}
STEP=${STEP:-1000}

RUNFLAGS="\
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

for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE}));
do
  ./out/page_rank/origin/main                       ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2a-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-share/main                 ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2b-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-rolling/main               ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2c-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-full/main                  ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2d-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-share-rolling/main         ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2e-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-share-full/main            ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2f-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-rolling-full/main          ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2g-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/origin-share-rolling-full/main    ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2h-${GRAPH}-${NUMV}-${NUME}-${STEP}

  ./out/page_rank/sorted/main                       ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2i-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-share/main                 ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2j-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-rolling/main               ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2k-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-full/main                  ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2l-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-share-rolling/main         ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2m-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-share-full/main            ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2n-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-rolling-full/main          ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2o-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/sorted-share-rolling-full/main    ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2p-${GRAPH}-${NUMV}-${NUME}-${STEP}

  ./out/page_rank/coalesced/main                    ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2q-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-share/main              ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2r-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-rolling/main            ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2s-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-full/main               ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2t-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-share-rolling/main      ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2u-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-share-full/main         ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2v-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-rolling-full/main       ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2w-${GRAPH}-${NUMV}-${NUME}-${STEP}
  ./out/page_rank/coalesced-share-rolling-full/main ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest2x-${GRAPH}-${NUMV}-${NUME}-${STEP}
done
