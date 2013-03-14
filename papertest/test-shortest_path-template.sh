set -x

GRAPH=${GRAPH:-rmat}
NUMV=${NUMV:-1000000}
MAXE=${MAXE:-16000000}
DELTAE=${DELTAE:-${NUMV}}

RUNFLAGS="\
  --num_gpus=1 \
  --input_file= \
  --hash_type=mod \
  --rand_num_reading_threads=4 \
  \
  --output_file= \
  --writer_type=dummy \
  --max_superstep=999999999 \
  --num_threads_per_block=128 \
  --graph_type=${GRAPH} \
  --rand_num_vertex=${NUMV} \
"

for ((NUME=${NUMV}; NUME<=${MAXE}; NUME=NUME+${DELTAE}));
do
  ./out/shortest_path/origin/main                  ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1a-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/origin-share/main            ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1b-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/origin-rolling/main          ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1c-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/origin-share-rolling/main    ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1d-${GRAPH}-${NUMV}-${NUME}

  ./out/shortest_path/sorted/main                  ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1e-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/sorted-share/main            ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1f-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/sorted-rolling/main          ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1g-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/sorted-share-rolling/main    ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1h-${GRAPH}-${NUMV}-${NUME}

  ./out/shortest_path/coalesced/main               ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1i-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/coalesced-share/main         ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1j-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/coalesced-rolling/main       ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1k-${GRAPH}-${NUMV}-${NUME}
  ./out/shortest_path/coalesced-share-rolling/main ${RUNFLAGS} --rand_num_edge=${NUME} > papertest/papertest1l-${GRAPH}-${NUMV}-${NUME}
done
