# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_CLANG" CACHE STRING "")

set(CMAKE_CXX_COMPILER "/usr/tce/packages/clang/clang-upstream-2018.12.03/ibm/bin/clang++" CACHE PATH "")
set(CMAKE_C_COMPILER "/usr/tce/packages/clang/clang-upstream-2018.12.03/ibm/bin/clang" CACHE PATH "")

set(CMAKE_EXE_LINKER_FLAGS "-L/usr/tce/packages/cuda/cuda-9.2.148/lib64 -lcudart_static -lcudadevrt -lrt -ldl -lnvToolsExt -pthread -Wl,-rpath=/usr/tce/packages/clang/clang-upstream-2018.12.03/ibm/lib" CACHE PATH "")

set(CMAKE_CXX_FLAGS_RELEASE "-O3" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g" CACHE STRING "")

set(HYPRE_RANGE_ALIGN 4 CACHE STRING "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE STRING "")
set(HYPRE_DATA_ALIGN 64 CACHE STRING "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE BOOL "")
