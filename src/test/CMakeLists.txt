# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

add_definitions (-DHYPRE_TIMING)

if (MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif ()

set(TEST_SRCS
  ij.c
  sstruct.c
  struct.c
  ams_driver.c
  maxwell_unscaled.c
  struct_migrate.c
  sstruct_fac.c
  ij_mv.c
)

# add_hypre_executables(TEST_SRCS)   
cmake_minimum_required(VERSION 3.13)
set(BLT_CXX_STD "c++14" CACHE STRING "Version of C++ standard")
set(HYPRE_USING_CUDA_DEFINE "")
set(HYPRE_USING_CUBLAS_DEFINE "")
set(MEMORY_DEFINE "")
set(CUDA_INCLUDE_DIR "")
set(depends HYPRE)

if(HAVE_CUDA)
   list(APPEND depends cuda)
   set(CUDA_INCLUDE_DIR   ${CUDA_TOOLKIT_ROOT_DIR}/include)
   # we'll pickup defines from the parent scope; but external apps will need these
   set(HYPRE_USING_CUDA_DEFINE "HYPRE_USING_CUDA")
   set(MEMORY_DEFINE "HYPRE_USING_UNIFIED_MEMORY")
endif ()

message(STATUS "test apps depend on: ${depends}")

# do the following until we establish a macro call
foreach(SRC IN LISTS TEST_SRCS)
   string(REPLACE ".c" "" EXE_NAME ${SRC})

   blt_add_executable(
      NAME ${EXE_NAME}
      SOURCES ${SRC}
      INCLUDES 
        ${PROJECT_SOURCE_DIR}
        ${CUDA_INCLUDE_DIR}
        #  defines are already established in parent scope
        #  just a reminder that external apps will need these
        #DEFINES 
        #${HYPRE_USING_CUDA_DEFINE}
        #${HYPRE_USING_CUBLAS_DEFINE}
        #${MEMORY_DEFINE}
      DEPENDS_ON
        ${depends})

   if(HAVE_CUDA)
      target_link_libraries(
         ${EXE_NAME} PRIVATE 
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcusparse_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcurand_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libculibos.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublas_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublasLt_static.a
      )
   endif ()

   #otherwise we're building with mpicc so we need -lm
   if(NOT HAVE_CUDA)
      target_link_libraries(
         ${EXE_NAME} PRIVATE
         m)
   endif ()   
endforeach()      

# later create macros for each executable, 
# wrapped in switchyard, invoked in foreach above
blt_add_test(NAME ij_1
   COMMAND ij -pmis -Pmx 0 -rlx 0 -xisone
   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
   NUM_MPI_TASKS 1)

blt_add_test(NAME ij_2
   COMMAND ij -P 1 1 2 -pmis1 -Pmx 0 -rlx 0 -xisone
   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
   NUM_MPI_TASKS 2)

blt_add_test(NAME ij_3
   COMMAND ij -P 1 1 3 -pmis1 -Pmx 0 -rlx 0 -xisone
   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
   NUM_MPI_TASKS 3)

