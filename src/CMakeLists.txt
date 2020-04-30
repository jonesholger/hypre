# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

cmake_minimum_required (VERSION 3.13...3.16)

if(${CMAKE_VERSION} VERSION_LESS 3.16)
  cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
else()
  cmake_policy(VERSION 3.16)
endif()

# The version number.
set (HYPRE_VERSION 2.18.2)
set (HYPRE_DATE    2019/10/28)
set (HYPRE_TIME    00:00:00)
set (HYPRE_BUGS    hypre-support@llnl.gov)
set (HYPRE_SRCDIR  "${PROJECT_SOURCE_DIR}")

project (hypre
  VERSION ${HYPRE_VERSION}
    LANGUAGES C CXX)



#------------------------------------------------------------------------------
# Initialize BLT build system
#------------------------------------------------------------------------------
if (DEFINED BLT_SOURCE_DIR)

    # Support a shared BLT outside of the repository if given a BLT_SOURCE_DIR
    if (NOT EXISTS ${BLT_SOURCE_DIR}/SetupBLT.cmake)
        message(FATAL_ERROR "Cannot find SetupBLT.cmake in [${BLT_SOURCE_DIR}]")
    endif()

else()

    # Use internal 'blt' submodule path if BLT_SOURCE_DIR not provided
    set(BLT_SOURCE_DIR "${PROJECT_SOURCE_DIR}/blt" CACHE PATH "")
    if (NOT EXISTS ${BLT_SOURCE_DIR}/SetupBLT.cmake)
         message(FATAL_ERROR "The BLT submodule is not present. \
                  If in the git repository, please run the following commands:\n \
                  git submodule init\n \
                  git submodule update")
    endif()

endif()

message(STATUS "BLT : ${BLT_SOURCE_DIR} ")
# BLT Options need to be set in the CACHE
set(ENABLE_FORTRAN Off CACHE STRING "Enable Fortran")
set(ENABLE_OPENMP On CACHE STRING "Enable OpenMP")
set(ENABLE_CUDA Off CACHE STRING "Enable CUDA")
set(ENABLE_MPI On CACHE STRING "Enable MPI.")
set(ENABLE_TESTS On CACHE STRING "Enable Tests.")
set(ENABLE_DOCS Off CACHE STRING "Enable Docs.")
set(BLT_CXX_STD "c++14" CACHE STRING "Version of C++ standard")
set(gtest_disable_pthreads ON CACHE STRING "")
option(ENABLE_UMPIRE "Enable UMPIRE memory management" Off)
option(ENABLE_RAJA "Enable RAJA" Off)

include(${BLT_SOURCE_DIR}/SetupBLT.cmake)

include_directories(${CMAKE_BINARY_DIR}/include)

include(cmake/CMakeBasics.cmake)

if (${hypre_SOURCE_DIR} STREQUAL ${hypre_BINARY_DIR})
  message(FATAL_ERROR "In-place build not allowed! Please use a separate build directory. See the Users Manual or INSTALL file for details.")
endif ()

# Set cmake module path
set(CMAKE_MODULE_PATH "${hypre_SOURCE_DIR}/config/cmake" "${CMAKE_MODULE_PATH}")
include(hypre_CMakeUtilities)

# Set default installation directory, but provide a means for users to change
set (HYPRE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/hypre" CACHE PATH
    "Installation directory for HYPRE")
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set (CMAKE_INSTALL_PREFIX "${HYPRE_INSTALL_PREFIX}" CACHE INTERNAL "" FORCE)
endif ()

# Set default compile optimization flag
set (HYPRE_BUILD_TYPE "Release" CACHE STRING
    "Optimization flags: set to Debug, Release, RelWithDebInfo, or MinSizeRel")

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set (CMAKE_BUILD_TYPE "${HYPRE_BUILD_TYPE}" CACHE INTERNAL "" FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif ()

# Configuration options
option(HYPRE_ENABLE_SHARED           "Build a shared library" OFF)
option(HYPRE_ENABLE_BIGINT           "Use long long int for HYPRE_Int" OFF)
option(HYPRE_ENABLE_MIXEDINT         "Use long long int for HYPRE_BigInt, int for HYPRE_INT" OFF)
option(HYPRE_ENABLE_SINGLE           "Use float for HYPRE_Real" OFF)
option(HYPRE_ENABLE_LONG_DOUBLE      "Use long double for HYPRE_Real" OFF)
option(HYPRE_ENABLE_COMPLEX          "Use complex values" OFF)
option(HYPRE_ENABLE_HYPRE_BLAS       "Use internal BLAS library" ON)
option(HYPRE_ENABLE_HYPRE_LAPACK     "Use internal LAPACK library" ON)
option(HYPRE_ENABLE_PERSISTENT_COMM  "Use persistent communication" OFF)
option(HYPRE_ENABLE_GLOBAL_PARTITION "Use global partitioning" OFF)
option(HYPRE_ENABLE_FEI              "Use FEI" OFF) # TODO: Add this cmake feature
option(HYPRE_WITH_MPI                "Compile with MPI" ON)
option(HYPRE_WITH_OPENMP             "Use OpenMP" OFF)
option(HYPRE_WITH_HOPSCOTCH          "Use hopscotch hashing with OpenMP" OFF)
option(HYPRE_WITH_DSUPERLU           "Use TPL SuperLU_Dist" OFF)
option(HYPRE_WITH_CALIPER            "Use Caliper" OFF)  # TODO: Finish this cmake feature
option(HYPRE_PRINT_ERRORS            "Print HYPRE errors" OFF)
option(HYPRE_TIMING                  "Use HYPRE timing routines" OFF)
option(HYPRE_BUILD_EXAMPLES          "Build examples" OFF)
option(HYPRE_BUILD_TESTS             "Build tests" OFF)
option(HYPRE_USING_HOST_MEMORY       "Use host memory" ON)

option(TPL_DSUPERLU_LIBRARIES        "List of absolute paths to SuperLU_Dist link libraries [].")
option(TPL_DSUPERLU_INCLUDE_DIRS     "List of absolute paths to SuperLU_Dist include directories [].")

# Set config name values
if (HYPRE_ENABLE_SHARED)
  set(HYPRE_SHARED ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_BIGINT)
  set(HYPRE_BIGINT ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_MIXEDINT)
  set(HYPRE_MIXEDINT ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_SINGLE)
  set(HYPRE_SINGLE ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_LONG_DOUBLE)
  set(HYPRE_LONG_DOUBLE ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_COMPLEX)
  set(HYPRE_COMPLEX ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_HYPRE_BLAS)
  set(HYPRE_USING_HYPRE_BLAS ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_HYPRE_LAPACK)
  set(HYPRE_USING_HYPRE_LAPACK ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_PERSISTENT_COMM)
  set(HYPRE_USING_PERSISTENT_COMM ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_GLOBAL_PARTITION)
  set(HYPRE_NO_GLOBAL_PARTITION OFF CACHE BOOL "" FORCE)
else()
  set(HYPRE_NO_GLOBAL_PARTITION ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_WITH_MPI)
  set(HYPRE_SEQUENTIAL OFF CACHE BOOL "" FORCE)
else()
  set(HYPRE_SEQUENTIAL ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_WITH_OPENMP)
  set (HYPRE_USING_OPENMP ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_WITH_HOPSCOTCH)
  set (HYPRE_HOPSCOTCH ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_WITH_DSUPERLU)
  set (HYPRE_USING_DSUPERLU ON CACHE BOOL "" FORCE)
  set (HYPRE_USING_HYPRE_BLAS OFF CACHE BOOL "" FORCE)
  set (HYPRE_USING_HYPRE_LAPACK OFF CACHE BOOL "" FORCE)
endif()

if (HYPRE_ENABLE_FEI)
  set (HYPRE_USING_FEI ON CACHE BOOL "" FORCE)
  message(WARNING "CMake support for FEI is not complete!")
endif()

if (HYPRE_WITH_CALIPER)
  set (HYPRE_USING_CALIPER ON CACHE BOOL "" FORCE)
endif()

if (HYPRE_SHARED OR HYPRE_BIGINT OR HYPRE_SINGLE OR HYPRE_LONG_DOUBLE)
  # FEI doesn't currently compile with shared
  set (HYPRE_USING_FEI OFF CACHE BOOL "" FORCE)
endif ()

if (HYPRE_SEQUENTIAL)
  set (HYPRE_NO_GLOBAL_PARTITION OFF CACHE BOOL "" FORCE)
  set (HYPRE_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
endif ()


set (HYPRE_DEPENDS "")
if (ENABLE_OPENMP)
   list(APPEND HYPRE_DEPENDS openmp)
endif ()

if (ENABLE_CUDA)
   set_source_files_properties(${cuda_sources} PROPERTIES LANGUAGE CUDA)

   if (ENABLE_NVTX_REGIONS)
      find_package(CUDA REQUIRED)

      find_library(NVTX_LIBRARY
         NAME libnvToolsExt.so
         PATHS ${CUDA_TOOLKIT_ROOT_DIR}/lib64 ${CUDA_TOOLKIT_ROOT_DIR}/lib)

      message(STATUS "NVidia tools extension library found in " ${NVTX_LIBRARY})
      blt_register_library(
      NAME nvToolsExt
      LIBRARIES ${NVTX_LIBRARY})

      list(APPEND HYPRE_DEPENDS nvToolsExt)
      message(STATUS "Enable NVTX Regions Detected")
   endif ()
   if (CUDA_FOUND)
      set (HAVE_CUDA True)
   endif ()
   list(APPEND HYPRE_DEPENDS cuda)
endif()

# UMPIRE
if (ENABLE_UMPIRE)
  find_package(umpire REQUIRED)

  set (HAVE_UMPIRE True)

  blt_register_library(
    NAME umpire
    INCLUDES ${UMPIRE_INCLUDE_DIRS}
    LIBRARIES umpire)
 list(APPEND HYPRE_DEPENDS umpire)
endif ()

# RAJA
if (ENABLE_RAJA)
  find_package(RAJA REQUIRED)

  set (raja_depends_on)
  if (ENABLE_CUDA)
    list (APPEND raja_depends cuda)
  endif ()

  if (ENABLE_OPENMP)
    list (APPEND raja_depends openmp)
  endif ()

  if (RAJA_FOUND)
    set (HAVE_RAJA True)

    blt_register_library(
      NAME RAJA
      INCLUDES ${RAJA_INCLUDE_DIR}
      LIBRARIES RAJA
      DEPENDS_ON ${raja_depends})
  endif ()
  list(APPEND HYPRE_DEPENDS RAJA)
endif ()

#defer to BLT 
#add_library (HYPRE)

# Headers and sources
set (HYPRE_HEADERS "")
set (HYPRE_SOURCES "")

# Headers and sources: .
set(HYPRE_MAIN_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/HYPRE_config.h
  HYPREf.h
  HYPRE.h
)
#target_sources(HYPRE
#  PRIVATE ${HYPRE_MAIN_HEADERS}
#  )
set(HYPRE_HEADERS ${HYPRE_HEADERS} ${HYPRE_MAIN_HEADERS})

# Headers and sources: remaining subdirectories
set(HYPRE_DIRS utilities blas lapack multivector krylov seq_mv parcsr_mv parcsr_block_mv distributed_matrix IJ_mv matrix_matrix distributed_ls parcsr_ls struct_mv struct_ls sstruct_mv sstruct_ls)
foreach(DIR IN LISTS HYPRE_DIRS)
  add_subdirectory(${DIR})
  #target_include_directories(HYPRE PUBLIC
  #  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${DIR}>)
endforeach()


blt_add_library( NAME HYPRE
   SOURCES ${HYPRE_SOURCES}
  HEADERS ${HYPRE_HEADERS}
  DEPENDS_ON ${HYPRE_DEPENDS})

# Temporarily just default to internal blas use and setup blas like other hypre dirs; same with lapack
# Headers and sources: blas
#if (HYPRE_USING_HYPRE_BLAS)
#  add_subdirectory(blas)
#else()
  # Find system blas
  #  find_package(BLAS REQUIRED)
  #  target_link_libraries(HYPRE PUBLIC "${BLAS_LIBRARIES}")
  #  target_compile_definitions(HYPRE PUBLIC "USE_VENDOR_BLAS")
  #endif()

# Headers and sources: lapack
#if (HYPRE_USING_HYPRE_LAPACK)
#  add_subdirectory(lapack)
#else()
  # Find system lapack
  #  find_package(LAPACK REQUIRED)
  #  target_link_libraries(HYPRE PUBLIC "${LAPACK_LIBRARIES}")
  #endif()

# Find DSUPERLU, if requested
if (HYPRE_USING_DSUPERLU)
  if (NOT TPL_DSUPERLU_LIBRARIES)
    message(FATAL_ERROR "TPL_DSUPERLU_LIBRARIES option should be set for SuperLU_Dist support.")
  endif()

  if (NOT TPL_DSUPERLU_INCLUDE_DIRS)
    message(FATAL_ERROR "TPL_DSUPERLU_INCLUDE_DIRS option be set for SuperLU_Dist support.")
  endif()
  foreach(dir ${TPL_DSUPERLU_INCLUDE_DIRS})
    if (NOT EXISTS ${dir})
      message(FATAL_ERROR "SuperLU_Dist include directory not found: ${dir}")
    endif()
    set(CMAKE_C_FLAGS "-I${dir} ${CMAKE_C_FLAGS}")
  endforeach()
  message("-- Enabled support for using DSUPERLU.")
  set(DSUPERLU_FOUND TRUE)
  target_link_libraries(HYPRE PUBLIC ${TPL_DSUPERLU_LIBRARIES} stdc++)
  target_include_directories(${TPL_DSUPERLU_INCLUDE_DIRS})
endif()

if(DSUPERLU_FOUND)
  set(HYPRE_USING_DSUPERLU TRUE)
endif()

# Headers and sources: remaining subdirectories
set(HYPRE_DIRS utilities multivector krylov seq_mv parcsr_mv parcsr_block_mv distributed_matrix IJ_mv matrix_matrix distributed_ls parcsr_ls struct_mv struct_ls sstruct_mv sstruct_ls)
foreach(DIR IN LISTS HYPRE_DIRS)
   #add_subdirectory(${DIR})
  target_include_directories(HYPRE PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${DIR}>)
endforeach()

# Configure a header file to pass CMake settings to the source code
configure_file (
  "${CMAKE_CURRENT_SOURCE_DIR}/config/HYPRE_config.h.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/HYPRE_config.h"
  )

# BINARY must be first in order to get the correct HYPRE_config.h file
target_include_directories(HYPRE PUBLIC
  $<BUILD_INTERFACE:${hypre_BINARY_DIR}>
  $<BUILD_INTERFACE:${hypre_SOURCE_DIR}>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/blas>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/lapack>
  $<INSTALL_INTERFACE:include>
  )

# Set library build type
if (HYPRE_SHARED)
  set (BUILD_SHARED_LIBS ON CACHE INTERNAL "" FORCE)
else ()
  set (BUILD_SHARED_LIBS OFF CACHE INTERNAL "" FORCE)
endif ()

# Set MPI compile flags
if (NOT HYPRE_SEQUENTIAL)
  find_program (MPIEXEC_EXECUTABLE NAMES mpiexec mpirun)
  find_package (MPI REQUIRED)
  #  target_link_libraries (HYPRE PUBLIC MPI::MPI_C)
  target_link_libraries (HYPRE PUBLIC MPI::MPI_CXX)
endif (NOT HYPRE_SEQUENTIAL)

# Set OpenMP compile flags
if (HYPRE_USING_OPENMP)
  find_package (OpenMP REQUIRED)
  target_link_libraries (HYPRE PUBLIC OpenMP::OpenMP_C)
endif (HYPRE_USING_OPENMP)

if (HYPRE_USING_RAJA)
   target_link_libraries(HYPRE PUBLIC RAJA)
endif()

if (MSVC)
  target_compile_definitions(HYPRE PRIVATE _CRT_SECURE_NO_WARNINGS)
  # Use the C++ compiler to compile these files to get around lack of C99 support
  set_source_files_properties (utilities/hypre_hopscotch_hash.c PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (utilities/hypre_merge_sort.c     PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (seq_mv/csr_matop.c               PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_mv/par_csr_matop.c        PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_mv/par_csr_matvec.c       PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/ams.c                  PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/aux_interp.c           PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_add_cycle.c        PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_amg_setup.c        PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_coarsen.c          PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_cgc_coarsen.c      PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_jacobi_interp.c    PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_mgr_setup.c        PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_rap.c              PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_relax.c            PROPERTIES COMPILE_FLAGS /TP)
  set_source_files_properties (parcsr_ls/par_strength.c         PROPERTIES COMPILE_FLAGS /TP)
  #Fix issue with visual studio 2013
  set_source_files_properties (struct_ls/pfmg3_setup_rap.c      PROPERTIES COMPILE_FLAGS /Od)
endif ()

if (HYPRE_USING_FEI)
  add_subdirectory(FEI_mv)
endif ()

# Build the examples directory, if requested
if (HYPRE_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# Build the test directory, if requested
if (HYPRE_BUILD_TESTS)
  add_subdirectory(test)
endif()

include (GNUInstallDirs)
install (TARGETS HYPRE
  EXPORT HYPRETargets
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
install (FILES ${HYPRE_HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

include (CMakePackageConfigHelpers)
write_basic_package_version_file (
  HYPREConfigVersion.cmake
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY SameMajorVersion
  )

install (EXPORT HYPRETargets
  FILE HYPRETargets.cmake
  NAMESPACE HYPRE::
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/HYPRE"
  )

configure_package_config_file (
  config/HYPREConfig.cmake.in HYPREConfig.cmake
  INSTALL_DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/HYPREConfig.cmake"
  )
install (
  FILES
      "${CMAKE_CURRENT_BINARY_DIR}/HYPREConfig.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/HYPREConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/HYPRE"
  )

export (EXPORT HYPRETargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/HYPRETargets.cmake"
  NAMESPACE HYPRE::
  )


export (PACKAGE HYPRE)



#cmake_print_properties(TARGETS bout++ INTERFACE_INCLUDE_DIRECTORIES)
# Get all propreties that cmake supports
execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

# Convert command output into a CMake list
STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
# Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$")
# For some reason, "TYPE" shows up twice - others might too?
list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)

# build whitelist by filtering down from CMAKE_PROPERTY_LIST in case cmake is
# a different version, and one of our hardcoded whitelisted properties
# doesn't exist!
unset(CMAKE_WHITELISTED_PROPERTY_LIST)
foreach(prop ${CMAKE_PROPERTY_LIST})
    if(prop MATCHES "^(INTERFACE|[_a-z]|IMPORTED_LIBNAME_|MAP_IMPORTED_CONFIG_)|^(COMPATIBLE_INTERFACE_(BOOL|NUMBER_MAX|NUMBER_MIN|STRING)|EXPORT_NAME|IMPORTED(_GLOBAL|_CONFIGURATIONS|_LIBNAME)?|NAME|TYPE|NO_SYSTEM_FROM_IMPORTED)$")
        list(APPEND CMAKE_WHITELISTED_PROPERTY_LIST ${prop})
    endif()
endforeach(prop)

function(print_properties)
    message ("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction(print_properties)

function(print_whitelisted_properties)
    message ("CMAKE_WHITELISTED_PROPERTY_LIST = ${CMAKE_WHITELISTED_PROPERTY_LIST}")
endfunction(print_whitelisted_properties)

function(print_target_properties tgt)
    if(NOT TARGET ${tgt})
      message("There is no target named '${tgt}'")
      return()
    endif()

    get_target_property(target_type ${tgt} TYPE)
    if(target_type STREQUAL "INTERFACE_LIBRARY")
        set(PROP_LIST ${CMAKE_WHITELISTED_PROPERTY_LIST})
    else()
        set(PROP_LIST ${CMAKE_PROPERTY_LIST})
    endif()

    foreach (prop ${PROP_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        # message ("Checking ${prop}")
        get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
        if (propval)
            get_target_property(propval ${tgt} ${prop})
            message ("${tgt} ${prop} = ${propval}")
        endif()
    endforeach(prop)
endfunction(print_target_properties)

#print_target_properties(HYPRE)
