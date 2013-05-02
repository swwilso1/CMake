

#=============================================================================
#
# Copyright 2012 Wolfram Research Inc.
#
#=============================================================================

INCLUDE(CMakeTestCompilerCommon)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected C compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
IF(NOT CMAKE_OBJC_COMPILER_WORKS)
  PrintTestCompilerStatus("OBJC" "")
  FILE(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testOBJCCompiler.m
    "#ifdef __cplusplus\n"
    "# error \"The CMAKE_OBJC_COMPILER is set to a C++ compiler\"\n"
    "#endif\n"
    "#ifndef __OBJC__\n"
    "# error \"The CMAKE_OBJC_COMPILER is not an Objective-C compiler\"\n"
    "#endif\n"
    "int main(int argc, char* argv[])\n"
    "{ (void)argv; return argc-1;}\n")
  TRY_COMPILE(CMAKE_OBJC_COMPILER_WORKS ${CMAKE_BINARY_DIR} 
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testOBJCCompiler.m
    OUTPUT_VARIABLE __CMAKE_OBJC_COMPILER_OUTPUT)
  SET(OBJC_TEST_WAS_RUN 1)
ENDIF(NOT CMAKE_OBJC_COMPILER_WORKS)


IF(NOT CMAKE_OBJC_COMPILER_WORKS)
  PrintTestCompilerStatus("OBJC" " -- broken")
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the OBJC compiler works failed with "
    "the following output:\n${__CMAKE_OBJC_COMPILER_OUTPUT}\n\n")
  # if the compiler is broken make sure to remove the platform file
  # since Windows-cl configures both c/cxx files both need to be removed
  # when c or c++ fails
  FILE(REMOVE ${CMAKE_PLATFORM_ROOT_BIN}/CMakeCPlatform.cmake )
  FILE(REMOVE ${CMAKE_PLATFORM_ROOT_BIN}/CMakeCXXPlatform.cmake )
  FILE(REMOVE ${CMAKE_PLATFORM_ROOT_BIN}/CMakeOBJCPlatform.cmake )
  MESSAGE(FATAL_ERROR "The OBJC compiler \"${CMAKE_OBJC_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${__CMAKE_OBJC_COMPILER_OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
ELSE(NOT CMAKE_OBJC_COMPILER_WORKS)
  IF(OBJC_TEST_WAS_RUN)
    PrintTestCompilerStatus("OBJC" " -- works")
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the OBJC compiler works passed with "
      "the following output:\n${__CMAKE_OBJC_COMPILER_OUTPUT}\n\n")
  ENDIF(OBJC_TEST_WAS_RUN)
  SET(CMAKE_OBJC_COMPILER_WORKS 1 CACHE INTERNAL "")

  IF(CMAKE_OBJC_COMPILER_FORCED)
    # The compiler configuration was forced by the user.
    # Assume the user has configured all compiler information.
  ELSE(CMAKE_OBJC_COMPILER_FORCED)
    # Try to identify the ABI and configure it into CMakeOBJCCompiler.cmake
    INCLUDE(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
    CMAKE_DETERMINE_COMPILER_ABI(OBJC ${CMAKE_ROOT}/Modules/CMakeOBJCCompilerABI.m)
    CONFIGURE_FILE(
      ${CMAKE_ROOT}/Modules/CMakeOBJCCompiler.cmake.in
      ${CMAKE_PLATFORM_INFO_DIR}/CMakeOBJCCompiler.cmake
      @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
      )
    INCLUDE(${CMAKE_PLATFORM_INFO_DIR}/CMakeOBJCCompiler.cmake)
  ENDIF(CMAKE_OBJC_COMPILER_FORCED)
  IF(CMAKE_OBJC_SIZEOF_DATA_PTR)
    FOREACH(f ${CMAKE_OBJC_ABI_FILES})
      INCLUDE(${f})
    ENDFOREACH()
    UNSET(CMAKE_OBJC_ABI_FILES)
  ENDIF()
ENDIF(NOT CMAKE_OBJC_COMPILER_WORKS)

UNSET(__CMAKE_OBJC_COMPILER_OUTPUT)

