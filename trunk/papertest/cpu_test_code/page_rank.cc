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

struct HostGraphGlobal {
  unsigned int num_vertex;
  unsigned int num_edge;
};

struct HostGraphVertex {
  unsigned int id;
  unsigned int sum_out_edge_count;

  bool operator<(const HostGraphVertex &rhs) const {
    return id < rhs.id;
  }

  // user defined members
  float rank;
};

struct HostGraphEdge {
  unsigned int from;
  unsigned int to;

  bool operator<(const HostGraphEdge &rhs) const {
    return (from == rhs.from ? to < rhs.to : from < rhs.from);
  }
};

void CpuAlgorithm(
    const unsigned int max_super_step,
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  vector<float> tmp_rank(global.num_vertex);
  for (unsigned int i = 0; i < max_super_step; ++i) {
    if (i > 0) {
      for (unsigned int j = 0; j < global.num_vertex; ++j) {
        vertex_vec[j].rank = tmp_rank[j];
      }
    }

    std::fill(tmp_rank.begin(), tmp_rank.end(), 0);
    for (unsigned int j = 0; j < global.num_vertex; ++j) {
      const unsigned int begin =
          (j == 0 ? 0 : vertex_vec[j - 1].sum_out_edge_count);
      const unsigned int end = vertex_vec[j].sum_out_edge_count;
      float averaged = vertex_vec[j].rank / (end - begin);

      for (unsigned int k = begin; k < end; ++k) {
        tmp_rank[edge_vec[k].to] += averaged;
      }
    }
  }
}

int main(int argc, char** argv) {
  HostGraphGlobal global;
  vector<HostGraphVertex> vertex_vec;
  vector<HostGraphEdge> edge_vec;

  cin >> global.num_vertex >> global.num_edge;
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
    vertex_vec[i].rank = 99.0f;
  }
  for (unsigned int i = 0; i < global.num_edge; ++i) {
    cin >> edge_vec[i].from;
    cin >> edge_vec[i].to;
  }

  StopWatchInterface *timer;
  sdkCreateTimer(&timer);
  sdkResetTimer(&timer);
  sdkStartTimer(&timer);

  std::sort(vertex_vec.begin(), vertex_vec.end());
  std::sort(edge_vec.begin(), edge_vec.end());
  CpuAlgorithm(30, global, vertex_vec, edge_vec);

  sdkStopTimer(&timer);
  float duration = sdkGetTimerValue(&timer);
  sdkDeleteTimer(&timer);

  cout << duration << " ms" << endl;
  return 0;
}
