cmake_minimum_required(VERSION 2.8.12)

project(simple-build-test OBJC)

add_library(foo SHARED foo.m)
target_link_libraries(foo "-framework Foundation")

add_executable(simple-build-test main.m)
target_link_libraries(simple-build-test "-framework Foundation" foo)
