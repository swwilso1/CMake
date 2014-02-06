cmake_minimum_required(VERSION 2.8)

project(add_link_options)

if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  add_link_options(-Wl,-undefined,dynamic_lookup)
  add_executable(foo foo.cpp)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  add_link_options(-Wl,-ignore-unresolved-symbol,main)
  add_executable(foo foo.cpp)
endif()

if(WIN32)
  add_link_options("/SUBSYSTEM:CONSOLE" "/ENTRY:mywinmain")
  add_executable(winmain winmain.cpp)
endif()
