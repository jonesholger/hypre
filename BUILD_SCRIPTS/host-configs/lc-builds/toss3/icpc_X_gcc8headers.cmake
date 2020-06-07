# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_ICC" CACHE STRING "")

set(COMMON_FLAGS "-gxx-name=/usr/tce/packages/gcc/gcc-8.1.0/bin/g++")

set(CMAKE_CXX_FLAGS_RELEASE "${COMMON_FLAGS} -O3 -march=native -ansi-alias -axCORE-AVX2 -diag-disable cpu-dispatch" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${COMMON_FLAGS} -O3 -g -march=native -ansi-alias -axCORE-AVX2 -diag-disable cpu-dispatch" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "${COMMON_FLAGS} -O0 -g" CACHE STRING "")

set(HYPRE_RANGE_ALIGN 4 CACHE STRING "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE STRING "")
set(HYPRE_DATA_ALIGN 64 CACHE STRING "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE BOOL "")
