#include <cstdlib>
#include <cstdio>

#include "sprng.h"

class RandGenerator {
 public:

  RandGenerator(
      const unsigned int num_vertex,
      const unsigned int num_edge,
      const bool self_loops_or_not)
      : n(num_vertex),
        m(num_edge),
        self_loops(self_loops_or_not) {
  }

  ~RandGenerator() {
    if (g.start != NULL) delete[] g.start;
    if (g.end != NULL) delete[] g.end;
    if (g.in_edge_count != NULL) delete[] g.in_edge_count;
    if (g.out_edge_count != NULL) delete[] g.out_edge_count;
  }

  void GenGraph() {
    int *stream1 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED1, SPRNG_DEFAULT);
    int *stream2 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED2, SPRNG_DEFAULT);

    unsigned int *in_edge_count = new unsigned int[n];
    unsigned int *out_edge_count = new unsigned int[n];
    unsigned int *start_vertex = new unsigned int[m];
    unsigned int *end_vertex = new unsigned int[m];
    // unsigned int *weight = new unsigned int[m];

    for (unsigned int i = 0; i < n; ++i) {
      in_edge_count[i] = 0;
      out_edge_count[i] = 0;
    }

    for (unsigned int i = 0; i < m; ++i) {
      unsigned int u = (unsigned int) isprng(stream1) % n;
      unsigned int v = (unsigned int) isprng(stream1) % n;
      if ((u == v) && !self_loops) {
        i--;
        continue;
      }

      // weight[i] = 0 + (unsigned int) (100 - 0) * sprng(stream2);

      start_vertex[i] = u;
      ++out_edge_count[u];

      end_vertex[i] = v;
      ++in_edge_count[v];
    }
    free(stream1);
    free(stream2);

    g.n = n;
    g.m = m;
    g.in_edge_count = in_edge_count;
    g.out_edge_count = out_edge_count;
    g.start = start_vertex;
    g.end = end_vertex;
  }

  void WriteToFile(const char *outfile) {
    FILE* outfp = fopen(outfile, "w");
    fprintf(outfp, "%d\n%d\n", g.n, g.m);

    for (unsigned int i = 0; i < g.n; ++i) {
      fprintf(outfp, "%d %d %d\n", i, g.in_edge_count[i], g.out_edge_count[i]);
    }
    for (unsigned int i = 0; i < g.m; ++i) {
      fprintf(outfp, "%d %d\n", g.start[i], g.end[i]);
    }
    fclose(outfp);
  }

 private:

  struct RandGraph {
    unsigned int n, m;
    unsigned int *start, *end;
    unsigned int *in_edge_count, *out_edge_count;
    RandGraph() : n(0), m(0), start(NULL), end(NULL),
                  in_edge_count(NULL), out_edge_count(NULL) {
    }
  };

  static const long int SPRNG_SEED1 = 1261983;
  static const long int SPRNG_SEED2 = 312198;

  unsigned int n, m;
  bool self_loops;
  RandGraph g;
};

// argv[1]: n
// argv[2]: m
// argv[3]: file
int main(int argc, char **argv) {
  RandGenerator g(atoi(argv[1]), atoi(argv[2]), false);
  g.GenGraph();
  g.WriteToFile(argv[3]);
  return 0;
}
