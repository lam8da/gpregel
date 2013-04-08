// *****************************************************************************
// Filename:    bfs.cc
// Date:        2013-03-25 19:45
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include "bfs.h"

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

unsigned int CpuAlgorithm(
    const unsigned int max_super_step,
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  vector<unsigned int> queue;
  vector<bool> vst(global.num_vertex);
  unsigned int max_level = 0;

  vertex_vec[global.root].level = 0;
  queue.push_back(global.root);
  vst[global.root] = true;

  for (unsigned int i = 0; i < queue.size(); ++i) {
    const unsigned int vid = queue[i];
    const unsigned int level = vertex_vec[vid].level + 1;

    const unsigned int begin =
      (vid == 0 ? 0 : vertex_vec[vid - 1].sum_out_edge_count);
    const unsigned int end = vertex_vec[vid].sum_out_edge_count;

    for (unsigned int k = begin; k < end; ++k) {
      unsigned int to = edge_vec[k].to;
      if (!vst[to]) {
        if (level > max_level) max_level = level;
        vertex_vec[to].level = level;
        queue.push_back(to);
        vst[to] = true;
      }
    }
  }
  return max_level;
}

void Read(
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  cin >> global.num_vertex >> global.num_edge >> global.root;
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
    vertex_vec[i].level = ~0u;
  }

  cin >> dummy;  // num edge for current shard
  for (unsigned int i = 0; i < global.num_edge; ++i) {
    cin >> edge_vec[i].from;
    cin >> edge_vec[i].to;
  }
}
