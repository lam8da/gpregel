#include "cpu_algorithm.h"

#include <algorithm>
#include <vector>

#include "host_graph_data_types.h"

using std::vector;

void CpuAlgorithm(
    const Config *conf,
    HostGraphGlobal &global,
    vector<HostGraphVertex> &vertex_vec,
    vector<HostGraphEdge> &edge_vec) {
  vector<unsigned int> queue;
  vector<unsigned int> level_queue;
  vector<bool> vst(global.num_vertex);

  vertex_vec[global.source].level = 0;
  queue.push_back(global.source);
  level_queue.push_back(0);
  vst[global.source] = true;

  for (unsigned int i = 0; i < queue.size(); ++i) {
    unsigned int vid = queue[i];
    unsigned int level = level_queue[i];

    const unsigned int begin =
      (vid == 0 ? 0 : vertex_vec[vid - 1].sum_out_edge_count);
    const unsigned int end = vertex_vec[vid].sum_out_edge_count;

    for (unsigned int k = begin; k < end; ++k) {
      unsigned int to = edge_vec[k].to;
      if (!vst[to]) {
        vertex_vec[to].level = level + 1;
        queue.push_back(to);
        level_queue.push_back(level + 1);
        vst[to] = true;
      }
    }
  }
}
