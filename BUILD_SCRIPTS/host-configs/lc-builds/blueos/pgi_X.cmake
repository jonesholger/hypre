# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_PGI" CACHE STRING "")

set(CMAKE_CXX_FLAGS_RELEASE "-O3 -fast -mp" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-fast -g -mp" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -mp" CACHE STRING "")

set(HYPRE_RANGE_ALIGN 4 CACHE STRING "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE STRING "")
set(HYPRE_DATA_ALIGN 64 CACHE STRING "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE BOOL "")
