// *****************************************************************************
// Filename:    graph_statistics.cc
// Date:        2013-03-30 15:34
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

struct Graph {
  unsigned int n, m;
  vector<unsigned int> in_edge_count, out_edge_count;
  Graph(const unsigned int nn, const unsigned int mm)
      : n(nn), m(mm), in_edge_count(n, 0), out_edge_count(m, 0) {
  }
};

void OutputStatistics(const Graph *g) {
  map<unsigned int, int> hist_in, hist_out;
  for (unsigned int i = 0; i < g->n; ++i) {
    ++hist_in[g->in_edge_count[i]];
    ++hist_out[g->out_edge_count[i]];
  }
  double expectation = g->m / (double)g->n;

  cout << "In edge distribution "
       << "(number of in-edges X : number of vertexes Y who has X in-edges):"
       << endl;
  double var_in = 0;
  for (map<unsigned int, int>::iterator it = hist_in.begin();
       it != hist_in.end(); ++it) {
    double diff = it->first - expectation;
    var_in += diff * diff * it->second;
    cout << it->first << ":" << it->second << ", ";
  }
  cout << endl;
  cout << "Max number of in-edge: " << hist_in.rbegin()->first << endl;
  cout << "Standard deviation: " << std::sqrt(var_in / g->n) << endl;

  cout << "Out edge distribution "
       << "(number of out-edges X : number of vertexes Y who has X out-edges):"
       << endl;
  double var_out = 0;
  for (map<unsigned int, int>::iterator it = hist_out.begin();
       it != hist_out.end(); ++it) {
    double diff = it->first - expectation;
    var_out += diff * diff * it->second;
    cout << it->first << ":" << it->second << ", ";
  }
  cout << endl;
  cout << "Max number of out-edge: " << hist_out.rbegin()->first << endl;
  cout << "Standard deviation: " << std::sqrt(var_out / g->n) << endl;

  // for matlab
  typedef map<unsigned int, int>::iterator Itr;
  cout << endl << "----------------- Matlab code -----------------" << endl;

  cout << "in_num_of_edges = ["; for (Itr it = hist_in.begin(); it != hist_in.end(); ++it) cout << it->first << " "; cout << "];" << endl;
  cout << "in_vertex_count = ["; for (Itr it = hist_in.begin(); it != hist_in.end(); ++it) cout << it->second << " "; cout << "];" << endl;

  cout << "out_num_of_edges = ["; for (Itr it = hist_out.begin(); it != hist_out.end(); ++it) cout << it->first << " "; cout << "];" << endl;
  cout << "out_vertex_count = ["; for (Itr it = hist_out.begin(); it != hist_out.end(); ++it) cout << it->second << " "; cout << "];" << endl;
}

int main(int argc, char **argv) {
  FILE *fin = fopen(argv[1], "r");  // input

  unsigned int n, m;
  fscanf(fin, "%d%d", &n, &m);
  Graph g(n, m);

  for (unsigned int i = 0; i < n; ++i) {
    unsigned int id, in, out;
    fscanf(fin, "%d%d%d", &id, &in, &out);
    g.in_edge_count[id] = in;
    g.out_edge_count[id] = out;
  }
  OutputStatistics(&g);

  return 0;
}
