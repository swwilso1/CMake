include(Platform/Darwin-Clang)
__darwin_compiler_clang(CXX)
cmake_clang_has_isysroot(CXX)
cmake_clang_set_osx_deployment_target_flag(CXX)
