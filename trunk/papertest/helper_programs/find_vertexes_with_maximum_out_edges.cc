// *****************************************************************************
// Filename:    find_vertexes_with_maximum_out_edges.cc
// Date:        2013-03-06 17:43
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

using std::cerr;
using std::cin;
using std::cout;
using std::endl;
using std::ifstream;
using std::map;
using std::ofstream;
using std::set;
using std::string;
using std::vector;

struct V {
  unsigned int id, eout;

  bool operator<(const V &other) const {
    return eout > other.eout;
  }
};

int main(int argc, char **argv) {
  if (argc != 2) {
    cout << "invalid parameters!" << endl;
    return 0;
  }
  ifstream in(argv[1]);

  unsigned int n, m, tmp;
  in >> n >> m >> tmp;
  in >> tmp;  // n in current shard

  vector<V> vv;
  for (int i = 0; i < n; ++i) {
    V v;
    in >> v.id >> tmp >> v.eout;
    vv.push_back(v);
  }
  std::sort(vv.begin(), vv.end());
  for (int i = 0; i < 100; ++i) {
    // cout << vv[i].id << "               " << vv[i].eout << endl;
    cout << vv[i].id << " ";
  }
  cout << endl;
}
