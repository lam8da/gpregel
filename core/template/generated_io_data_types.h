// *****************************************************************************
// Filename:    generated_io_data_types.h
// Date:        2012-12-11 16:49
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: This file contains data structures used for input operations.
//              Each of these structures only contain user defined 'in' member.
// *****************************************************************************

#ifndef GENERATED_IO_DATA_TYPES_H_
#define GENERATED_IO_DATA_TYPES_H_

#include <istream>

#include "rand_util.h"

using std::istream;

struct IoGlobal {
  unsigned int num_vertex;
  unsigned int num_edge;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined 'in' members
  unsigned int source;
#else
$$G[[<GP_TYPE> <GP_NAME>;]]
#endif

  // Read default and user defined 'in' members
  static void Read(istream &in, IoGlobal *global) {
    in >> global->num_vertex;
    in >> global->num_edge;
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add code to read user defined 'in' members
    in >> global->source;
#else
$$G[[in >> global-><GP_NAME>;]]
#endif
  }

  // Only generate user defined 'in' members
  static void Rand(IoGlobal *global) {
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add code to generate user defined 'in' members
    global->source = 0;  // RandUtil::RandVertexId();
#else
$$G[[global-><GP_NAME> = <GP_RAND_VALUE>;]]
#endif
  }
};

struct IoVertex {
  unsigned int id;
  unsigned int in_edge_count;
  unsigned int out_edge_count;
  //// TODO(laigd): add user defined 'in' members
#ifndef LAMBDA_TEST_SHORTEST_PATH
$$V_IN[[<GP_TYPE> <GP_NAME>;]]
#endif

  static void Read(istream &in, IoVertex *vertex) {
    in >> vertex->id;
    in >> vertex->in_edge_count;
    in >> vertex->out_edge_count;
    //// TODO(laigd): add code to read user defined 'in' members
#ifndef LAMBDA_TEST_SHORTEST_PATH
$$V_IN[[in >> vertex-><GP_NAME>;]]
#endif
  }

  static void Rand(IoVertex *vertex) {
    //// TODO(laigd): add code to generate user defined 'in' members
#ifndef LAMBDA_TEST_SHORTEST_PATH
$$V_IN[[vertex-><GP_NAME> = <GP_RAND_VALUE>;]]
#endif
  }
};

struct IoEdge {
  unsigned int from;
  unsigned int to;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined 'in' members
  unsigned int weight;
#else
$$E_IN[[<GP_TYPE> <GP_NAME>;]]
#endif

  static void Read(istream &in, IoEdge *edge) {
    in >> edge->from;
    in >> edge->to;
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add code to read user defined 'in' members
    in >> edge->weight;
#else
$$E_IN[[in >> edge-><GP_NAME>;]]
#endif
  }

  static void Rand(IoEdge *edge) {
#ifdef LAMBDA_TEST_SHORTEST_PATH
    //// TODO(laigd): add code to generate user defined 'in' members
    edge->weight = edge->from;  // RandUtil::RandSmallUInt();
#else
$$E_IN[[edge-><GP_NAME> = <GP_RAND_VALUE>;]]
#endif
  }
};

#endif
