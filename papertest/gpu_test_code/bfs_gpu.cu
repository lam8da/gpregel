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

#include "bfs.h"

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

__global__ void BfsKernel(
    const unsigned int ss,
    const unsigned int numv,
    const unsigned int *va,
    const unsigned int *ea,
    bool *fa,
    bool *xa,
    unsigned int *ca) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < numv) {
    if (fa[tid]) {
      fa[tid] = false;
      // xa[tid] = true;
      const unsigned int end = va[tid];
      for (int i = (tid == 0 ? 0 : va[tid - 1]); i < end; ++i) {
        const unsigned int nid = ea[i];
        if (ca[nid] > ss + 1) {
          ca[nid] = ss + 1;
          // fa[nid] = true;  // Conflict with line 41!
          xa[nid] = true;
          fa[numv] = true;  // tell host that the iteration has not finished
        }
      }
    }
  }
}

__global__ void ResetFaXaKernel(const unsigned int numv, bool *fa, bool *xa) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < numv) {
    if (xa[tid]) {
      fa[tid] = true;
      xa[tid] = false;
    }
  }
}

unsigned int Bfs(
    const unsigned int numv,
    const unsigned int nume,
    const unsigned int root,
    const unsigned int *h_va,
    const unsigned int *h_ea,
    unsigned int *h_ca,
    float *duration) {
  unsigned int *d_va = NULL;
  unsigned int *d_ea = NULL;
  unsigned int *d_ca = NULL;
  bool *d_fa = NULL;
  bool *d_xa = NULL;

  const unsigned int vsize = numv * sizeof(unsigned int);
  const unsigned int esize = nume * sizeof(unsigned int);
  const unsigned int bsize = numv * sizeof(bool);

  checkCudaErrors(cudaMalloc((void **)&d_va, vsize));
  checkCudaErrors(cudaMalloc((void **)&d_ea, esize));
  checkCudaErrors(cudaMalloc((void **)&d_ca, vsize));
  checkCudaErrors(cudaMalloc((void **)&d_fa, bsize + sizeof(bool)));
  checkCudaErrors(cudaMalloc((void **)&d_xa, bsize));

  checkCudaErrors(cudaMemcpy(d_va, h_va, vsize, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_ea, h_ea, esize, cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemset(d_ca, 0xff, vsize));
  checkCudaErrors(cudaMemset(d_fa, 0, bsize + sizeof(bool)));
  checkCudaErrors(cudaMemset(d_xa, 0, bsize));

  bool boolean = true;
  checkCudaErrors(cudaMemcpy(d_fa + root, &boolean, sizeof(bool), cudaMemcpyHostToDevice));
  unsigned int rootlvl = 0;
  checkCudaErrors(cudaMemcpy(d_ca + root, &rootlvl, sizeof(unsigned int), cudaMemcpyHostToDevice));

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
    checkCudaErrors(cudaMemcpy(d_fa + numv, &boolean, sizeof(bool), cudaMemcpyHostToDevice));

    BfsKernel<<<blocks_per_grid, threads_per_block>>>(superstep, numv, d_va, d_ea, d_fa, d_xa, d_ca);
    ResetFaXaKernel<<<blocks_per_grid, threads_per_block>>>(numv, d_fa, d_xa);
    ++superstep;

    checkCudaErrors(cudaMemcpy(&boolean, d_fa + numv, sizeof(bool), cudaMemcpyDeviceToHost));
    if (!boolean) break;
  }

  sdkStopTimer(&timer);
  *duration = sdkGetTimerValue(&timer);
  sdkDeleteTimer(&timer);
  // ------------------------- end profiling -------------------------

  checkCudaErrors(cudaMemcpy(h_ca, d_ca, vsize, cudaMemcpyDeviceToHost));

  checkCudaErrors(cudaFree(d_va));
  checkCudaErrors(cudaFree(d_ea));
  checkCudaErrors(cudaFree(d_ca));
  checkCudaErrors(cudaFree(d_fa));
  checkCudaErrors(cudaFree(d_xa));
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
  // std::sort(vertex_vec.begin(), vertex_vec.end());
  std::sort(edge_vec.begin(), edge_vec.end());
  unsigned int max_level = CpuAlgorithm(
      999999999, global, vertex_vec, edge_vec);

  // ------------------------- start gpu -------------------------
  unsigned int *h_va = new unsigned int[global.num_vertex];
  unsigned int *h_ea = new unsigned int[global.num_edge];
  unsigned int *h_ca = new unsigned int[global.num_vertex];
  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    h_va[i] = vertex_vec[i].sum_out_edge_count;
  }
  for (unsigned int i = 0; i < global.num_edge; ++i) {
    h_ea[i] = edge_vec[i].to;
  }

  float duration = 0;
  unsigned int superstep = Bfs(global.num_vertex, global.num_edge, global.root, h_va, h_ea, h_ca, &duration);

  // ------------------------- check result -------------------------
  bool correct = true;
  for (unsigned int i = 0; i < global.num_vertex; ++i) {
    if (h_ca[i] != vertex_vec[i].level) {
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
        out << vertex_vec[j].level << endl;
      }
      out << endl;
      out.close();
      break;
    }
  }

  delete[] h_va;
  delete[] h_ea;
  delete[] h_ca;

  // ------------------------- output -------------------------
  cout << "check result: " << (correct ? "correct, " : "WRONG!!!!! ")
       << "root: " << global.root << ", "
       << "max_level: " << max_level << ", "
       << "superstep: " << superstep << ", "
       << "gpu_duration: " << duration << " ms."
       << endl;

  checkCudaErrors(cudaDeviceReset());
  return 0;
}

