set -x

source ./papertest/abbreviation.sh

# BUILD_MARK=origin                  LAMBDA_DEBUG_FLAGS=${pf},${st}                         USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=origin-share            LAMBDA_DEBUG_FLAGS=${pf},${st},${sh}                   USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=origin-rolling          LAMBDA_DEBUG_FLAGS=${pf},${st},${ro}                   USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=origin-share-rolling    LAMBDA_DEBUG_FLAGS=${pf},${st},${sh},${ro}             USER_PATH=bipartite_matching USER_FILE= make build

# BUILD_MARK=sorted                  LAMBDA_DEBUG_FLAGS=${pf},${st},${so}                   USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=sorted-share            LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${sh}             USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=sorted-rolling          LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${ro}             USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=sorted-share-rolling    LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${sh},${ro}       USER_PATH=bipartite_matching USER_FILE= make build

# BUILD_MARK=coalesced               LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co}             USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=coalesced-share         LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${sh}       USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=coalesced-rolling       LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${ro}       USER_PATH=bipartite_matching USER_FILE= make build
# BUILD_MARK=coalesced-share-rolling LAMBDA_DEBUG_FLAGS=${pf},${st},${so},${co},${sh},${ro} USER_PATH=bipartite_matching USER_FILE= make build
