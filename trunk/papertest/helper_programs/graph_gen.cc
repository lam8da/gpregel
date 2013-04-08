// *****************************************************************************
// Filename:    graph_gen.cc
// Date:        2013-03-25 15:44
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

enum Type {
  SSSP,
  BFS,
  PG
};

Type GetGraphType(const char *str) {
  switch (str[0]) {
    case 's': return SSSP;
    case 'b': return BFS;
    case 'p': return PG;
  }
  cout << "Invalid graph type!" << endl;
  exit(1);
}

void CPPCode(int argc, char **argv) {
  ifstream in(argv[1]);  // input
  Type t = GetGraphType(argv[2]);

  unsigned int numv, nume;
  in >> numv >> nume;
  cout << numv << " ";
  cout << nume << " ";

  if (t == SSSP || t == BFS) {
    cout << argv[3] << " ";  // source or root
  }

  cout << numv << " ";  // num_vertex_for_current_shard

  unsigned int id, in_edge_count, out_edge_count;
  for (unsigned int i = 0; i < numv; ++i) {
    in >> id >> in_edge_count >> out_edge_count;
    cout << id << " ";
    cout << in_edge_count << " ";
    cout << out_edge_count << " ";
  }

  cout << nume << " ";  // num_edge_for_current_shard

  unsigned int from, to;
  for (unsigned int i = 0; i < nume; ++i) {
    in >> from >> to;
    cout << from << " ";
    cout << to << " ";

    if (t == SSSP) cout << rand() % 131 << " ";  // weight
  }

  cout << endl;
}

void CCode(int argc, char **argv) {
  FILE *fin = fopen(argv[1], "r");  // input
  Type t = GetGraphType(argv[2]);

  unsigned int numv, nume;
  fscanf(fin, "%d%d", &numv, &nume);
  printf("%d %d ", numv, nume);

  if (t == SSSP || t == BFS) {
    printf("%s ", argv[3]);  // source or root
  }

  printf("%d ", numv);  // num_vertex_for_current_shard
  unsigned int id, in_edge_count, out_edge_count;
  for (unsigned int i = 0; i < numv; ++i) {
    fscanf(fin, "%d%d%d", &id, &in_edge_count, &out_edge_count);
    printf("%d %d %d ", id, in_edge_count, out_edge_count);
  }

  printf("%d ", nume);  // num_edge_for_current_shard
  unsigned int from, to;
  for (unsigned int i = 0; i < nume; ++i) {
    fscanf(fin, "%d%d", &from, &to);
    printf("%d %d ", from, to);
    if (t == SSSP) printf("%d ", rand() % 131);  // weight
  }
  printf("\n");
}

// argv[1] is the graph data file.
// argv[2] is the algorithm (sssp, bfs, pg).
// argv[3] is the source or root of sssp or bfs, correspondingly.
int main(int argc, char** argv) {
  srand(42141091);
  CCode(argc, argv);
  // CPPCode(argc, argv);
  return 0;
}
