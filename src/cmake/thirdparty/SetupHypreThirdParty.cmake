set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake/thirdparty/")

# MPI is setup by BLT
if (MPI_FOUND)
  set(HAVE_MPI True)
else ()
  set(LACKS_MPI True)
endif ()

# OpenMP is set up by BLT
if (ENABLE_OPENMP)
  if (OPENMP_FOUND)
    set(HAVE_OPENMP True)
  endif ()
endif ()

# CUDA is setup by BLT
if (ENABLE_CUDA)
  if (CUDA_FOUND)
     message(STATUS "CUDA FOUND")
     set (HYPRE_USING_CUDA True)
     set (HYPRE_USING_UNIFIED_MEMORY True)
  endif ()
endif ()

# UMPIRE
if (ENABLE_UMPIRE)
  find_package(umpire REQUIRED)

  set (HAVE_UMPIRE True)
  message(STATUS "UMPIRE_INCLUDE_DIRS ${UMPIRE_INCLUDE_DIRS}" ) 

  blt_register_library(
    NAME umpire
    INCLUDES ${UMPIRE_INCLUDE_DIRS}
    LIBRARIES umpire)
endif ()

# RAJA
if (ENABLE_RAJA)
   #if (NOT ENABLE_UMPIRE)
   # message(FATAL_ERROR "RAJA support requires UMPIRE.")
   #endif ()

  find_package(RAJA REQUIRED)

  set (raja_depends_on)
  if (ENABLE_CUDA)
    list (APPEND raja_depends cuda)
  endif ()

  if (ENABLE_OPENMP)
    list (APPEND raja_depends openmp)
  endif ()

  if (RAJA_FOUND)
    set (HYPRE_USING_RAJA True)
    blt_register_library(
      NAME RAJA
      INCLUDES ${RAJA_INCLUDE_DIR}
      LIBRARIES RAJA
      DEPENDS_ON ${raja_depends})
  endif ()
endif ()

# OpenMP
if (ENABLE_OPENMP)
  if (OPENMP_FOUND)
    set(HAVE_OPENMP True)
  endif ()
endif ()

#HAVE_SILO
if (ENABLE_SILO OR SILO_DIR)
  find_package(SILO REQUIRED)

  if (SILO_FOUND)
    set (HAVE_SILO True)
    set (ENABLE_SILO ON)

    blt_register_library(
      NAME silo
      INCLUDES ${SILO_INCLUDE_DIRS}
      LIBRARIES ${SILO_LIBRARIES})
  endif ()
endif ()


#HAVE_SUNDIALS
if (ENABLE_SUNDIALS OR SUNDIALS_DIR)
  find_package(SUNDIALS REQUIRED)
  if (SUNDIALS_FOUND)
    set (HAVE_SUNDIALS True)
    set (ENABLE_SUNDIALS ON)

    blt_register_library(
      NAME SUNDIALS
      INCLUDES ${SUNDIALS_INCLUDE_DIRS}
      LIBRARIES ${SUNDIALS_LIBRARIES})
  endif ()
endif ()


#HAVE_CONDUIT
if (ENABLE_CONDUIT OR CONDUIT_DIR)
  find_package(CONDUIT REQUIRED)
  if (CONDUIT_FOUND)
    set (HAVE_CONDUIT True)
    set (ENABLE_CONDUIT ON)

    blt_register_library(
      NAME CONDUIT
      INCLUDES ${CONDUIT_INCLUDE_DIRS}
      LIBRARIES ${CONDUIT_LIBRARIES})
  endif ()
endif ()
