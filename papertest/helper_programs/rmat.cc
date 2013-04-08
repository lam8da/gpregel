#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstring>

#include "sprng.h"

class RMatGenerator {
 public:

  RMatGenerator(
      const unsigned int num_vertex,
      const unsigned int num_edge,
      const bool self_loops_or_not)
      : n(num_vertex),
        m(num_edge),
        self_loops(self_loops_or_not) {
    a = 0.45;
    b = 0.15;
    c = 0.15;
    d = 0.25;
  }

  ~RMatGenerator() {
    if (g.start != NULL) delete[] g.start;
    if (g.end != NULL) delete[] g.end;
    if (g.in_edge_count != NULL) delete[] g.in_edge_count;
    if (g.out_edge_count != NULL) delete[] g.out_edge_count;
  }

  void GenGraph() {
    int *stream1 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED1, SPRNG_DEFAULT);
    int *stream2 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED2, SPRNG_DEFAULT);
    int *stream3 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED3, SPRNG_DEFAULT);
    int *stream4 = init_sprng(SPRNG_CMRG, 0, 1, SPRNG_SEED4, SPRNG_DEFAULT);

    unsigned int *in_edge_count = new unsigned int[n];
    unsigned int *out_edge_count = new unsigned int[n];
    unsigned int *start_vertex = new unsigned int[m];
    unsigned int *end_vertex = new unsigned int[m];

    for (unsigned int i = 0; i < n; ++i) {
      in_edge_count[i] = 0;
      out_edge_count[i] = 0;
    }

    double a0 = a, b0 = b, c0 = c, d0 = d;
    for (int i=0; i<m; i++) {
      a = a0; b = b0; c = c0; d = d0;
      unsigned int u = 1, v = 1;

      unsigned int step = n/2;
      while (step >= 1) {
        ChoosePartition(&u, &v, step, stream1);
        step = step/2;
        VaryParams(&a, &b, &c, &d, stream4, stream3);
      }

      /* Create edge [u-1, v-1] */
      if ((!self_loops) && (u == v)) {
        i--;
        continue;
      }

      start_vertex[i] = u-1;
      ++out_edge_count[u-1];

      end_vertex[i] = v-1;
      ++in_edge_count[v-1];
    }
    free(stream1);
    free(stream2);

    g.n = n;
    g.m = m;
    g.in_edge_count = in_edge_count;
    g.out_edge_count = out_edge_count;
    g.start = start_vertex;
    g.end = end_vertex;

    free(stream3);
    free(stream4);
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

  struct RMatGraph {
    unsigned int n, m;
    unsigned int *start, *end;
    unsigned int *in_edge_count, *out_edge_count;
    RMatGraph() : n(0), m(0), start(NULL), end(NULL),
                  in_edge_count(NULL), out_edge_count(NULL) {
    }
  };

  static const long int SPRNG_SEED1 = 12619830;
  static const long int SPRNG_SEED2 = 31219885;
  static const long int SPRNG_SEED3 = 72824922;
  static const long int SPRNG_SEED4 = 81984016;

  unsigned int n, m;
  double a, b, c, d;
  bool self_loops;
  RMatGraph g;

  void ChoosePartition(unsigned int *u, unsigned int* v, unsigned int step, int *stream) {
    double p;
    p = sprng(stream);
    if (p < a) {
      /* Do nothing */
    } else if ((a < p) && (p < a+b)) {
      *v = *v + step;
    } else if ((a+b < p) && (p < a+b+c)) {
      *u = *u + step;
    } else if ((a+b+c < p) && (p < a+b+c+d)) {
      *u = *u + step;
      *v = *v + step;
    }
  }

  void VaryParams(
      double* a, double* b, double* c, double* d,
      int *stream_a, int *stream_b) {
    /* Allow a max. of 5% variation */
    double v= 0.05;

    if (sprng(stream_a) > 0.5) {
      *a += *a * v * sprng(stream_b);
    } else {
      *a -= *a * v * sprng(stream_b);
    }

    if (sprng(stream_a) > 0.5) {
      *b += *b * v * sprng(stream_b);
    } else {
      *b += *b * v * sprng(stream_b);
    }

    if (sprng(stream_a) > 0.5) {
      *c += *c * v * sprng(stream_b);
    } else {
      *c -= *c * v * sprng(stream_b);
    }

    if (sprng(stream_a) > 0.5) {
      *d += *d * v * sprng(stream_b);
    } else {
      *d -= *d * v * sprng(stream_b);
    }

    double s = *a + *b + *c + *d;
    *a = *a/s;
    *b = *b/s;
    *c = *c/s;
    *d = *d/s;
  }

};

// argv[1]: n
// argv[2]: m
// argv[3]: file
int main(int argc, char **argv) {
  RMatGenerator g(atoi(argv[1]), atoi(argv[2]), false);
  g.GenGraph();
  g.WriteToFile(argv[3]);
  return 0;
}
