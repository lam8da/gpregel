set -x

source papertest/abbreviation.sh

# -------------------------- shortest path ---------------------------
BUILD_MARK=test-origin                       LAMBDA_DEBUG_FLAGS=${db}                               USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-origin-share                 LAMBDA_DEBUG_FLAGS=${db},${sh}                         USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-origin-rolling               LAMBDA_DEBUG_FLAGS=${db},${ro}                         USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-origin-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${sh},${ro}                   USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build

BUILD_MARK=test-sorted                       LAMBDA_DEBUG_FLAGS=${db},${so}                         USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-sorted-share                 LAMBDA_DEBUG_FLAGS=${db},${so},${sh}                   USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-sorted-rolling               LAMBDA_DEBUG_FLAGS=${db},${so},${ro}                   USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-sorted-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${ro}             USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build

BUILD_MARK=test-coalesced                    LAMBDA_DEBUG_FLAGS=${db},${so},${co}                   USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-coalesced-share              LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh}             USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-coalesced-rolling            LAMBDA_DEBUG_FLAGS=${db},${so},${co},${ro}             USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build
BUILD_MARK=test-coalesced-share-rolling      LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${ro}       USER_PATH=shortest_path USER_FILE=./shortest_path/adjustable_heap.h make build

# -------------------------- page rank ---------------------------
BUILD_MARK=test-origin                       LAMBDA_DEBUG_FLAGS=${db}                               USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-share                 LAMBDA_DEBUG_FLAGS=${db},${sh}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-rolling               LAMBDA_DEBUG_FLAGS=${db},${ro}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-full                  LAMBDA_DEBUG_FLAGS=${db},${fu}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${sh},${ro}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-share-full            LAMBDA_DEBUG_FLAGS=${db},${sh},${fu}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-rolling-full          LAMBDA_DEBUG_FLAGS=${db},${ro},${fu}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-origin-share-rolling-full    LAMBDA_DEBUG_FLAGS=${db},${sh},${ro},${fu}             USER_PATH=page_rank USER_FILE= make build

BUILD_MARK=test-sorted                       LAMBDA_DEBUG_FLAGS=${db},${so}                         USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-share                 LAMBDA_DEBUG_FLAGS=${db},${so},${sh}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-rolling               LAMBDA_DEBUG_FLAGS=${db},${so},${ro}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-full                  LAMBDA_DEBUG_FLAGS=${db},${so},${fu}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${ro}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-share-full            LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${fu}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-rolling-full          LAMBDA_DEBUG_FLAGS=${db},${so},${ro},${fu}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-sorted-share-rolling-full    LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${ro},${fu}       USER_PATH=page_rank USER_FILE= make build

BUILD_MARK=test-coalesced                    LAMBDA_DEBUG_FLAGS=${db},${so},${co}                   USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-share              LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-rolling            LAMBDA_DEBUG_FLAGS=${db},${so},${co},${ro}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-full               LAMBDA_DEBUG_FLAGS=${db},${so},${co},${fu}             USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-share-rolling      LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${ro}       USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-share-full         LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${fu}       USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-rolling-full       LAMBDA_DEBUG_FLAGS=${db},${so},${co},${ro},${fu}       USER_PATH=page_rank USER_FILE= make build
BUILD_MARK=test-coalesced-share-rolling-full LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${ro},${fu} USER_PATH=page_rank USER_FILE= make build

# -------------------------- breadth first search ---------------------------
BUILD_MARK=test-origin                       LAMBDA_DEBUG_FLAGS=${db}                               USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-origin-share                 LAMBDA_DEBUG_FLAGS=${db},${sh}                         USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-origin-rolling               LAMBDA_DEBUG_FLAGS=${db},${ro}                         USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-origin-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${sh},${ro}                   USER_PATH=breadth_first_search USER_FILE= make build

BUILD_MARK=test-sorted                       LAMBDA_DEBUG_FLAGS=${db},${so}                         USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-sorted-share                 LAMBDA_DEBUG_FLAGS=${db},${so},${sh}                   USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-sorted-rolling               LAMBDA_DEBUG_FLAGS=${db},${so},${ro}                   USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-sorted-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${ro}             USER_PATH=breadth_first_search USER_FILE= make build

BUILD_MARK=test-coalesced                    LAMBDA_DEBUG_FLAGS=${db},${so},${co}                   USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-coalesced-share              LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh}             USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-coalesced-rolling            LAMBDA_DEBUG_FLAGS=${db},${so},${co},${ro}             USER_PATH=breadth_first_search USER_FILE= make build
BUILD_MARK=test-coalesced-share-rolling      LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${ro}       USER_PATH=breadth_first_search USER_FILE= make build

# -------------------------- bipartite matching ---------------------------
BUILD_MARK=test-origin                       LAMBDA_DEBUG_FLAGS=${db}                               USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-origin-share                 LAMBDA_DEBUG_FLAGS=${db},${sh}                         USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-origin-rolling               LAMBDA_DEBUG_FLAGS=${db},${ro}                         USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-origin-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${sh},${ro}                   USER_PATH=bipartite_matching USER_FILE= make build

BUILD_MARK=test-sorted                       LAMBDA_DEBUG_FLAGS=${db},${so}                         USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-sorted-share                 LAMBDA_DEBUG_FLAGS=${db},${so},${sh}                   USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-sorted-rolling               LAMBDA_DEBUG_FLAGS=${db},${so},${ro}                   USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-sorted-share-rolling         LAMBDA_DEBUG_FLAGS=${db},${so},${sh},${ro}             USER_PATH=bipartite_matching USER_FILE= make build

BUILD_MARK=test-coalesced                    LAMBDA_DEBUG_FLAGS=${db},${so},${co}                   USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-coalesced-share              LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh}             USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-coalesced-rolling            LAMBDA_DEBUG_FLAGS=${db},${so},${co},${ro}             USER_PATH=bipartite_matching USER_FILE= make build
BUILD_MARK=test-coalesced-share-rolling      LAMBDA_DEBUG_FLAGS=${db},${so},${co},${sh},${ro}       USER_PATH=bipartite_matching USER_FILE= make build

