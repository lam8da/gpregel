// *****************************************************************************
// Filename:    edge_content_manager.cc
// Date:        2013-01-08 09:44
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include "edge_content_manager.h"

#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <helper_functions.h>
#include <thrust/device_ptr.h>
#include <thrust/copy.h>
#include <thrust/gather.h>

#include "constants.h"
#include "device_graph_data_types.h"
#include "device_util.h"

#ifdef LAMBDA_DEBUG
#include "debug.h"
#define LAMBDA_HEADER "------> "
#endif

void EdgeContentManager::Allocate(const unsigned int size, EdgeContent *econ) {
  econ->d_size = size;
  ALLOCATE_ON_DEVICE(unsigned int, econ->d_from,   econ->d_size);
  ALLOCATE_ON_DEVICE(unsigned int, econ->d_to,     econ->d_size);
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  ALLOCATE_ON_DEVICE(unsigned int, econ->d_weight, econ->d_size);
#else
$$E[[ALLOCATE_ON_DEVICE(<GP_TYPE>, econ->d_<GP_NAME>, econ->d_size);]]
#endif
}

void EdgeContentManager::Deallocate(EdgeContent *econ) {
  DEALLOCATE_ON_DEVICE(econ->d_from);
  DEALLOCATE_ON_DEVICE(econ->d_to);
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  DEALLOCATE_ON_DEVICE(econ->d_weight);
#else
$$E[[DEALLOCATE_ON_DEVICE(econ->d_<GP_NAME>);]]
#endif
}

void EdgeContentManager::ShuffleInMembers(
    EdgeContent *econ,
    thrust::device_ptr<unsigned int> &thr_shuffle_index,
    void *d_tmp_buf) {
  SHUFFLE_MEMBER(unsigned int, econ->d_from,   econ->d_size, d_tmp_buf, thr_shuffle_index);
  SHUFFLE_MEMBER(unsigned int, econ->d_to,     econ->d_size, d_tmp_buf, thr_shuffle_index);
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined 'in' members
  SHUFFLE_MEMBER(unsigned int, econ->d_weight, econ->d_size, d_tmp_buf, thr_shuffle_index);
#else
$$E_IN[[SHUFFLE_MEMBER(<GP_TYPE>, econ->d_<GP_NAME>, econ->d_size, d_tmp_buf, thr_shuffle_index);]]
#endif
}

void EdgeContentManager::InitOutMembers(EdgeContent *econ) {
  //// TODO(laigd): Add user defined 'out' members
#ifndef LAMBDA_TEST_SHORTEST_PATH
$$E_OUT[[INIT_OUT_MEMBERS(<GP_TYPE>, econ->d_<GP_NAME>, econ->d_size, <GP_INIT_VALUE>);]]
#endif
}

#ifdef LAMBDA_DEBUG
void EdgeContentManager::DebugOutput(const EdgeContent &econ) {
  unsigned int *buf = NULL;
  checkCudaErrors(cudaMallocHost(&buf, econ.d_size * sizeof(unsigned int)));

  cout << LAMBDA_HEADER << "[EdgeContent]" << endl;
  DEBUG_OUTPUT(buf, econ.d_from,   "from:   ", econ.d_size, unsigned int);
  DEBUG_OUTPUT(buf, econ.d_to,     "to:     ", econ.d_size, unsigned int);
#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  DEBUG_OUTPUT(buf, econ.d_weight, "weight: ", econ.d_size, unsigned int);
#else
$$E[[DEBUG_OUTPUT(buf, econ.d_<GP_NAME>, "<GP_NAME>: ", econ.d_size, <GP_TYPE>);]]
#endif

  checkCudaErrors(cudaFreeHost(buf));
}
#endif

#ifdef LAMBDA_DEBUG
#undef LAMBDA_HEADER
#endif
