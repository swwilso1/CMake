
include(Platform/QNX)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-Wp,-isystem,")
set(CMAKE_DEPFILE_FLAGS_CXX "-Wc,-MMD,<DEPFILE>,-MT,<OBJECT>,-MF,<DEPFILE>")