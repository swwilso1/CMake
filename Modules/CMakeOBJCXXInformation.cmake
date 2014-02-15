
#=============================================================================
# Copyright 2004-2014 Kitware, Inc.
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

# This file sets the basic flags for the Objective-C language in CMake.
# It also loads the available platform file for the system-compiler
# if it exists.
# It also loads a system - compiler - processor (or target hardware)
# specific file, which is mainly useful for crosscompiling and embedded systems.

set(CMAKE_OBJCXX_OUTPUT_EXTENSION .o)

set(_INCLUDED_FILE 0)

# Load compiler-specific information.
if(CMAKE_OBJCXX_COMPILER_ID)
  include(Compiler/${CMAKE_OBJCXX_COMPILER_ID}-OBJCXX OPTIONAL)
endif()

set(CMAKE_BASE_NAME)
get_filename_component(CMAKE_BASE_NAME "${CMAKE_OBJCXX_COMPILER}" NAME_WE)
if(CMAKE_OBJCXX_COMPILER_IS_GNUCC)
  set(CMAKE_BASE_NAME gcc)
endif()

# load a hardware specific file, mostly useful for embedded compilers
if(CMAKE_SYSTEM_PROCESSOR)
  if(CMAKE_OBJCXX_COMPILER_ID)
    include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_OBJCXX_COMPILER_ID}-OBJCXX-${CMAKE_SYSTEM_PROCESSOR} OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
  endif()
  if (NOT _INCLUDED_FILE)
    include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME}-${CMAKE_SYSTEM_PROCESSOR} OPTIONAL)
  endif ()
endif()

# load the system- and compiler specific files
if(CMAKE_OBJCXX_COMPILER_ID)
  include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_OBJCXX_COMPILER_ID}-OBJCXX
    OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
endif()
if (NOT _INCLUDED_FILE)
  include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME}
    OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
endif ()

# We specify the compiler information in the system file for some
# platforms, but this language may not have been enabled when the file
# was first included.  Include it again to get the language info.
# Remove this when all compiler info is removed from system files.
if (NOT _INCLUDED_FILE)
  include(Platform/${CMAKE_SYSTEM_NAME} OPTIONAL)
endif ()

if(CMAKE_OBJCXX_SIZEOF_DATA_PTR)
  foreach(f ${CMAKE_OBJCXX_ABI_FILES})
    include(${f})
  endforeach()
  unset(CMAKE_OBJCXX_ABI_FILES)
endif()

# This should be included before the _INIT variables are
# used to initialize the cache.  Since the rule variables
# have if blocks on them, users can still define them here.
# But, it should still be after the platform file so changes can
# be made to those values.

if(CMAKE_USER_MAKE_RULES_OVERRIDE)
  # Save the full path of the file so try_compile can use it.
  include(${CMAKE_USER_MAKE_RULES_OVERRIDE} RESULT_VARIABLE _override)
  set(CMAKE_USER_MAKE_RULES_OVERRIDE "${_override}")
endif()

if(CMAKE_USER_MAKE_RULES_OVERRIDE_OBJCXX)
  # Save the full path of the file so try_compile can use it.
  include(${CMAKE_USER_MAKE_RULES_OVERRIDE_OBJCXX} RESULT_VARIABLE _override)
  set(CMAKE_USER_MAKE_RULES_OVERRIDE_OBJCXX "${_override}")
endif()

# Create a set of shared library variable specific to Objective-C++
# For 90% of the systems, these are the same flags as the C++ versions
# so if these are not set just copy the flags from the c version
if(NOT CMAKE_SHARED_LIBRARY_CREATE_OBJCXX_FLAGS)
  set(CMAKE_SHARED_LIBRARY_CREATE_OBJCXX_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS})
endif()

if(NOT CMAKE_OBJCXX_COMPILE_OPTIONS_PIC)
  set(CMAKE_OBJCXX_COMPILE_OPTIONS_PIC ${CMAKE_CXX_COMPILE_OPTIONS_PIC})
endif()

if(NOT CMAKE_OBJCXX_COMPILE_OPTIONS_PIE)
  set(CMAKE_OBJCXX_COMPILE_OPTIONS_PIE ${CMAKE_CXX_COMPILE_OPTIONS_PIE})
endif()

if(NOT CMAKE_OBJCXX_COMPILE_OPTIONS_DLL)
  set(CMAKE_OBJCXX_COMPILE_OPTIONS_DLL ${CMAKE_CXX_COMPILE_OPTIONS_DLL})
endif()

if(NOT CMAKE_SHARED_LIBRARY_OBJCXX_FLAGS)
  set(CMAKE_SHARED_LIBRARY_OBJCXX_FLAGS ${CMAKE_SHARED_LIBRARY_CXX_FLAGS})
endif()

if(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_OBJCXX_FLAGS)
  set(CMAKE_SHARED_LIBRARY_LINK_OBJCXX_FLAGS ${CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS})
endif()

if(NOT CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG)
  set(CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG})
endif()

if(NOT CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG_SEP)
  set(CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG_SEP})
endif()

if(NOT CMAKE_SHARED_LIBRARY_RPATH_LINK_OBJCXX_FLAG)
  set(CMAKE_SHARED_LIBRARY_RPATH_LINK_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_CXX_FLAG})
endif()

if(NOT DEFINED CMAKE_EXE_EXPORTS_OBJCXX_FLAG)
  set(CMAKE_EXE_EXPORTS_OBJCXX_FLAG ${CMAKE_EXE_EXPORTS_CXX_FLAG})
endif()

if(NOT DEFINED CMAKE_SHARED_LIBRARY_SONAME_OBJCXX_FLAG)
  set(CMAKE_SHARED_LIBRARY_SONAME_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG})
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG)
  set(CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG})
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG_SEP)
  set(CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG_SEP})
endif()

if(NOT CMAKE_EXECUTABLE_RPATH_LINK_OBJCXX_FLAG)
  set(CMAKE_EXECUTABLE_RPATH_LINK_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_OBJCXX_FLAG})
endif()

if(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_OBJCXX_WITH_RUNTIME_PATH)
  set(CMAKE_SHARED_LIBRARY_LINK_OBJCXX_WITH_RUNTIME_PATH ${CMAKE_SHARED_LIBRARY_LINK_CXX_WITH_RUNTIME_PATH})
endif()

if(NOT CMAKE_INCLUDE_FLAG_OBJCXX)
  set(CMAKE_INCLUDE_FLAG_OBJCXX ${CMAKE_INCLUDE_FLAG_CXX})
endif()

if(NOT CMAKE_INCLUDE_FLAG_SEP_OBJCXX)
  set(CMAKE_INCLUDE_FLAG_SEP_OBJCXX ${CMAKE_INCLUDE_FLAG_SEP_CXX})
endif()


# for most systems a module is the same as a shared library
# so unless the variable CMAKE_MODULE_EXISTS is set just
# copy the values from the LIBRARY variables
if(NOT CMAKE_MODULE_EXISTS)
  set(CMAKE_SHARED_MODULE_OBJCXX_FLAGS ${CMAKE_SHARED_LIBRARY_OBJCXX_FLAGS})
  set(CMAKE_SHARED_MODULE_CREATE_OBJCXX_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_OBJCXX_FLAGS})
endif()

set(CMAKE_OBJCXX_FLAGS_INIT "$ENV{OBJCXXCFLAGS} ${CMAKE_OBJCXX_FLAGS_INIT}")
# avoid just having a space as the initial value for the cache
if(CMAKE_OBJCXX_FLAGS_INIT STREQUAL " ")
  set(CMAKE_OBJCXX_FLAGS_INIT)
endif()
set (CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS_INIT}" CACHE STRING
     "Flags used by the compiler during all build types.")

if(NOT CMAKE_NOT_USING_CONFIG_FLAGS)
# default build type is none
  if(NOT CMAKE_NO_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE_INIT} CACHE STRING
      "Choose the type of build, options are: None(CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel.")
  endif()
  set (CMAKE_OBJCXX_FLAGS_DEBUG "${CMAKE_OBJCXX_FLAGS_DEBUG_INIT}" CACHE STRING
    "Flags used by the compiler during debug builds.")
  set (CMAKE_OBJCXX_FLAGS_MINSIZEREL "${CMAKE_OBJCXX_FLAGS_MINSIZEREL_INIT}" CACHE STRING
    "Flags used by the compiler during release builds for minimum size.")
  set (CMAKE_OBJCXX_FLAGS_RELEASE "${CMAKE_OBJCXX_FLAGS_RELEASE_INIT}" CACHE STRING
    "Flags used by the compiler during release builds.")
  set (CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO "${CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING
    "Flags used by the compiler during release builds with debug info.")
endif()

if(CMAKE_OBJCXX_STANDARD_LIBRARIES_INIT)
  set(CMAKE_OBJCXX_STANDARD_LIBRARIES "${CMAKE_OBJCXX_STANDARD_LIBRARIES_INIT}"
    CACHE STRING "Libraries linked by default with all C applications.")
  mark_as_advanced(CMAKE_OBJCXX_STANDARD_LIBRARIES)
endif()

include(CMakeCommonLanguageInclude)

# now define the following rule variables

# CMAKE_OBJCXX_CREATE_SHARED_LIBRARY
# CMAKE_OBJCXX_CREATE_SHARED_MODULE
# CMAKE_OBJCXX_COMPILE_OBJECT
# CMAKE_OBJCXX_LINK_EXECUTABLE

# variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# Objective-C compiler information
# <CMAKE_OBJCXX_COMPILER>
# <CMAKE_SHARED_LIBRARY_CREATE_OBJCXX_FLAGS>
# <CMAKE_SHARED_MODULE_CREATE_OBJCXX_FLAGS>
# <CMAKE_OBJCXX_LINK_FLAGS>

# Static library tools
# <CMAKE_AR>
# <CMAKE_RANLIB>

# create an OBJCXX shared library
if(NOT CMAKE_OBJCXX_CREATE_SHARED_LIBRARY)
  set(CMAKE_OBJCXX_CREATE_SHARED_LIBRARY
      "<CMAKE_OBJCXX_COMPILER> <CMAKE_SHARED_LIBRARY_OBJCXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_OBJCXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
endif()


# create an OBJCXX shared module just copy the shared library rule
if(NOT CMAKE_OBJCXX_CREATE_SHARED_MODULE)
  set(CMAKE_OBJCXX_CREATE_SHARED_MODULE ${CMAKE_OBJCXX_CREATE_SHARED_LIBRARY})
endif()


# Create a static archive incrementally for large object file counts.
# If CMAKE_OBJCXX_CREATE_STATIC_LIBRARY is set it will override these.
if(NOT DEFINED CMAKE_OBJCXX_ARCHIVE_CREATE)
  set(CMAKE_OBJCXX_ARCHIVE_CREATE "<CMAKE_LIBTOOL> -static -o <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()
if(NOT DEFINED CMAKE_OBJCXX_ARCHIVE_APPEND)
  set(CMAKE_OBJCXX_ARCHIVE_APPEND "<CMAKE_LIBTOOL> -static -o <TARGET> <LINK_FLAGS> <TARGET> <OBJECTS>")
endif()
if(NOT DEFINED CMAKE_OBJCXX_ARCHIVE_FINISH)
  set(CMAKE_OBJCXX_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET>")
endif()

# compile an Objective-C++ file into an object file
if(NOT CMAKE_OBJCXX_COMPILE_OBJECT)
  set(CMAKE_OBJCXX_COMPILE_OBJECT
    "<CMAKE_OBJCXX_COMPILER> <DEFINES> <FLAGS> -o <OBJECT> -c <SOURCE>")
endif()

if(NOT CMAKE_OBJCXX_LINK_EXECUTABLE)
  set(CMAKE_OBJCXX_LINK_EXECUTABLE
    "<CMAKE_OBJCXX_COMPILER> <FLAGS> <CMAKE_OBJCXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG)
  set(CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG})
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG_SEP)
  set(CMAKE_EXECUTABLE_RUNTIME_OBJCXX_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_OBJCXX_FLAG_SEP})
endif()

if(NOT CMAKE_EXECUTABLE_RPATH_LINK_OBJCXX_FLAG)
  set(CMAKE_EXECUTABLE_RPATH_LINK_OBJCXX_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_OBJCXX_FLAG})
endif()

mark_as_advanced(
CMAKE_OBJCXX_FLAGS
CMAKE_OBJCXX_FLAGS_DEBUG
CMAKE_OBJCXX_FLAGS_MINSIZEREL
CMAKE_OBJCXX_FLAGS_RELEASE
CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO
)

set(CMAKE_OBJCXX_INFORMATION_LOADED 1)
