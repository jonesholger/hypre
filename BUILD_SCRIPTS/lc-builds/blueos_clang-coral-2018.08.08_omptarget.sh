#!/usr/bin/env bash

# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

BUILD_SUFFIX=lc_blueos-clang-coral-2018.08.08_omptarget

rm -rf build_${BUILD_SUFFIX} >/dev/null
mkdir build_${BUILD_SUFFIX} && cd build_${BUILD_SUFFIX}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

module load cmake/3.14.5

## NOTE: HYPRE tests are turned off due to compilation issues.

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=/usr/tce/packages/clang/clang-coral-2018.08.08/bin/clang++ \
  -C  ${DIR}/../host-configs/lc-builds/blueos/clang_X.cmake \
  -DHYPRE_BUILD_TESTS=On \
  -DENABLE_MPI=On \
  -DENABLE_OPENMP=On \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_VERBOSE_MAKEFILE=On \
  -DENABLE_CUDA=Off \
  -DENABLE_TARGET_OPENMP=On \
  -DOpenMP_CXX_FLAGS="-fopenmp;-fopenmp-targets=nvptx64-nvidia-cuda;-fopenmp-implicit-declare-target" \
  -DENABLE_ALL_WARNINGS=Off \
  -DCMAKE_INSTALL_PREFIX=../install_${BUILD_SUFFIX} \
  "$@" \
  ${DIR}/../../src
