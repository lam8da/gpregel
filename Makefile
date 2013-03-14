OS_SIZE = 64
OS_ARCH = x86_64

# Location of the CUDA Toolkit binaries and libraries
CUDA_PATH := /usr/local/cuda-5.0
CUDA_INC_PATH := $(CUDA_PATH)/include
CUDA_BIN_PATH := $(CUDA_PATH)/bin
CUDA_LIB_PATH := $(CUDA_PATH)/lib64
CUDA_COMMON_INC_PATH := $(CUDA_PATH)/samples/common/inc

# Common binaries
NVCC ?= $(CUDA_BIN_PATH)/nvcc

# CUDA code generation flags
GENCODE_SM20 := -gencode arch=compute_20,code=sm_20 # for Tesla C2050
GENCODE_SM30 := -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35
GENCODE_FLAGS := $(GENCODE_SM20) # $(GENCODE_SM30)

LAMBDA_DEBUG_FLAGS ?= LAMBDA_DUMMY

# OS-specific build flags
LDFLAGS := -L$(CUDA_LIB_PATH) -lcudart -lpthread
CCFLAGS := -m64

# OS-architecture specific flags
NVCCFLAGS := -m64

# Debug build flags
ifeq ($(dbg),1)
	CCFLAGS += -g
	NVCCFLAGS += -g -G
	TARGET := debug
else
	TARGET := release
endif

# Target rules
#
# $< means the first dependence file
# $* means the the item matching % (including the path if there is one)
# $@ means the target file name
# $+ means the dependence file list

CORE_DIR := ./core
TEMPLATE_DIR := $(CORE_DIR)/template
DEBUG_INSTANCE_DIR := $(CORE_DIR)/debug_instance

CUDA_INCLUDES := -I$(CUDA_INC_PATH) -I$(CUDA_COMMON_INC_PATH)
SPRNG_INCLUDES := -I./inc/sprng2.0-lite/include
GENERAL_INCLUDES := $(CUDA_INCLUDES) $(SPRNG_INCLUDES)

SPRNG_LIBRARIES := -L./inc/sprng2.0-lite/lib -lsprng -lm
GENERAL_LIBRARIES := $(SPRNG_LIBRARIES)

MAX_SUPER_STEP ?= 999999999
BUILD_MARK ?= default

# -------------------------------------------------- General build ----------------------------------------------------------
USER_PATH ?= shortest_path
USER_FILE ?= shortest_path/adjustable_heap.h

OUT_DIR := ./out/$(USER_PATH)/${BUILD_MARK}
OBJ_DIR := $(OUT_DIR)/bin
INSTANCE_DIR := $(OUT_DIR)/instance

GPREGEL_INCLUDES := -I$(CORE_DIR) -I$(INSTANCE_DIR)
NVCC_FLAGS := -D $(LAMBDA_DEBUG_FLAGS) -m64 -O3 $(GENCODE_FLAGS) $(GENERAL_INCLUDES) $(GENERAL_LIBRARIES) $(GPREGEL_INCLUDES)

OBJS := \
	$(OBJ_DIR)/auxiliary_manager.o \
	$(OBJ_DIR)/cpu_algorithm.o \
	$(OBJ_DIR)/debug.o \
	$(OBJ_DIR)/edge_content_manager.o \
	$(OBJ_DIR)/file_reader.o \
	$(OBJ_DIR)/file_test_writer.o \
	$(OBJ_DIR)/global_manager.o \
	$(OBJ_DIR)/gpu_control_thread.o \
	$(OBJ_DIR)/gpu_control_thread_data_types.o \
	$(OBJ_DIR)/gpu_storage.o \
	$(OBJ_DIR)/graph_reader.o \
	$(OBJ_DIR)/graph_types.o \
	$(OBJ_DIR)/host_graph.o \
	$(OBJ_DIR)/host_hash_functions.o \
	$(OBJ_DIR)/init.o \
	$(OBJ_DIR)/main.o \
	$(OBJ_DIR)/message_content_manager.o \
	$(OBJ_DIR)/multiple_file_writer.o \
	$(OBJ_DIR)/multithreading.o \
	$(OBJ_DIR)/profiler.o \
	$(OBJ_DIR)/rand_util.o \
	$(OBJ_DIR)/rand_reader.o \
	$(OBJ_DIR)/rand_generator.o \
	$(OBJ_DIR)/rmat_generator.o \
	$(OBJ_DIR)/random_graph.o \
	$(OBJ_DIR)/random_graph_reader.o \
	$(OBJ_DIR)/reading_thread.o \
	$(OBJ_DIR)/reading_thread_data_types.o \
	$(OBJ_DIR)/rmat_reader.o \
	$(OBJ_DIR)/shared_data.o \
	$(OBJ_DIR)/simple_reader.o \
	$(OBJ_DIR)/single_file_writer.o \
	$(OBJ_DIR)/single_stream_writer.o \
	$(OBJ_DIR)/test_writer.o \
	$(OBJ_DIR)/util.o \
	$(OBJ_DIR)/vertex_content_manager.o \
	$(OBJ_DIR)/writer_types.o

build: prepare $(OBJS)
	$(NVCC) -lpthread $(NVCC_FLAGS) -o $(OUT_DIR)/main $(OBJS) /usr/local/lib/libgflags.a

prepare:
	mkdir -p $(OUT_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(INSTANCE_DIR)
	./compiler/gpregel.py \
		-d $(USER_PATH)/user_graph_data_types.h \
		-t $(TEMPLATE_DIR)/device_graph_data_types.h,$(TEMPLATE_DIR)/edge_content_manager.cu,$(TEMPLATE_DIR)/generated_io_data_types.h,$(TEMPLATE_DIR)/global_manager.cu,$(TEMPLATE_DIR)/host_graph_data_types.h,$(TEMPLATE_DIR)/host_in_graph_data_types.h,$(TEMPLATE_DIR)/host_out_graph_data_types.h,$(TEMPLATE_DIR)/message_content_manager.cu,$(TEMPLATE_DIR)/user_api.h,$(TEMPLATE_DIR)/vertex_content_manager.cu \
		-o $(INSTANCE_DIR)
	cp $(USER_PATH)/user_compute.h $(USER_PATH)/cpu_algorithm.cu $(USER_PATH)/result_compare.h $(USER_FILE) $(INSTANCE_DIR)
	# awk 'BEGIN { cmd="cp -i $(USER_PATH)/user_compute.h $(USER_PATH)/cpu_algorithm.cu $(USER_PATH)/result_compare.h $(USER_FILE) instance/"; print "n" | cmd; }'

$(OBJ_DIR)/%.o: $(CORE_DIR)/%.cc
	$(NVCC) $(NVCC_FLAGS) -c $< -o $(OBJ_DIR)/$*.o

$(OBJ_DIR)/%.o: $(CORE_DIR)/%.cu
	$(NVCC) $(NVCC_FLAGS) -c $< -o $(OBJ_DIR)/$*.o

$(OBJ_DIR)/%.o: $(INSTANCE_DIR)/%.cu
	$(NVCC) $(NVCC_FLAGS) -c $< -o $(OBJ_DIR)/$*.o

run: build
	$(OUT_DIR)/main \
		--num_gpus=4 \
		--max_superstep=$(MAX_SUPER_STEP) \
		--input_file= \
		--graph_type=simple \
		--hash_type=mod \
		--output_file=gpregelout \
		--writer_type=file_test \
		--rand_num_reading_threads=4 \
		--rand_num_vertex=51 \
		--rand_num_edge=399

# ---------------------------------------------- Build shortest path test ----------------------------------------------------
TEST_OUT_DIR := ./out/test/${BUILD_MARK}
TEST_OBJ_DIR := $(TEST_OUT_DIR)/obj
TEST_INSTANCE_DIR := $(TEST_OUT_DIR)/instance

TEST_GPREGEL_INCLUDES := -I$(CORE_DIR) -I$(TEST_INSTANCE_DIR)
TEST_NVCC_FLAGS := -D $(LAMBDA_DEBUG_FLAGS) -m64 -O3 $(GENCODE_FLAGS) $(GENERAL_INCLUDES) $(GENERAL_LIBRARIES) $(TEST_GPREGEL_INCLUDES)

TEST_OBJS := \
	$(TEST_OBJ_DIR)/auxiliary_manager.o \
	$(TEST_OBJ_DIR)/cpu_algorithm.o \
	$(TEST_OBJ_DIR)/debug.o \
	$(TEST_OBJ_DIR)/edge_content_manager.o \
	$(TEST_OBJ_DIR)/file_reader.o \
	$(TEST_OBJ_DIR)/file_test_writer.o \
	$(TEST_OBJ_DIR)/global_manager.o \
	$(TEST_OBJ_DIR)/gpu_control_thread.o \
	$(TEST_OBJ_DIR)/gpu_control_thread_data_types.o \
	$(TEST_OBJ_DIR)/gpu_storage.o \
	$(TEST_OBJ_DIR)/graph_reader.o \
	$(TEST_OBJ_DIR)/graph_types.o \
	$(TEST_OBJ_DIR)/host_graph.o \
	$(TEST_OBJ_DIR)/host_hash_functions.o \
	$(TEST_OBJ_DIR)/init.o \
	$(TEST_OBJ_DIR)/main.o \
	$(TEST_OBJ_DIR)/message_content_manager.o \
	$(TEST_OBJ_DIR)/multiple_file_writer.o \
	$(TEST_OBJ_DIR)/multithreading.o \
	$(TEST_OBJ_DIR)/profiler.o \
	$(TEST_OBJ_DIR)/rand_util.o \
	$(TEST_OBJ_DIR)/rand_reader.o \
	$(TEST_OBJ_DIR)/rand_generator.o \
	$(TEST_OBJ_DIR)/rmat_generator.o \
	$(TEST_OBJ_DIR)/random_graph.o \
	$(TEST_OBJ_DIR)/random_graph_reader.o \
	$(TEST_OBJ_DIR)/reading_thread.o \
	$(TEST_OBJ_DIR)/reading_thread_data_types.o \
	$(TEST_OBJ_DIR)/rmat_reader.o \
	$(TEST_OBJ_DIR)/shared_data.o \
	$(TEST_OBJ_DIR)/simple_reader.o \
	$(TEST_OBJ_DIR)/single_file_writer.o \
	$(TEST_OBJ_DIR)/single_stream_writer.o \
	$(TEST_OBJ_DIR)/test_writer.o \
	$(TEST_OBJ_DIR)/util.o \
	$(TEST_OBJ_DIR)/vertex_content_manager.o \
	$(TEST_OBJ_DIR)/writer_types.o

build_test: prepare_test $(TEST_OBJS)
	$(NVCC) -lpthread $(TEST_NVCC_FLAGS) -o $(TEST_OUT_DIR)/main $(TEST_OBJS) /usr/local/lib/libgflags.a

prepare_test:
	mkdir -p $(TEST_OUT_DIR)
	mkdir -p $(TEST_OBJ_DIR)
	mkdir -p $(TEST_INSTANCE_DIR)
	cp $(TEMPLATE_DIR)/* $(TEST_INSTANCE_DIR)
	cp $(DEBUG_INSTANCE_DIR)/* $(TEST_INSTANCE_DIR)
	# awk 'BEGIN { cmd="cp -i core/template/* instance/"; print "n" | cmd; }'
	# awk 'BEGIN { cmd="cp -i core/debug_instance/* instance/"; print "n" | cmd; }'

$(TEST_OBJ_DIR)/%.o: $(CORE_DIR)/%.cc
	$(NVCC) -D LAMBDA_TEST_SHORTEST_PATH $(TEST_NVCC_FLAGS) -c $< -o $(TEST_OBJ_DIR)/$*.o

$(TEST_OBJ_DIR)/%.o: $(CORE_DIR)/%.cu
	$(NVCC) -D LAMBDA_TEST_SHORTEST_PATH $(TEST_NVCC_FLAGS) -c $< -o $(TEST_OBJ_DIR)/$*.o

$(TEST_OBJ_DIR)/%.o: $(TEST_INSTANCE_DIR)/%.cu
	$(NVCC) -D LAMBDA_TEST_SHORTEST_PATH $(TEST_NVCC_FLAGS) -c $< -o $(TEST_OBJ_DIR)/$*.o

test: build_test
	$(TEST_OUT_DIR)/main \
		--num_gpus=4 \
		--max_superstep=$(MAX_SUPER_STEP) \
		--input_file= \
		--graph_type=simple \
		--hash_type=mod \
		--output_file=gpregelout \
		--writer_type=file_test \
		--rand_num_reading_threads=4 \
		--rand_num_vertex=71 \
		--rand_num_edge=399

#----------------------------------------------- Clean the objects and binaries -----------------------------------------------
clean:
	rm -rf $(OUT_DIR)/*
	rm -rf $(TEST_OUT_DIR)/*
