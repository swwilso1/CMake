include(Platform/Darwin-Clang)
__darwin_compiler_clang(C)
cmake_clang_has_isysroot(C)
cmake_clang_set_osx_deployment_target_flag(C)
