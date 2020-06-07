# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_GNU" CACHE STRING "")

set(CMAKE_CXX_COMPILER "/soft/compilers/gcc/7.1.0/bin/g++" CACHE PATH "")
set(CMAKE_C_COMPILER "/soft/compilers/gcc/7.1.0/bin/gcc" CACHE PATH "")

set(CMAKE_CXX_FLAGS_RELEASE "-Ofast -finline-functions -finline-limit=20000" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Ofast -g -finline-functions -finline-limit=20000" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g" CACHE STRING "")

set(HYPRE_RANGE_ALIGN 4 CACHE INT "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE INT "")
set(HYPRE_DATA_ALIGN 64 CACHE INT "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE Bool "")
