set -x

rm -rf ./out/shortest_path/test-*
rm -rf ./out/page_rank/test-*
rm -rf ./out/breadth_first_search/test-*
rm -rf ./out/bipartite_matching/test-*

./papertest/inc_make_test.sh
