set -x

./papertest/make_test.sh

FLAGS="\
  --num_gpus=1 \
  --max_superstep=99 \
  --input_file= \
  --graph_type=rmat \
  --hash_type=mod \
  --output_file=gpregelout \
  --writer_type=console_test \
  --rand_num_reading_threads=4 \
  \
  --rand_num_vertex=51 --rand_num_edge=891
"

rm testout
i=0

# -------------------------- shortest path ---------------------------
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-origin/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-origin-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-origin-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-origin-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-sorted/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-sorted-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-sorted-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-sorted-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-coalesced/main                ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-coalesced-share/main          ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-coalesced-rolling/main        ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/shortest_path/test-coalesced-share-rolling/main  ${FLAGS} >> testout

# If 'full' is defined, whether 'share' or not makes no sence because there is only one array in message content.
# But since we are aiming at testing the correctness of macros, so we should test them anyway.
# -------------------------- page rank ---------------------------
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin/main                       ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-share/main                 ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-rolling/main               ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-full/main                  ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-share-rolling/main         ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-share-full/main            ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-rolling-full/main          ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-origin-share-rolling-full/main    ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted/main                       ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-share/main                 ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-rolling/main               ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-full/main                  ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-share-rolling/main         ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-share-full/main            ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-rolling-full/main          ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-sorted-share-rolling-full/main    ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced/main                    ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-share/main              ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-rolling/main            ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-full/main               ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-share-rolling/main      ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-share-full/main         ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-rolling-full/main       ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/page_rank/test-coalesced-share-rolling-full/main ${FLAGS} >> testout

# -------------------------- breadth first search ---------------------------
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-origin/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-origin-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-origin-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-origin-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-sorted/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-sorted-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-sorted-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-sorted-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-coalesced/main                ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-coalesced-share/main          ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-coalesced-rolling/main        ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/breadth_first_search/test-coalesced-share-rolling/main  ${FLAGS} >> testout

# -------------------------- bipartite matching ---------------------------
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-origin/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-origin-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-origin-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-origin-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-sorted/main                   ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-sorted-share/main             ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-sorted-rolling/main           ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-sorted-share-rolling/main     ${FLAGS} >> testout

echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-coalesced/main                ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-coalesced-share/main          ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-coalesced-rolling/main        ${FLAGS} >> testout
echo "Test NO." $[++i] >> testout && ./out/bipartite_matching/test-coalesced-share-rolling/main  ${FLAGS} >> testout

