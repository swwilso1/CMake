
# This set of tests exercises the import capabilities of the LINK_OPTIONS
# properties for targets.

# First include the LINK_OPTIONS targets exported from the build tree.
include(${Import_BINARY_DIR}/../Export/linkoptions/LinkOptions.cmake)

# Next include the LINK_OPTIONS targets exported by the install tree.
include(${CMAKE_INSTALL_PREFIX}/lib/LinkOptions.cmake)

# Now create an executable that links with the library that we just imported
# from the build tree.  The executable makes an explicit call to the missing
# function.   We want our imported LINK_OPTIONS to suppress the missing
# symbol error.

if(CMAKE_C_COMPILER_ID MATCHES GNU OR CMAKE_C_COMPILER_ID MATCHES Clang)
  add_executable(buildExeWithoutFooFunction exeWithoutFooFunction.c)
  target_link_libraries(buildExeWithoutFooFunction LOBuild::libWithoutFooFunction)
endif()

# Create an executable that links with the library that we imported from the
# install tree.  This executable makes an explicit call to the missing
# function.  Again we expect the imported LINK_OPTIONS to suppress the missing
# symbol error.

if(CMAKE_C_COMPILER_ID MATCHES GNU OR CMAKE_C_COMPILER_ID MATCHES Clang)
  add_executable(installExeWithoutFooFunction exeWithoutFooFunction.c)
  target_link_libraries(installExeWithoutFooFunction LOInstall::libWithoutFooFunction)
endif()
