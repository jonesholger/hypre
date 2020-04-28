# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

add_definitions (-DHYPRE_TIMING)

if (MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif ()

#set(TEST_SRCS
#  ij.c
#  sstruct.c
#  struct.c
#  ams_driver.c
#  maxwell_unscaled.c
#  struct_migrate.c
#  sstruct_fac.c
#  ij_mv.c
#)

# add_hypre_executables(TEST_SRCS)
cmake_minimum_required(VERSION 3.13)

#project(test_laplacexy_hypre LANGUAGES CXX C)

set(BLT_CXX_STD "c++14" CACHE STRING "Version of C++ standard")

set(test_ij_hypre_sources
   ij.c
)

set(test_ij_hypre_depends HYPRE)

set(HYPRE_USING_CUDA_DEFINE "")
set(HYPRE_USING_CUBLAS_DEFINE "")
set(MEMORY_DEFINE "")
if(HAVE_CUDA)
   list(APPEND test_ij_hypre_depends cuda)
   set(HYPRE_USING_CUDA_DEFINE "HYPRE_USING_CUDA")
   set(MEMORY_DEFINE "HYPRE_USING_UNIFIED_MEMORY")
   set(HYPRE_USING_CUBLAS_DEFINE "HYPRE_USING_CUBLAS")
endif ()

message(STATUS "CUDA_TOOLKIT_ROOT_DIR : ${CUDA_TOOLKIT_ROOT_DIR}")
message(STATUS "test_ij_hypre_depends: ${test_ij_hypre_depends}")
blt_add_executable(
   NAME test_ij_hypre
   SOURCES ${test_ij_hypre_sources}
   INCLUDES 
     ${PROJECT_SOURCE_DIR}
     ${CUDA_TOOLKIT_ROOT_DIR}/include
   DEFINES 
      ${HYPRE_USING_CUDA_DEFINE}
      ${HYPRE_USING_CUBLAS_DEFINE}
      ${MEMORY_DEFINE}
   DEPENDS_ON
     ${test_ij_hypre_depends})

# Headers and sources: remaining subdirectories
set(HYPRE_DIRS utilities multivector krylov seq_mv parcsr_mv parcsr_block_mv distributed_matrix IJ_mv matrix_matrix distributed_ls parcsr_ls struct_mv struct_ls sstruct_mv sstruct_ls)
foreach(DIR IN LISTS HYPRE_DIRS)
   #add_subdirectory(${DIR})
  target_include_directories(test_ij_hypre PUBLIC
     $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/${DIR}>)
endforeach()


target_link_libraries(
   test_ij_hypre PUBLIC 
   ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcusparse_static.a
   ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcurand_static.a
   ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libculibos.a
   ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublas_static.a
   ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublasLt_static.a
)

 
