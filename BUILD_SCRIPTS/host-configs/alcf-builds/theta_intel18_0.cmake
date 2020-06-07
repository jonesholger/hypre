# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HYPRE_COMPILER "HYPRE_COMPILER_ICC" CACHE STRING "")

set (CMAKE_CXX_STANDARD 11)

set(CMAKE_CXX_COMPILER "/opt/intel/compilers_and_libraries_2018.0.128/linux/bin/intel64/icpc" CACHE PATH "")
set(CMAKE_C_COMPILER "/opt/intel/compilers_and_libraries_2018.0.128/linux/bin/intel64/icc" CACHE PATH "")

set(CMAKE_CXX_FLAGS_RELEASE "${COMMON_FLAGS} -O3 -unroll-aggressive -finline-functions -xMIC-AVX512" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${COMMON_FLAGS} -O3 -g -unroll-aggressive -finline-functions -xMIC-AVX512" CACHE STRING "")
set(CMAKE_CXX_FLAGS_DEBUG "${COMMON_FLAGS} -O0 -g" CACHE STRING "")

set(HYPRE_RANGE_ALIGN 4 CACHE INT "")
set(HYPRE_RANGE_MIN_LENGTH 32 CACHE INT "")
set(HYPRE_DATA_ALIGN 64 CACHE INT "")

set(HYPRE_HOST_CONFIG_LOADED On CACHE Bool "")
