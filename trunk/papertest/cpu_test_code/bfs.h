// *****************************************************************************
// Filename:    bfs.h
// Date:        2013-03-25 19:43
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#ifndef BFS_H_
#define BFS_H_

#include <vector>

using std::vector;

struct HostGraphGlobal {
  unsigned int num_vertex;
  unsigned int num_edge;

  // user defined members
  unsigned int root;
};

struct HostGraphVertex {
  unsigned int id;
  unsigned int sum_out_edge_count;

  bool operator<(const HostGraphVertex &rhs) const {
    return id < rhs.id;
  }

  // user defined members
  unsigned int level;
};

struct HostGraphEdge {
  unsigned int from;
  unsigned int to;

  bool operator<(const HostGraphEdge &rhs) const {
    return (from == rhs.from ? to < rhs.to : from < rhs.from);
  }
};

unsigned int CpuAlgorithm(
    const unsigned int max_super_step,
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec);

void Read(
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec);

#endif
