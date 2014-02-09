
if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  set_property(DIRECTORY PROPERTY LINK_OPTIONS -Wl,-undefined,dynamic_lookup)
  add_executable(foodir foo.cpp)
elseif(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  set_property(DIRECTORY PROPERTY LINK_OPTIONS -Wl,-ignore-unresolved-symbol,main)
  add_executable(foodir foo.cpp)
endif()

if(WIN32)
  set_property(DIRECTORY PROPERTY LINK_OPTIONS "/SUBSYSTEM:CONSOLE" "/ENTRY:mywinmain")
  add_executable(winmaindir winmain.cpp)
endif()
