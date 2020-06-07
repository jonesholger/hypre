#!/usr/bin/env bash

# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

BUILD_SUFFIX=lc_corona-hipcc

rm -rf build_${BUILD_SUFFIX} >/dev/null
mkdir build_${BUILD_SUFFIX} && cd build_${BUILD_SUFFIX}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

#============= For LC Corona ONLY =============
export PATH=/usr/workspace/wsb/raja-dev/opt/hip-clang/bin:$PATH
export HIP_CLANG_PATH=/usr/workspace/wsb/raja-dev/opt/llvm/bin
export DEVICE_LIB_PATH=/usr/workspace/wsb/raja-dev/opt/lib
export HCC_AMDGPU_TARGET=gfx900
module load opt
module load dts/7.1
module load rocm
#==============================================

module load cmake/3.14.5

cmake \
  -C  ${DIR}/../host-configs/hip.cmake \
  ${DIR}/../../src

