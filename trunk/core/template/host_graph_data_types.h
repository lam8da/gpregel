// *****************************************************************************
// Filename:    host_graph_data_types.h
// Date:        2012-12-22 18:10
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: This file contains data structures used by HostGraph to run
//              corresponding algorithms on CPU.
// *****************************************************************************

#ifndef GENERATED_GRAPH_DATA_TYPES_ON_HOST_H_
#define GENERATED_GRAPH_DATA_TYPES_ON_HOST_H_

#include <iostream>

#include "generated_io_data_types.h"

using std::ostream;
using std::endl;

struct HostGraphGlobal {
  unsigned int num_vertex;
  unsigned int num_edge;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  unsigned int source;
#else
$$G[[<GP_TYPE> <GP_NAME>;]]
#endif

  void Set(const IoGlobal &g) {
    num_vertex = g.num_vertex;
    num_edge = g.num_edge;
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add user defined members
    source = g.source;
#else
$$G[[<GP_NAME> = g.<GP_NAME>;]]
#endif
  }
};

struct HostGraphVertex {
  unsigned int id;
  unsigned int sum_out_edge_count;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  unsigned int dist;
  unsigned int pre;
#else
$$V[[<GP_TYPE> <GP_NAME>;]]
#endif

  void Set(const IoVertex &v) {
    id = v.id;
    sum_out_edge_count = v.out_edge_count;
    //// TODO(laigd): add user defined members
#ifdef LAMBDA_TEST_SHORTEST_PATH
    dist = ~0U;
    pre = ~0U;
#else
$$V_IN[[<GP_NAME> = v.<GP_NAME>;]]
$$V_OUT[[<GP_NAME> = <GP_INIT_VALUE>;]]
#endif
  }

  void Write(ostream &out) const {
    out << id
#ifdef LAMBDA_TEST_SHORTEST_PATH
        //// TODO(laigd): add user defined 'out' members
        << ", " << dist
        << ", " << pre
#else
$$V[[<< ", " << <GP_NAME>]]
#endif
        << endl;
  }

  bool operator<(const HostGraphVertex &rhs) const {
    return id < rhs.id;
  }
};

struct HostGraphEdge {
  unsigned int from;
  unsigned int to;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  unsigned int weight;
#else
$$E[[<GP_TYPE> <GP_NAME>;]]
#endif

  void Set(const IoEdge &e) {
    from = e.from;
    to = e.to;
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add user defined members
    weight = e.weight;
#else
$$E_IN[[<GP_NAME> = e.<GP_NAME>;]]
$$E_OUT[[<GP_NAME> = <GP_INIT_VALUE>;]]
#endif
  }

  void Write(ostream &out) const {
    out << from << ", " << to
        //// TODO(laigd): add user defined 'out' members
#ifndef LAMBDA_TEST_SHORTEST_PATH
$$E[[<< ", " << <GP_NAME>]]
#endif
        << endl;
  }

  bool operator<(const HostGraphEdge &rhs) const {
    return (from == rhs.from ? to < rhs.to : from < rhs.from);
  }
};

#endif
