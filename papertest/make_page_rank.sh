set -x

rm -rf ./out/page_rank/origin*
rm -rf ./out/page_rank/sorted*
rm -rf ./out/page_rank/coalesced*

./papertest/inc_make_page_rank.sh
