set -x

HELPER_SRC_DIR='papertest/helper_programs'
HELPER_OUT_DIR='./out/helper'
mkdir -p ${HELPER_OUT_DIR}

GRAPH_GEN=${HELPER_OUT_DIR}/graph_gen.out
g++ ${HELPER_SRC_DIR}/graph_gen.cc -o ${GRAPH_GEN}

SPRNG_INCLUDES='-I./inc/sprng2.0-lite/include'
SPRNG_LIBRARIES='-L./inc/sprng2.0-lite/lib -lsprng -lm'
g++ ${HELPER_SRC_DIR}/rmat.cc ${SPRNG_INCLUDES} ${SPRNG_LIBRARIES} -o ${HELPER_OUT_DIR}/rmat.out
g++ ${HELPER_SRC_DIR}/rand.cc ${SPRNG_INCLUDES} ${SPRNG_LIBRARIES} -o ${HELPER_OUT_DIR}/rand.out
