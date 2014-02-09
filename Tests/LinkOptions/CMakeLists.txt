cmake_minimum_required(VERSION 2.8)

project(LinkOptions)

if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  add_executable(foo foo.cpp)
  set_property(TARGET foo PROPERTY LINK_OPTIONS -Wl,-undefined,dynamic_lookup)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  add_executable(foo foo.cpp)
  set_property(TARGET foo PROPERTY LINK_OPTIONS -Wl,-ignore-unresolved-symbol,main)
endif()

if(WIN32)
  add_executable(winmain winmain.cpp)
  set_property(TARGET winmain PROPERTY LINK_OPTIONS "/SUBSYSTEM:CONSOLE" "/ENTRY:mywinmain")
endif()

add_subdirectory(dirscope)

file(WRITE
  "${CMAKE_CURRENT_BINARY_DIR}/main.cxx"
  "int main() { return 0; }
"
)

add_executable(
  LinkOptions
  "${CMAKE_CURRENT_BINARY_DIR}/main.cxx"
)
