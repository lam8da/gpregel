// *****************************************************************************
// Filename:    find_bfs_max_level.cc
// Date:        2013-03-25 19:40
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

#include "bfs.h"

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

// argv[1]: output file
// argv[2]: level threshold
int main(int argc, char **argv) {
  srand(time(0));
  ofstream out(argv[1]);
  unsigned int thres = atoi(argv[2]);

  HostGraphGlobal global;
  vector<HostGraphVertex> vertex_vec;
  vector<HostGraphEdge> edge_vec;

  Read(global, vertex_vec, edge_vec);

  std::sort(vertex_vec.begin(), vertex_vec.end());
  std::sort(edge_vec.begin(), edge_vec.end());

  for (unsigned int i = 0; i < 999; ++i) {
    global.root = rand() % global.num_vertex;
    unsigned int max_level = CpuAlgorithm(
        999999999, global, vertex_vec, edge_vec);
    if (max_level >= thres) {
      out << "root: " << global.root << ", max_level: " << max_level << endl;
    }
  }
  out.close();

  return 0;
}
