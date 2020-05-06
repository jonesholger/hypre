# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

set(HDRS
  HYPRE_seq_mv.h
  seq_mv.h
)

set(SRCS
  csr_matop.c
  csr_matrix.c
  csr_matvec.c
  csr_matvec_device.c
  genpart.c
  HYPRE_csr_matrix.c
  HYPRE_mapped_matrix.c
  HYPRE_multiblock_matrix.c
  HYPRE_vector.c
  mapped_matrix.c
  multiblock_matrix.c
  vector.c
  vector_batched.c
)

#target_sources(HYPRE
#  PRIVATE ${SRCS}
#          ${HDRS}
#  )

if(HYPRE_USING_CUDA)
   set(HDRS ${HDRS}
      csr_spgemm_device.h
      )
   set(SRCS ${SRCS}
      csr_matop_device.c
      csr_spadd_device.c
      csr_spgemm_device.c
      csr_sptrans_device.c
      csr_spgemm_device_attempt.c
      csr_spgemm_device_confident.c
      csr_spgemm_device_cusparse.c
      csr_spgemm_device_rowbound.c
      csr_spgemm_device_rowest.c
      csr_spgemm_device_util.c
      )
endif ()

convert_filenames_to_full_paths(HDRS)
convert_filenames_to_full_paths(SRCS)
set(HYPRE_HEADERS ${HYPRE_HEADERS} ${HDRS} PARENT_SCOPE)
set(HYPRE_SOURCES ${HYPRE_SOURCES} ${SRCS} PARENT_SCOPE)
