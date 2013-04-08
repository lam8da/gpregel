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

#include <cuda_runtime.h>
#include <helper_cuda.h>
#include <helper_functions.h>

#include "sssp.h"

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

__global__ void SsspKernel1(
    const unsigned int numv,
    const unsigned int *va,
    const unsigned int *ea,
    const unsigned int *wa,
    bool *ma,
    unsigned int *ca,
    unsigned int *ua) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < numv) {
    if (ma[tid]) {
      ma[tid] = false;
      const unsigned int end = va[tid];
      for (int i = (tid == 0 ? 0 : va[tid - 1]); i < end; ++i) {
        unsigned int nid = ea[i];
        unsigned int w = ca[tid] + wa[i];
        atomicMin(ua + nid, w);
      }
    }
  }
}

__global__ void SsspKernel2(
    const unsigned int numv,
    const unsigned int *va,
    const unsigned int *ea,
    const unsigned int *wa,
    bool *ma,
    unsigned int *ca,
    unsigned int *ua) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < numv) {
    if (ca[tid] > ua[tid]) {
      ca[tid] = ua[tid];
      ma[tid] = true;
      ma[numv] = true;  // notify host that the iteration is continueing.
    }
    ua[tid] = ca[tid];
  }
}

unsigned int Sssp(
    const unsigned int numv,
    const unsigned int nume,
    const unsigned int source,
    const unsigned int *h_va,
    const unsigned int *h_ea,
    const unsigned int *h_wa,
    unsigned int *h_ca,
    float *duration) {
  unsigned int *d_va = NULL;
  unsigned int *d_ea = NULL;
  unsigned int *d_wa = NULL;
  bool *d_ma = NULL;
  unsigned int *d_ca = NULL;
  unsigned int *d_ua = NULL;

  const unsigned int vsize = numv * sizeof(unsigned int);
  const unsigned int esize = nume * sizeof(unsigned int);
  const unsigned int bsize = numv * sizeof(bool);

  checkCudaErrors(cudaMalloc((void **)&d_va, vsize));
  checkCudaErrors(cudaMalloc((void **)&d_ea, esize));
  checkCudaErrors(cudaMalloc((void **)&d_wa, esize));
  checkCudaErrors(cudaMalloc((void **)&d_ma, bsize + sizeof(bool)));
  checkCudaErrors(cudaMalloc((void **)&d_ca, vsize));
  checkCudaErrors(cudaMalloc((void **)&d_ua, vsize));

  checkCudaErrors(cudaMemcpy(d_va, h_va, vsize, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_ea, h_ea, esize, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_wa, h_wa, esize, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemset(d_ma, 0, bsize + sizeof(bool)));
  checkCudaErrors(cudaMemset(d_ca, 0xff, vsize));
  checkCudaErrors(cudaMemset(d_ua, 0xff, vsize));

  bool boolean = true;
  checkCudaErrors(cudaMemcpy(d_ma + source, &boolean, sizeof(bool), cudaMemcpyHostToDevice));
  unsigned int source_dist = 0;
  checkCudaErrors(cudaMemcpy(d_ca + source, &source_dist, sizeof(unsigned int), cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_ua + source, &source_dist, sizeof(unsigned int), cudaMemcpyHostToDevice));

  const unsigned int threads_per_block = 128;
  const unsigned int blocks_per_grid =(numv + threads_per_block - 1) / threads_per_block;

  // ------------------------- start profiling -------------------------
  StopWatchInterface *timer;
  sdkCreateTimer(&timer);
  sdkResetTimer(&timer);
  sdkStartTimer(&timer);

  unsigned int superstep = 0;
  while (true) {
    boolean = false;
    checkCudaErrors(cudaMemcpy(d_ma + numv, &boolean, sizeof(bool), cudaMemcpyHostToDevice));

    SsspKernel1<<<blocks_per_grid, threads_per_block>>>(numv, d_va, d_ea, d_wa, d_ma, d_ca, d_ua);
    SsspKernel2<<<blocks_per_grid, threads_per_block>>>(numv, d_va, d_ea, d_wa, d_ma, d_ca, d_ua);
    ++superstep;

    checkCudaErrors(cudaMemcpy(&boolean, d_ma + numv, sizeof(bool), cudaMemcpyDeviceToHost));
    if (!boolean) break;
  }

  sdkStopTimer(&timer);
  *duration = sdkGetTimerValue(&timer);
  sdkDeleteTimer(&timer);
  // ------------------------- end profiling -------------------------

  checkCudaErrors(cudaMemcpy(h_ca, d_ca, vsize, cudaMemcpyDeviceToHost));

  checkCudaErrors(cudaFree(d_va));
  checkCudaErrors(cudaFree(d_ea));
  checkCudaErrors(cudaFree(d_wa));
  checkCudaErrors(cudaFree(d_ma));
  checkCudaErrors(cudaFree(d_ca));
  checkCudaErrors(cudaFree(d_ua));
  return superstep;
}

//argv[1]: gpu_id
int main(int argc, char **argv) {
  unsigned int gpuid = atoi(argv[1]);
  checkCudaErrors(cudaSetDevice(gpuid));

  HostGraphGlobal global;
  vector<HostGraphVertex> vertex_vec;
  vector<HostGraphEdge> edge_vec;

  Read(global, vertex_vec, edge_vec);

  // ------------------------- start cpu -------------------------
  // not necessary, we assume that the vertexes are ordered in input file.
  // std::sort(vertex_vec.begin(), vertex_vec.end());
  std::sort(edge_vec.begin(), edge_vec.end());
  CpuAlgorithm(999999999, global, vertex_vec, edge_vec);

  // ------------------------- start gpu -------------------------
  unsigned int *h_va = new unsigned int[global.num_vertex];
  unsigned int *h_ea = new unsigned int[global.num_edge];
  unsigned int *h_wa = new unsigned int[global.num_edge];
  unsigned int *h_ca = new unsigned int[global.num_vertex];
  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    h_va[i] = vertex_vec[i].sum_out_edge_count;
  }
  for (unsigned int i = 0; i < global.num_edge; ++i) {
    h_ea[i] = edge_vec[i].to;
    h_wa[i] = edge_vec[i].weight;
  }

  float duration = 0;
  unsigned int superstep = Sssp(global.num_vertex, global.num_edge, global.source, h_va, h_ea, h_wa, h_ca, &duration);

  // ------------------------- check result -------------------------
  bool correct = true;
  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    if (h_ca[i] != vertex_vec[i].dist) {
      correct = false;

      ofstream out("gpuout-456767321776");
      out << "gpu result:" << endl;
      for (unsigned int j = 0; j <global.num_vertex; ++j) {
        out << h_ca[j] << endl;
      }
      out << endl;
      out.close();

      out.open("cpuout-456767321776");
      out << "cpu result:" << endl;
      for (unsigned int j = 0; j <global.num_vertex; ++j) {
        out << vertex_vec[j].dist << endl;
      }
      out << endl;
      out.close();
      break;
    }
  }

  delete[] h_va;
  delete[] h_ea;
  delete[] h_wa;
  delete[] h_ca;

  // ------------------------- output -------------------------
  cout << "check result: " << (correct ? "correct, " : "WRONG!!!!! ")
       << "source: " << global.source << ", "
       << "superstep: " << superstep << ", "
       << "gpu_duration: " << duration << " ms."
       << endl;

  checkCudaErrors(cudaDeviceReset());
  return 0;
}

