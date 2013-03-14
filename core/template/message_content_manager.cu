// *****************************************************************************
// Filename:    message_content_manager.cc
// Date:        2013-01-08 10:06
// Author:      Guangda Lai
// Email:       lambda2fei@gmail.com
// Description: TODO(laigd): Put the file description here.
// *****************************************************************************

#include "message_content_manager.h"

#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <helper_functions.h>
#include <thrust/device_ptr.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/gather.h>

#include "constants.h"
#include "device_graph_data_types.h"
#include "device_util.h"

#ifdef LAMBDA_DEBUG
#include "debug.h"
#define LAMBDA_HEADER "------> "
#endif

#define COPY_FROM_DEVICE_TO_DEVICE( \
    FROM, TO, MEMBER, FROM_OFFSET, TO_OFFSET, COUNT, TYPE) \
    checkCudaErrors(cudaMemcpyAsync( \
            TO->MEMBER + TO_OFFSET, \
            FROM.MEMBER + FROM_OFFSET, \
            COUNT * sizeof(TYPE), \
            cudaMemcpyDeviceToDevice))

namespace {

unsigned int RoundUpToMultiples(
    const size_t type_size,
    const unsigned int count,
    const size_t bench_mark) {
  return (type_size * count + bench_mark - 1) / bench_mark;
}

}  // namespace

void MessageContentManager::Allocate(
    const unsigned int size,
    MessageContent *mcon) {
  mcon->d_size = size;

#ifdef LAMBDA_SHARE_ONE_MESSAGE_ARRAY

  mcon->d_space_size = 0
#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
     + RoundUpToMultiples(sizeof(bool), size, sizeof(unsigned int))
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
     //// TODO(laigd): add user defined members
     + RoundUpToMultiples(sizeof(unsigned int), size, sizeof(unsigned int))
#else
$$M[[+ RoundUpToMultiples(sizeof(<GP_TYPE>), size, sizeof(unsigned int))]]
#endif
     ;

  ALLOCATE_ON_DEVICE(unsigned int, mcon->d_space, mcon->d_space_size);

  unsigned int offset = 0;

#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  mcon->d_is_full = (bool*)(mcon->d_space + offset);
  offset += RoundUpToMultiples(sizeof(bool), size, sizeof(unsigned int));
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  mcon->d_dist = (unsigned int*)(mcon->d_space + offset);
  offset += RoundUpToMultiples(sizeof(unsigned int), size, sizeof(unsigned int));
#else
$$M[[mcon->d_<GP_NAME> = (<GP_TYPE>*)(mcon->d_space + offset); offset += RoundUpToMultiples(sizeof(<GP_TYPE>), size, sizeof(unsigned int));]]
#endif

#else  // Not share one array

#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  ALLOCATE_ON_DEVICE(bool,         mcon->d_is_full, mcon->d_size);
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  ALLOCATE_ON_DEVICE(unsigned int, mcon->d_dist,    mcon->d_size);
#else
$$M[[ALLOCATE_ON_DEVICE(<GP_TYPE>, mcon->d_<GP_NAME>, mcon->d_size);]]
#endif

#endif  // LAMBDA_SHARE_ONE_MESSAGE_ARRAY
}

void MessageContentManager::Deallocate(MessageContent *mcon) {
#ifdef LAMBDA_SHARE_ONE_MESSAGE_ARRAY

  DEALLOCATE_ON_DEVICE(mcon->d_space);

#else  // Not share one array

#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  DEALLOCATE_ON_DEVICE(mcon->d_is_full);
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  DEALLOCATE_ON_DEVICE(mcon->d_dist);
#else
$$M[[DEALLOCATE_ON_DEVICE(mcon->d_<GP_NAME>);]]
#endif

#endif
}

void MessageContentManager::Shuffle(
    MessageContent *mcon,
    thrust::device_ptr<unsigned int> thr_shuffle_index,
    void *d_tmp_buf) {
#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  SHUFFLE_MEMBER(bool,         mcon->d_is_full, mcon->d_size, d_tmp_buf, thr_shuffle_index);
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  SHUFFLE_MEMBER(unsigned int, mcon->d_dist,    mcon->d_size, d_tmp_buf, thr_shuffle_index);
#else
$$M[[SHUFFLE_MEMBER(<GP_TYPE>, mcon->d_<GP_NAME>, mcon->d_size, d_tmp_buf, thr_shuffle_index);]]
#endif
}

void MessageContentManager::Copy(
    const MessageContent &from,
    MessageContent *to) {
#ifdef LAMBDA_SHARE_ONE_MESSAGE_ARRAY

  COPY_FROM_DEVICE_TO_DEVICE(from, to, d_space, 0, 0, from.d_space_size, unsigned int);

#else  // Not share one array

#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  COPY_FROM_DEVICE_TO_DEVICE(from, to, d_is_full, 0, 0, from.d_size, bool        );
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  COPY_FROM_DEVICE_TO_DEVICE(from, to, d_dist,    0, 0, from.d_size, unsigned int);
#else
$$M[[COPY_FROM_DEVICE_TO_DEVICE(from, to, d_<GP_NAME>, 0, 0, from.d_size, <GP_TYPE>);]]
#endif

#endif
}

#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
void MessageContentManager::Clear(MessageContent *mcon) {
  thrust::device_ptr<bool> thr_is_full(mcon->d_is_full);
  thrust::fill(thr_is_full, thr_is_full + mcon->d_size, false);
}
#endif

#ifdef LAMBDA_DEBUG
void MessageContentManager::DebugOutput(
    const MessageContent &mcon, const bool is_send_buf) {
  unsigned int *buf = NULL;
  checkCudaErrors(cudaMallocHost(&buf, mcon.d_size * sizeof(unsigned int)));

  cout << LAMBDA_HEADER << "[MessageContent "
       << (is_send_buf ? "Send" : "Recv") << "]" << endl;
#ifndef LAMBDA_FULL_MESSAGE_IN_EACH_SUPERSTEP
  DEBUG_OUTPUT(buf, mcon.d_is_full, "is_full: ", mcon.d_size, bool);
#endif

#ifdef LAMBDA_TEST_SHORTEST_PATH
  //// TODO(laigd): add user defined members
  DEBUG_OUTPUT(buf, mcon.d_dist,    "dist:    ", mcon.d_size, unsigned int);
#else
$$M[[DEBUG_OUTPUT(buf, mcon.d_<GP_NAME>, "<GP_NAME>: ", mcon.d_size, <GP_TYPE>);]]
#endif

  checkCudaErrors(cudaFreeHost(buf));
}
#endif

#ifdef LAMBDA_DEBUG
#undef LAMBDA_HEADER
#endif

#undef COPY_FROM_DEVICE_TO_DEVICE
