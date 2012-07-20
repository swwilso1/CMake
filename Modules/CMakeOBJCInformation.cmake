
#=============================================================================
#
# Copyright 2012 Wolfram Research Inc.
#
#=============================================================================

if(UNIX)
	set(CMAKE_OBJC_OUTPUT_EXTENSION .o)
endif(UNIX)

# Load compiler-specific information
if(CMAKE_OBJC_COMPILER_ID)
	include(Compiler/${CMAKE_OBJC_COMPILER_ID}-OBJC OPTIONAL)
endif(CMAKE_OBJC_COMPILER_ID)

set(CMAKE_BASE_NAME)
get_filename_component(CMAKE_BASE_NAME ${CMAKE_OBJC_COMPILER} NAME_WE)

# Load system- and compiler specific files
if(CMAKE_OBJC_COMPILER_ID)
	include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_OBJC_COMPILER_ID}-OBJC OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
endif(CMAKE_OBJC_COMPILER_ID)

if(NOT _INCLUDED_FILE)
	include(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME} OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
endif(NOT _INCLUDED_FILE)

if(NOT _INCLUDED_FILE)
	include(Platform/${CMAKE_SYSTEM_NAME} OPTIONAL)
endif(NOT _INCLUDED_FILE)

# add the flags to the cache based
# on the initial values computed in the platform/*.cmake files
# use _INIT variables so that this only happens the first time
# and you can set these flags in the cmake cache
set(CMAKE_OBJC_FLAGS_INIT "$ENV{OBJCFLAGS} ${CMAKE_OBJC_FLAGS_INIT}")
# avoid just having a space as the initial value for the cache 
if(CMAKE_OBJC_FLAGS_INIT STREQUAL " ")
	set(CMAKE_OBJC_FLAGS_INIT)
endif(CMAKE_OBJC_FLAGS_INIT STREQUAL " ")
set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS_INIT}" CACHE STRING
     "Flags used by the compiler during all build types.")

IF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)
  SET (CMAKE_OBJC_FLAGS_DEBUG "${CMAKE_OBJC_FLAGS_DEBUG_INIT}" CACHE STRING
     "Flags used by the compiler during debug builds.")
  SET (CMAKE_OBJC_FLAGS_MINSIZEREL "${CMAKE_OBJC_FLAGS_MINSIZEREL_INIT}" CACHE STRING
      "Flags used by the compiler during release minsize builds.")
  SET (CMAKE_OBJC_FLAGS_RELEASE "${CMAKE_OBJC_FLAGS_RELEASE_INIT}" CACHE STRING
     "Flags used by the compiler during release builds.")
  SET (CMAKE_OBJC_FLAGS_RELWITHDEBINFO "${CMAKE_OBJC_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING
     "Flags used by the compiler during Release with Debug Info builds.")

ENDIF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)

INCLUDE(CMakeCommonLanguageInclude)

# Define the following rules:
# CMAKE_OBJC_CREATE_SHARED_LIBRARY
# CMAKE_OBJC_CREATE_SHARED_MODULE
# CMAKE_OBJC_CREATE_MACOSX_FRAMEWORK
# CMAKE_OBJC_COMPILE_OBJECT
# CMAKE_OBJC_LINK_EXECUTABLE

# Variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# Objective-C compiler information
# <CMAKE_OBJC_COMPILER>
# <CMAKE_SHARED_LIBRARY_CREATE_OBJC_FLAGS>
# <CMAKE_OBJC_SHARED_MODULE_CREATE_FLAGS>
# <CMAKE_OBJC_LINK_FLAGS>

# Static library tools
# <CMAKE_AR>
# <CMAKE_RANLIB>

# Create a shared Objective-C library
if(NOT CMAKE_OBJC_CREATE_SHARED_LIBRARY)
	set(CMAKE_OBJC_CREATE_SHARED_LIBRARY
		"<CMAKE_AR> -dynamic -o <TARGET> <LINK_FLAGS> <OBJECTS>"
	)
endif(NOT CMAKE_OBJC_CREATE_SHARED_LIBRARY)


# Create a shared module copy of the shared library rule by default
if(NOT CMAKE_OBJC_CREATE_SHARED_MODULE)
	set(CMAKE_OBJC_CREATE_SHARED_MODULE ${CMAKE_OBJC_CREATE_SHARED_MODULE})
endif(NOT CMAKE_OBJC_CREATE_SHARED_MODULE)


set(CMAKE_OBJC_ARCHIVE_CREATE "<CMAKE_LIBTOOL> -static -o <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_OBJC_ARCHIVE_APPEND "<CMAKE_LIBTOOL> -static -o <TARGET> <LINK_FLAGS> <TARGET> <OBJECTS>")
set(CMAKE_OBJC_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET>")

# Compile an Objective-C file into an object file
if(NOT CMAKE_OBJC_COMPILE_OBJECT)
	set(CMAKE_OBJC_COMPILE_OBJECT
		"<CMAKE_OBJC_COMPILER> <DEFINES> <FLAGS> -o <OBJECT> -c <SOURCE>"
	)
endif(NOT CMAKE_OBJC_COMPILE_OBJECT)


# Link an Objective-C program
if(NOT CMAKE_OBJC_LINK_EXECUTABLE)
	set(CMAKE_OBJC_LINK_EXECUTABLE
		"<CMAKE_OBJC_COMPILER> <FLAGS> <CMAKE_OBJC_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
	)
endif(NOT CMAKE_OBJC_LINK_EXECUTABLE)

mark_as_advanced(
	CMAKE_BUILD_TOOL
	CMAKE_VERBOSE_MAKEFILE
	CMAKE_OBJC_FLAGS
	CMAKE_OBJC_FLAGS_RELEASE
	CMAKE_OBJC_FLAGS_RELWITHDEBINFO
	CMAKE_OBJC_FLAGS_MINSIZEREL
	CMAKE_OBJC_FLAGS_DEBUG
)

set(CMAKE_OBJC_INFORMATION_LOADED 1)


