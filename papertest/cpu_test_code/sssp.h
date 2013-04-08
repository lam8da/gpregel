// *****************************************************************************
// Filename:    sssp.h
// Date:        2013-03-29 16:03
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#ifndef SSSP_H_
#define SSSP_H_

#include <vector>

using std::vector;

struct HostGraphGlobal {
  unsigned int num_vertex;
  unsigned int num_edge;

  // user defined members
  unsigned int source;
};

struct HostGraphVertex {
  unsigned int id;
  unsigned int sum_out_edge_count;

  bool operator<(const HostGraphVertex &rhs) const {
    return id < rhs.id;
  }

  // user defined members
  unsigned int dist;
  unsigned int pre;
};

struct HostGraphEdge {
  unsigned int from;
  unsigned int to;

  bool operator<(const HostGraphEdge &rhs) const {
    return (from == rhs.from ? to < rhs.to : from < rhs.from);
  }

  // user defined members
  unsigned int weight;
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
