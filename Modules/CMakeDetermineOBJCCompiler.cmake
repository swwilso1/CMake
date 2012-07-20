

#=============================================================================
#
# Copyright 2012 Wolfram Research Inc.
#
#=============================================================================

# Determine the compiler to use for Objective-C programs

# Sets the following variables:
#	CMAKE_OBJC_COMPILER
#	CMAKE_AR
#	CMAKE_RANLIB

if(NOT CMAKE_OBJC_COMPILER)
	set(CMAKE_OBJC_COMPILER_INIT NOTFOUND)
	
	# Check for a compiler declared in the environment variable OBJC
	if($ENV{OBJC} MATCHES ".+")
		get_filename_component(CMAKE_OBJC_COMPILER_INIT $ENV{OBJC} PROGRAM PROGRAM_ARGS CMAKE_OBJC_FLAGS_ENV_INIT)
		if(CMAKE_OBJC_FLAGS_ENV_INIT)
			set(CMAKE_OBJC_COMPILER_ARG1 "${CMAKE_OBJC_FLAGS_ENV_INIT}" CACHE STRING "First argument to Objective-C compiler")
		endif(CMAKE_OBJC_FLAGS_ENV_INIT)
		if(NOT EXISTS ${CMAKE_OBJC_COMPILER_INIT})
			message(FATAL_ERROR "Could not find compiler set in environment variable OBJC:\n$ENV{OBJC}.\n${CMAKE_OBJC_COMPILER_INIT}")
		endif(NOT EXISTS ${CMAKE_OBJC_COMPILER_INIT})
	endif($ENV{OBJC} MATCHES ".+")
	
	# List compilers to try:
	if(CMAKE_OBJC_COMPILER_INIT)
		set(CMAKE_OBJC_COMPILER_LIST ${CMAKE_OBJC_COMPILER_INIT})
	else(CMAKE_OBJC_COMPILER_INIT)
		set(CMAKE_OBJC_COMPILER_LIST gcc clang cc)
	endif(CMAKE_OBJC_COMPILER_INIT)
	
	# Find the compiler.
	find_program(CMAKE_OBJC_COMPILER NAMES ${CMAKE_OBJC_COMPILER_LIST} DOC "Objective-C compiler")
	
	if(CMAKE_OBJC_COMPILER_INIT AND NOT CMAKE_OBJC_COMPILER)
		set(CMAKE_OBJC_COMPILER "${CMAKE_OBJC_CMPILER_INIT}" CACHE FILEPATH "Objective-C compiler" FORCE)
	endif(CMAKE_OBJC_COMPILER_INIT AND NOT CMAKE_OBJC_COMPILER)

endif(NOT CMAKE_OBJC_COMPILER)


# To get to this part of the file, the user must have specified CMAKE_OBJC_COMPILER vial -D or a pre-made CMakeCache.txt
#
# If CMAKE_OBJC_COMPILER is a list of length 2, use the first item as CMAKE_OBJC_COMPILER 
# and the second as CMAKE_OBJC_COMPILER_ARG1

list(LENGTH CMAKE_OBJC_COMPILER _CMAKE_OBJC_COMPILER_LIST_LENGTH)
if("${_CMAKE_OBJC_COMPILER_LIST_LENGTH}" EQUAL 2)
	list(GET CMAKE_OBJC_COMPILER 1 CMAKE_OBJC_COMPILER_ARG1)
	list(GET CMAKE_OBJC_COMPILER 0 CMAKE_OBJC_COMPILER)
endif("${_CMAKE_OBJC_COMPILER_LIST_LENGTH}" EQUAL 2)

# Check to see if the user specified a compiler without a path.
# If found, put the value in the cache, if not do not overwrite with "NOTFOUND"
get_filename_component(_CMAKE_USER_OBJC_COMPILER_PATH "${CMAKE_OBJC_COMPILER}" PATH)
if(NOT _CMAKE_USER_OBJC_COMPILER_PATH)
	find_program(CMAKE_OBJC_COMPILER_WITH_PATH NAMES ${CMAKE_OBJC_COMPILER})
	mark_as_advanced(CMAKE_OBJC_COMPILER_WITH_PATH)
	if(CMAKE_OBJC_COMPILER_WITH_PATH)
		set(CMAKE_OBJC_COMPILER ${CMAKE_OBJC_COMPILER_WITH_PATH} CACHE STRING "Objective-C compiler" FORCE)
	endif(CMAKE_OBJC_COMPILER_WITH_PATH)
endif(NOT _CMAKE_USER_OBJC_COMPILER_PATH)
mark_as_advanced(CMAKE_OBJC_COMPILER)

if(NOT _CMAKE_TOOLCHAIN_LOCATION)
	get_filename_component(_CMAKE_TOOLCHAIN_LOCATION "${CMAKE_OBJC_COMPILER}" PATH)
endif(NOT _CMAKE_TOOLCHAIN_LOCATION)

# Try to identify the compiler.
SET(CMAKE_OBJC_COMPILER_ID)
FILE(READ ${CMAKE_ROOT}/Modules/CMakePlatformId.h.in
  CMAKE_OBJC_COMPILER_ID_PLATFORM_CONTENT)
INCLUDE(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
CMAKE_DETERMINE_COMPILER_ID(OBJC OBJCFLAGS CMakeOBJCCompilerId.m)


INCLUDE(CMakeFindBinUtils)

# Look for libtool:
if(NOT CMAKE_LIBTOOL)
	find_program(CMAKE_LIBTOOL NAMES libtool HINTS "${_CMAKE_TOOLCHAIN_LOCATION}" DOC "Libtool")
	message(STATUS "LIBTOOL: ${CMAKE_LIBTOOL}")
endif(NOT CMAKE_LIBTOOL)

configure_file(${CMAKE_ROOT}/Modules/CMakeOBJCCompiler.cmake.in
	${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOBJCCompiler.cmake
	@ONLY IMMEDIATE
)





set(CMAKE_OBJC_COMPILER_ENV_VAR "OBJC")


