#!/usr/bin/env bash

# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

##
## Execute these commands before running this script to build HYPRE.
##
## First grab a node to compile and run your code:
##
## > qsub -I -n 1 -A <your_project> -t <# minutes> -q debug
##
## Then set up your build environment.
##
##  > soft add +cmake-3.9.1
##  > soft add +clang-5.0
##

BUILD_SUFFIX=alcf-cooley-clang5.0

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
  -C  ${DIR}/../host-configs/alcf-builds/cooley_clang5_0.cmake \
  -DHYPRE_BUILD_TESTS=On \
 -DENABLE_MPI=On \
 -DENABLE_OPENMP=On \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
 -DCMAKE_VERBOSE_MAKEFILE=On \
  -DCMAKE_INSTALL_PREFIX=../install_${BUILD_SUFFIX} \
  "$@" \
  ${DIR}/../../src
