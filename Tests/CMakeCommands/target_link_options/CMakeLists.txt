cmake_minimum_required(VERSION 2.8)

project(target_link_options)

if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  add_executable(target_link_options foo.cpp)
  target_link_options(target_link_options PRIVATE -Wl,-undefined,dynamic_lookup)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  add_executable(target_link_options foo.cpp)
  target_link_options(target_link_options PRIVATE -Wl,-ignore-unresolved-symbol,main)
endif()

if(WIN32)
  add_executable(target_link_options winmain.cpp)
  target_link_options(target_link_options PRIVATE "/SUBSYSTEM:CONSOLE" "/ENTRY:mywinmain")
endif()
