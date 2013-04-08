// *****************************************************************************
// Filename:    gen_bip_graph.cc
// Date:        2013-03-07 14:01
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

struct Vertex {
  unsigned int half_edge_count;
};

struct Edge {
  unsigned int from;
  unsigned int to;
};

int main(int argc, char **argv) {
  if (argc != 2) {
    cout << "invalid parameters!" << endl;
    exit(1);
  }

  const unsigned int kNumVertex = 4000000;
  const unsigned int kNumEdge = 16000000;
  const unsigned int kNumHalfV = (kNumVertex >> 1);
  const unsigned int kNumHalfE = (kNumEdge >> 1);
  srand(42971431);
  vector<Vertex> vv(kNumVertex);
  vector<Edge> ev(kNumHalfE);

  for (unsigned int i = 0; i < kNumHalfE; ++i) {
    ev[i].from = rand() % kNumHalfV;
    ev[i].to = rand() % kNumHalfV + kNumHalfV;

    ++vv[ev[i].from].half_edge_count;
    ++vv[ev[i].to].half_edge_count;
  }

  ofstream out(argv[1]);

  // global
  out << kNumVertex << endl;
  out << kNumEdge << endl;

  // vertexes
  out << kNumVertex << endl;
  for (unsigned int i = 0; i < kNumVertex; ++i) {
    out << i << " "
        << vv[i].half_edge_count << " "
        << vv[i].half_edge_count << " "
        << (i < kNumHalfV ? 1 : 0) << endl;
  }

  // edges
  out << kNumEdge << endl;
  for (unsigned int i = 0; i < kNumHalfE; ++i) {
    out << ev[i].from << " " << ev[i].to << endl;
    out << ev[i].to << " " << ev[i].from << endl;
  }
  return 0;
}
