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
};

struct Vertex {
  unsigned int in_edge_count;
  unsigned int out_edge_count;
};

int main(int argc, char **argv) {
  if (argc < 3) cout << "invalid parameters" << endl;

  ifstream in(argv[1]);
  ofstream out(argv[2]);

  map<unsigned int, unsigned int> idmap;
  vector<Edge> ev;

  for (Edge e; in >> e.from >> e.to; ) {
    ev.push_back(e);
    if (idmap.find(e.from) == idmap.end()) {
      unsigned int sz = idmap.size();
      idmap[e.from] = sz;
    }
    if (idmap.find(e.to) == idmap.end()) {
      unsigned int sz = idmap.size();
      idmap[e.to] = sz;
    }
  }
  cout << "Number of vertexes: " << idmap.size() << endl;
  cout << "Number of edges: " << ev.size() << endl;

#ifdef DEBUG
  cout << "idmap.size() = " << idmap.size() << endl;
#endif

  vector<Vertex> vv(idmap.size());
  for (unsigned int i = 0; i < ev.size(); ++i) {
    Edge &e = ev[i];
    e.from = idmap[e.from];
    e.to = idmap[e.to];
    ++vv[e.from].out_edge_count;
    ++vv[e.to].in_edge_count;
  }

#ifdef DEBUG
  cout << "idmap.size() = " << idmap.size() << endl;
#endif

  out << idmap.size() << endl;
  out << ev.size() << endl;
  out << idmap[0] << endl;  // source

#ifdef DEBUG
  for (map<unsigned int, unsigned int>::iterator it = idmap.begin();
       it != idmap.end(); ++it) {
    cout << it->first << "-->" << it->second << endl;
  }
#endif

  out << idmap.size() << endl;  // num_vertex_for_current_shard
  for (unsigned int i = 0; i < vv.size(); ++i) {
    out << i << " " << vv[i].in_edge_count << " " << vv[i].out_edge_count << endl;
  }

  out << ev.size() << endl;  // num_edge_for_current_shard
  for (unsigned int i = 0; i < ev.size(); ++i) {
    out << ev[i].from << " " << ev[i].to << " " << 1 << endl;  // weight is 1
  }
  return 0;
}
