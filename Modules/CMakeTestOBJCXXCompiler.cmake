
#=============================================================================
# Copyright 2003-2014 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

if(CMAKE_OBJCXX_COMPILER_FORCED)
  # The compiler configuration was forced by the user.
  # Assume the user has configured all compiler information.
  set(CMAKE_OBJCXX_COMPILER_WORKS TRUE)
  return()
endif()

include(CMakeTestCompilerCommon)

# Remove any cached result from an older CMake version.
# We now store this in CMakeCCompiler.cmake.
unset(CMAKE_OBJCXX_COMPILER_WORKS CACHE)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected Objective-C compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
if(NOT CMAKE_OBJCXX_COMPILER_WORKS)
  PrintTestCompilerStatus("OBJCXX" "")
  file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testOBJCXXCompiler.mm
    "#ifndef __cplusplus\n"
    "# error \"The CMAKE_OBJCXX_COMPILER is set to a C compiler\"\n"
    "#endif\n"
    "#ifndef __OBJC__\n"
    "# error \"The CMAKE_OBJCXX_COMPILER is not an Objective-C++ compiler\"\n"
    "#endif\n"
    "int main(int argc, char* argv[])\n"
    "{ (void)argv; return argc-1;}\n")
  try_compile(CMAKE_OBJCXX_COMPILER_WORKS ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testOBJCXXCompiler.mm
    OUTPUT_VARIABLE __CMAKE_OBJCXX_COMPILER_OUTPUT)
  # Move result from cache to normal variable.
  set(CMAKE_OBJCXX_COMPILER_WORKS ${CMAKE_OBJCXX_COMPILER_WORKS})
  unset(CMAKE_OBJCXX_COMPILER_WORKS CACHE)
  set(OBJCXX_TEST_WAS_RUN 1)
endif()

if(NOT CMAKE_OBJCXX_COMPILER_WORKS)
  PrintTestCompilerStatus("OBJCXX" " -- broken")
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the Objective-C++ compiler works failed with "
    "the following output:\n${__CMAKE_OBJCXX_COMPILER_OUTPUT}\n\n")
  message(FATAL_ERROR "The Objective-C compiler \"${CMAKE_OBJCXX_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${__CMAKE_OBJCXX_COMPILER_OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
else()
  if(OBJCXX_TEST_WAS_RUN)
    PrintTestCompilerStatus("OBJCXX" " -- works")
    file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the Objective-C++ compiler works passed with "
      "the following output:\n${__CMAKE_OBJCXX_COMPILER_OUTPUT}\n\n")
  endif()

  # Try to identify the ABI and configure it into CMakeOBJCXXCompiler.cmake
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
  CMAKE_DETERMINE_COMPILER_ABI(OBJCXX ${CMAKE_ROOT}/Modules/CMakeOBJCXXCompilerABI.mm)

  # Re-configure to save learned information.
  configure_file(
    ${CMAKE_ROOT}/Modules/CMakeOBJCXXCompiler.cmake.in
    ${CMAKE_PLATFORM_INFO_DIR}/CMakeOBJCXXCompiler.cmake
    @ONLY
    )
  include(${CMAKE_PLATFORM_INFO_DIR}/CMakeOBJCXXCompiler.cmake)

  if(CMAKE_OBJCXX_SIZEOF_DATA_PTR)
    foreach(f ${CMAKE_OBJCXX_ABI_FILES})
      include(${f})
    endforeach()
    unset(CMAKE_OBJCXX_ABI_FILES)
  endif()
endif()

unset(__CMAKE_OBJCXX_COMPILER_OUTPUT)
