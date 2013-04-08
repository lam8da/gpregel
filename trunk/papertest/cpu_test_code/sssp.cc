// *****************************************************************************
// Filename:    cpu_algorithm.cc
// Date:        2013-01-01 17:35
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include "sssp.h"

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

#include "adjustable_heap.h"

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

struct DijkNode {
  unsigned int v;
  unsigned int pre;
  unsigned int c;

  // Add data member @heap_position.
  ADD_ADJUSTABLE_HEAP_MEMBER();

  DijkNode() : v(~0U), pre(~0U), c(~0U), heap_position(kInvalidPos) {
  }

  bool operator<(const DijkNode &other) const {
    return c < other.c;
  }
};

unsigned int CpuAlgorithm(
    const unsigned int max_super_step,
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  vector<DijkNode> heap_data(global.num_vertex);
  heap_data[global.source].c = 0;
  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    heap_data[i].v = i;
  }
  AdjustableHeap<DijkNode> heap(heap_data.begin(), heap_data.end());

  while (heap.Size() > 0) {
    const DijkNode &top = *(heap.Pop());
    if (top.c == ~0U) break;

    const unsigned int begin =
        (top.v == 0 ? 0 : vertex_vec[top.v - 1].sum_out_edge_count);
    const unsigned int end = vertex_vec[top.v].sum_out_edge_count;
    for (unsigned int j = begin; j < end; ++j) {
      unsigned int jt = edge_vec[j].to, jc = edge_vec[j].weight;
      if (heap_data[jt].c > top.c + jc) {
        heap_data[jt].c = top.c + jc;
        heap_data[jt].pre = top.v;
        heap.UpHeap(heap_data[jt].heap_position);
      }
    }
  }

  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    vertex_vec[i].dist = heap_data[i].c;
    vertex_vec[i].pre = heap_data[i].pre;
  }
  return 0;  // nothing to return
}

void Read(
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  cin >> global.num_vertex >> global.num_edge >> global.source;
  vertex_vec.resize(global.num_vertex);
  edge_vec.resize(global.num_edge);

  unsigned int dummy;
  cin >> dummy;  // num vertex for current shard

  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    cin >> vertex_vec[i].id;
    cin >> dummy;  // in_edge_count
    cin >> vertex_vec[i].sum_out_edge_count;
    if (i > 0) {
      vertex_vec[i].sum_out_edge_count += vertex_vec[i-1].sum_out_edge_count;
    }

    // init user defined members
    vertex_vec[i].dist = ~0u;
    vertex_vec[i].pre = ~0u;
  }

  cin >> dummy;  // num edge for current shard
  for (unsigned int i = 0; i < global.num_edge; ++i) {
    cin >> edge_vec[i].from;

    // get user defined members
    cin >> edge_vec[i].to;
    cin >> edge_vec[i].weight;
  }
}
