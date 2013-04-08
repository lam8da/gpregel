OUTPUT_DIR := out/helper
SRC_DIR := papertest/cpu_test_code
NVCC := /usr/local/cuda-5.0/bin/nvcc -m64 -O3 -gencode arch=compute_20,code=sm_20 -I/usr/local/cuda-5.0/include -I/usr/local/cuda-5.0/samples/common/inc 

main:
	mkdir -p $(OUTPUT_DIR)
	$(NVCC) -c $(SRC_DIR)/bfs.cc -o $(OUTPUT_DIR)/bfs.o
	$(NVCC) -c $(SRC_DIR)/bfs_cpu.cc -o $(OUTPUT_DIR)/bfs_cpu.o
	$(NVCC) -o $(OUTPUT_DIR)/bfs.out $(OUTPUT_DIR)/bfs.o $(OUTPUT_DIR)/bfs_cpu.o
	$(NVCC) $(SRC_DIR)/page_rank.cc -o $(OUTPUT_DIR)/pg.out
