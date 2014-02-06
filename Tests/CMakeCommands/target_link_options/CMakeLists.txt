cmake_minimum_required(VERSION 2.8)

project(target_link_options)

if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  add_executable(foo foo.cpp)
  target_link_options(foo PRIVATE -Wl,-undefined,dynamic_lookup)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  add_executable(foo foo.cpp)
  target_link_options(foo PRIVATE -Wl,-ignore-unresolved-symbol,main)
endif()

if(WIN32)
  add_executable(winmain winmain.cpp)
  target_link_options(winmain PRIVATE "/SUBSYSTEM:CONSOLE" "/ENTRY:mywinmain")
endif()
