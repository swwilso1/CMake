
#=============================================================================
#
# Copyright 2012 Wolfram Research Inc.
#
#=============================================================================

# This module is shared by multiple languages; use include blocker.
if(__DARWIN_COMPILER_CLANG)
  return()
endif()
set(__DARWIN_COMPILER_CLANG 1)

macro(__darwin_compiler_clang lang)
  set(CMAKE_SHARED_LIBRARY_CREATE_${lang}_FLAGS "-dynamiclib -Wl,-headerpad_max_install_names")
  set(CMAKE_SHARED_MODULE_CREATE_${lang}_FLAGS "-bundle -Wl,-headerpad_max_install_names")
  set(CMAKE_${lang}_SYSROOT_FLAG "-isysroot")
  set(CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG "-mmacosx-version-min=")
endmacro()

macro(cmake_clang_has_isysroot lang)
  if("x${CMAKE_${lang}_HAS_ISYSROOT}" STREQUAL "x")
    set(_doc "${lang} compiler has -isysroot")
    message(STATUS "Checking whether ${_doc}")
    file(WRITE /tmp/clang-test.c "int main(){return 0;}\n")
    execute_process(
        COMMAND ${CMAKE_${lang}_COMPILER} "-o" "/tmp/clang-test" "-isysroot" "foo" "/tmp/clang-test.c"
        OUTPUT_VARIABLE _clang_help
        ERROR_VARIABLE _clang_help
    )
    if("${_clang_help}" MATCHES "unsupported option '-isysroot'")
      message(STATUS "Checking whether ${_doc} - no")
      set(CMAKE_${lang}_HAS_ISYSROOT 0)
    else()
      message(STATUS "Checking whether ${_doc} - yes")
      set(CMAKE_${lang}_HAS_ISYSROOT 1)
    endif()
    file(REMOVE /tmp/clang-test.c)
    file(REMOVE /tmp/clang-test)
  endif()
endmacro()

macro(cmake_clang_set_osx_deployment_target_flag lang)
  if(NOT DEFINED CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG)
    set(_doc "${lang} compiler supports OSX deployment target flag")
    message(STATUS "Checking whether ${_doc}")
    file(WRITE /tmp/clang-test.c "int main(){return 0;}\n")
    execute_process(
      COMMAND ${CMAKE_${lang}_COMPILER} "-o" "/tmp/clang-test" "-mmacosx-version-min=10.5" "/tmp/clang-test.c"
      OUTPUT_VARIABLE _clang_help
      ERROR_VARIABLE _clang_help
    )
    if("${_clang_help}" MATCHES "unsupported option")
      message(STATUS "Checking whether ${_doc} - no")
      set(CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG "")
    else()
      message(STATUS "Checking whether ${_doc} - yes")
      set(CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG "-mmacosx-version-min=")
    endif()
    set(CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG_CODE "SET(CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG \"${CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG}\")")
    file(REMOVE /tmp/clang-test.c)
    file(REMOVE /tmp/clang-test)
  endif()
endmacro()
