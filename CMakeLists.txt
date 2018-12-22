# cmake -DCMAKE_PREFIX_PATH=$HOME/usr/local ..

CMAKE_MINIMUM_REQUIRED(VERSION 3.5)
SET(target hello)

# SET(CMAKE_BUILD_TYPE debug)
SET(CMAKE_BUILD_TYPE release)
SET(CMAKE_CXX_STANDARD 14)

INCLUDE(${CMAKE_SOURCE_DIR}/cmake/Cuda.cmake)

# External projects
configure_file(CMakeLists.txt.in download/CMakeLists.txt)
execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
	WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/download" )
execute_process(COMMAND "${CMAKE_COMMAND}" --build .
	WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/download" )

# Find glog and gflags libraries specifically
find_path(GLOG_INCLUDE_DIR glog/logging.h)
find_path(GFLAGS_INCLUDE_DIR gflags/gflags.h)

find_library(GLOG_LIBRARY glog)
find_library(GFLAGS_LIBRARY gflags)

message("gflags include_dir <${GFLAGS_INCLUDE_DIR}> lib <${GFLAGS_LIBRARY}>")
message("glog include_dir <${GLOG_INCLUDE_DIR}> lib <${GLOG_LIBRARY}>")

INCLUDE_DIRECTORIES(
	${CMAKE_SOURCE_DIR}
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_BINARY_DIR}/external/include
	${GFLAGS_INCLUDE_DIR}
	${GLOG_INCLUDE_DIR}
	${USR_DIR}/include
	${CUDA_TOOLKIT_ROOT_DIR}/include #THRUST LIBRARY!
	${CUDA_TOOLKIT_ROOT_DIR}/samples/common/inc
	)

LINK_DIRECTORIES(
	${CMAKE_BINARY_DIR}
	${CMAKE_BINARY_DIR}/src
	${CUDA_TOOLKIT_ROOT_DIR}/lib64
	${CMAKE_BINARY_DIR}/external/lib
	)

# Common configuration for all build modes.
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
SET(EXTRA_CXX_FLAGS ${EXTRA_CXX_FLAGS} -Werror)

find_package(OpenMP)
if (OPENMP_FOUND)
	set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
	set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
	set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

IF("${BUILD_TYPE_LOWER}" MATCHES "debug")
	MESSAGE("debug mode was set")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unreachable-code")
ELSE()
	MESSAGE("release mode was set")
ENDIF()


SET(CUDA_NVCC_FLAGS
	${CUDA_NVCC_FLAGS};
	-std=c++11
	-O3 -lineinfo
	)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")

CUDA_ADD_EXECUTABLE(${target} main.cu
	OPTIONS
	DEBUG -g --disable-warnings)

TARGET_LINK_LIBRARIES( ${target}
	gtest
	gmock
	benchmark
	${GLOG_LIBRARY}
	${GFLAGS_LIBRARY}
	${CUDA_curand_LIBRARY}
	)

