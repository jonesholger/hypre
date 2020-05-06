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

set(TEST_DEPENDS HYPRE)
list(APPEND TEST_DEPENDS ${HYPRE_DEPENDS})
message(STATUS "Test Apps depend on: ${TEST_DEPENDS}")

# do the following until we establish a macro call
foreach(SRC IN LISTS TEST_SRCS)
   string(REPLACE ".c" "" EXE_NAME ${SRC})

   blt_add_executable(
      NAME ${EXE_NAME}
      SOURCES ${SRC}
      DEPENDS_ON
      ${TEST_DEPENDS})

   # edit this eventually to use parent scope libraries list
   if(HYPRE_USING_CUDA)
      target_link_libraries(
         ${EXE_NAME} PRIVATE 
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcusparse_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcurand_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libculibos.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublas_static.a
         ${CUDA_TOOLKIT_ROOT_DIR}/lib64/libcublasLt_static.a
      )
   else ()
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

