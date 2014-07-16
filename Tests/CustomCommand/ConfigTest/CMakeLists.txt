cmake_minimum_required(VERSION 2.8)

project(CustomCommand.CONFIG)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

# Test the CONFIG keyword property of add_custom_command by using a custom command
# that differs by configuration.   The custom command creates a source file
# with one function that returns a string value (the configuration name).  The main
# program reads the string value and compares it to the configuration value configured
# in the header.

if(CMAKE_DISTRIBUTION_TYPES)
  list(GET CMAKE_DISTRIBUTION_TYPES 0 CONFIGURATION_TYPE)
elseif(CMAKE_BUILD_TYPE)
  set(CONFIGURAITON_TYPE ${CMAKE_BUILD_TYPE})
else()
  set(CONFIGURATION_TYPE Release)
endif()

add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp
  COMMAND echo "#include <string>" > ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp
  COMMAND echo "std::string theConfigurationName(void)" >> ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp
  COMMAND echo "{ return std::string(\"${CONFIGURATION_TYPE}\"); }" >> ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp
  COMMAND echo "" >> ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp
  VERBATIM
  CONFIG ${CONFIGURATION_TYPE}
)

add_library(configurationNames STATIC ${CMAKE_CURRENT_BINARY_DIR}/configurationName.cpp)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/configtest.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/configtest.h
)

add_executable(configtest configtest.cpp)
target_link_libraries(configtest configurationNames)
