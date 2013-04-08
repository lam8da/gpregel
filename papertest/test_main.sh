set -x

echo '' > test_main_result
echo "-------------------------- shortest_path, origin-rolling --------------------------" >> test_main_result

./out/shortest_path/origin-rolling/test_main \
  --graph_type=rmat \
  --rand_num_vertex=500 \
  --rand_num_edge=5000 \
  >> test_main_result 2>&1

./out/shortest_path/origin-rolling/test_main \
  --graph_type=rand \
  --rand_num_vertex=500 \
  --rand_num_edge=5000 \
  >> test_main_result 2>&1

echo '' >> test_main_result
echo "-------------------------- breadth_first_search, origin-rolling --------------------------" >> test_main_result

./out/breadth_first_search/origin-rolling/test_main \
  --graph_type=rmat \
  --rand_num_vertex=500 \
  --rand_num_edge=5000 \
  >> test_main_result 2>&1

./out/breadth_first_search/origin-rolling/test_main \
  --graph_type=rand \
  --rand_num_vertex=500 \
  --rand_num_edge=5000 \
  >> test_main_result 2>&1

# echo '' >> test_main_result
# echo "-------------------------- page_rank, origin-rolling --------------------------" >> test_main_result
# ./out/page_rank/origin-rolling/test_main            >> test_main_result 2>&1
# 
# echo '' >> test_main_result
# echo "-------------------------- page_rank, coalesced-rolling-full --------------------------" >> test_main_result
# ./out/page_rank/coalesced-rolling-full/test_main    >> test_main_result 2>&1
