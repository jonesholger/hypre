#!/usr/bin/env bash
# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

# assumes g++ and cmake is in your environment path
arch=$(uname -m)
version=$(g++ -dumpversion)
BUILD_SUFFIX=gcc-${version}-${arch}

rm -rf build_${BUILD_SUFFIX} 2>/dev/null
mkdir build_${BUILD_SUFFIX} && cd build_${BUILD_SUFFIX}

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=g++ \
  -C ${DIR}/../host-configs/lc-builds/toss3/gcc_X.cmake \
  -DHYPRE_BUILD_TESTS=On \
  -DENABLE_MPI=On \
  -DHYPRE_BUILD_TESTS=On \
  -DENABLE_OPENMP=On \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
  -DCMAKE_VERBOSE_MAKEFILE=On \
  -DCMAKE_INSTALL_PREFIX=../install_${BUILD_SUFFIX} \
  "$@" \
  ${DIR}/../../src
