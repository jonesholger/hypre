#!/usr/bin/env bash

# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

BUILD_SUFFIX=lc_blueos-nvcc10-clang7.1.0

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

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=/usr/tce/packages/clang/clang-7.1.0/bin/clang++ \
  -C  ${DIR}/../host-configs/lc-builds/blueos/nvcc_clang_X.cmake \
  -DHYPRE_BUILD_TESTS=On \
  -DENABLE_MPI=On \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_VERBOSE_MAKEFILE=On \
  -DENABLE_CUDA=On \
  -DENABLE_OPENMP=Off \
  -DCUDA_TOOLKIT_ROOT_DIR=/usr/tce/packages/cuda/cuda-10.1.243 \
  -DCMAKE_CUDA_COMPILER=/usr/tce/packages/cuda/cuda-10.1.243/bin/nvcc \
  -DCUDA_ARCH=sm_70 \
  -DCMAKE_INSTALL_PREFIX=../install_${BUILD_SUFFIX} \
  "$@" \
  ${DIR}/../../src
