set -x

rm -rf ./out/shortest_path/origin*
rm -rf ./out/shortest_path/sorted*
rm -rf ./out/shortest_path/coalesced*

./papertest/inc_make_shortest_path.sh
