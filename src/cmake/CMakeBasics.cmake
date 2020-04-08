include(cmake/thirdparty/SetupHypreThirdParty.cmake)

include(cmake/SetupCompilers.cmake)

# This needs to happen last, once all we have defined options and checked for
# third-party packages.
# include the following for C++ builds
include(cmake/CMakeConfigureFile.cmake)
