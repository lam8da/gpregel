set -x

rm -rf ./out/bipartite_matching/origin*
rm -rf ./out/bipartite_matching/sorted*
rm -rf ./out/bipartite_matching/coalesced*

./papertest/inc_make_bipartite_matching.sh
