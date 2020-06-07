# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_XLC" CACHE STRING "")

set(CMAKE_CXX_FLAGS_RELEASE "-O3 -qxlcompatmacros -qlanglvl=extended0x -qalias=noansi -qsmp=omp -qhot -qnoeh -qsuppress=1500-029 -qsuppress=1500-036" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -qxlcompatmacros -qlanglvl=extended0x -qalias=noansi -qsmp=omp -qhot -qnoeh -qsuppress=1500-029 -qsuppress=1500-036" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -qsmp=omp:noopt " CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-z,muldefs" CACHE STRING "")

# Suppressed XLC warnings:
# - 1500-029 cannot inline
# - 1500-036 nostrict optimizations may alter code semantics
#   (can be countered with -qstrict, with less optimization)

set(HYPRE_RANGE_ALIGN 4 CACHE STRING "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE STRING "")
set(HYPRE_DATA_ALIGN 64 CACHE STRING "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE BOOL "")

