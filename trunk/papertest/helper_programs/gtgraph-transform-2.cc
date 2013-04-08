// *****************************************************************************
// Filename:    transform.cc
// Date:        2013-03-06 09:54
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

struct Edge {
  unsigned int from;
  unsigned int to;
  unsigned int weight;
};

struct Vertex {
  unsigned int in_edge_count;
  unsigned int out_edge_count;
};

static const unsigned int kNumVertex = 1000000;

int main(int argc, char **argv) {
  if (argc < 3) cout << "invalid parameters" << endl;

  ifstream in(argv[1]);
  ofstream out(argv[2]);

  vector<Edge> ev;

  vector<Vertex> vv(kNumVertex);
  for (Edge e; in >> e.from >> e.to >> e.weight; ) {
    ev.push_back(e);
    ++vv[e.from].out_edge_count;
    ++vv[e.to].in_edge_count;
  }
  cout << "Number of vertexes: " << kNumVertex << endl;
  cout << "Number of edges: " << ev.size() << endl;

  out << kNumVertex << endl;
  out << ev.size() << endl;
  out << 0 << endl;  // source

  out << kNumVertex << endl;  // num_vertex_for_current_shard
  for (unsigned int i = 0; i < vv.size(); ++i) {
    out << i << " " << vv[i].in_edge_count << " " << vv[i].out_edge_count << endl;
  }

  out << ev.size() << endl;  // num_edge_for_current_shard
  for (unsigned int i = 0; i < ev.size(); ++i) {
    out << ev[i].from << " " << ev[i].to << " " << ev[i].weight << endl;
  }
  return 0;
}
