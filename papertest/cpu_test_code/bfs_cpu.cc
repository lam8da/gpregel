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

int main(int argc, char** argv) {
  HostGraphGlobal global;
  vector<HostGraphVertex> vertex_vec;
  vector<HostGraphEdge> edge_vec;

  Read(global, vertex_vec, edge_vec);

  StopWatchInterface *timer;
  sdkCreateTimer(&timer);
  sdkResetTimer(&timer);
  sdkStartTimer(&timer);

  std::sort(vertex_vec.begin(), vertex_vec.end());
  std::sort(edge_vec.begin(), edge_vec.end());
  unsigned int max_level = CpuAlgorithm(
      999999999, global, vertex_vec, edge_vec);

  sdkStopTimer(&timer);
  float duration = sdkGetTimerValue(&timer);
  sdkDeleteTimer(&timer);

  cout << "root: " << global.root << ", "
       << "max_level: " << max_level << ", "
       << "duration: " << duration << " ms."
       << endl;
  return 0;
}
