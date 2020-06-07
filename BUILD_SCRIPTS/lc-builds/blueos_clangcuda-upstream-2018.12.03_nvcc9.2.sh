#!/usr/bin/env bash

# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

BUILD_SUFFIX=lc_blueos-clangcuda-upstream-2018.12.03_nvcc-9.2

rm -rf build_${BUILD_SUFFIX} 2>/dev/null
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
  -C  ${DIR}/../host-configs/lc-builds/blueos/clangcuda_upstream_2018_12_03_nvcc_9_2.cmake \
  -DENABLE_OPENMP=Off \
  -DENABLE_CLANG_CUDA=On \
  -DBLT_CLANG_CUDA_ARCH=sm_60 \
  -DENABLE_CUDA=On \
  -DCUDA_ARCH=sm_60 \
  -DCUDA_TOOLKIT_ROOT_DIR=/usr/tce/packages/cuda/cuda-9.2.148 \
  -DCMAKE_INSTALL_PREFIX=../install_${BUILD_SUFFIX} \
  "$@" \
  ${DIR}/../../src
