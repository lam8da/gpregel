// *****************************************************************************
// Filename:    global_manager.cc
// Date:        2013-01-08 10:01
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include "global_manager.h"

#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <helper_functions.h>

#include "device_graph_data_types.h"
#include "generated_io_data_types.h"

#ifdef LAMBDA_DEBUG
#include "debug.h"
#define LAMBDA_HEADER "------> "
#endif

void GlobalManager::Set(const IoGlobal &src, Global *dst) {
  dst->d_num_vertex = src.num_vertex;
  dst->d_num_edge = src.num_edge;
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  dst->d_source = src.source;
#else
$$G[[dst->d_<GP_NAME> = src.<GP_NAME>;]]
#endif
}

#ifdef LAMBDA_DEBUG
void GlobalManager::DebugOutput(const Global &global) {
  cout << LAMBDA_HEADER << "[Global]" << endl;
  cout << LAMBDA_HEADER
      << "num_vertex: " << global.d_num_vertex << ", "
      << "num_edge: " << global.d_num_edge
      //// TODO(laigd): add user defined members
#ifdef LAMBDA_TEST_SHORTEST_PATH
      << ", " << "source: " << global.d_source
#else
$$G[[<< ", " << "<GP_NAME>: " << global.d_<GP_NAME>]]
#endif
      << endl;
}
#endif

#ifdef LAMBDA_DEBUG
#undef LAMBDA_HEADER
#endif
