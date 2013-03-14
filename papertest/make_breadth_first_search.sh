set -x

rm -rf ./out/breadth_first_search/origin*
rm -rf ./out/breadth_first_search/sorted*
rm -rf ./out/breadth_first_search/coalesced*

./papertest/inc_make_breadth_first_search.sh
