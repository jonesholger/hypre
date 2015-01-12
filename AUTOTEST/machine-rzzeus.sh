#!/bin/sh
#BHEADER**********************************************************************
# Copyright (c) 2008,  Lawrence Livermore National Security, LLC.
# Produced at the Lawrence Livermore National Laboratory.
# This file is part of HYPRE.  See file COPYRIGHT for details.
#
# HYPRE is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License (as published by the Free
# Software Foundation) version 2.1 dated February 1999.
#
# $Revision$
#EHEADER**********************************************************************

testname=`basename $0 .sh`

# Echo usage information
case $1 in
   -h|-help)
      cat <<EOF

   **** Only run this script on the zeus cluster ****

   $0 [-h|-help] {src_dir}

   where: -h|-help   prints this usage information and exits
          {src_dir}  is the hypre source directory

      This script runs a number of tests suitable for the zeus cluster.

      Example usage: $0 ..

EOF
      exit
      ;;
esac

# Setup
test_dir=`pwd`
output_dir=`pwd`/$testname.dir
rm -fr $output_dir
mkdir -p $output_dir
src_dir=$1
shift

# Default test (and default options used below)
tdir="$output_dir/test"
co=""
mo="test"
ro="-ij -sstruct -struct -rt -D HYPRE_NO_SAVED"
test.sh basictest.sh $src_dir $tdir -co: $co -mo: $mo -ro: $ro

tdir="$output_dir/test--enable-debug"
co="--enable-debug"
test.sh basictest.sh $src_dir $tdir -co: $co -mo: $mo

tdir="$output_dir/test--enable-bigint"
co="--enable-bigint"
test.sh basictest.sh $src_dir $tdir -co: $co -mo: $mo

tdir="$output_dir/test--with-blas"
co="--with-blas --with-lapack --with-blas-lib-dirs=/usr/lib64 --with-lapack-lib-dirs=/usr/lib64 --with-blas-libs=blas --with-lapack-libs=lapack"
test.sh basictest.sh $src_dir $tdir -co: $co -mo: $mo

# Test linking for different languages
link_opts="all++ all77"
for opt in $link_opts
do
   output_subdir=$output_dir/link$opt
   mkdir -p $output_subdir
   ./test.sh link.sh $src_dir $opt
   mv -f link.??? $output_subdir
done

# Echo to stderr all nonempty error files in $output_dir
for errfile in $( find $output_dir ! -size 0 -name "*.err" )
do
   echo $errfile >&2
done
