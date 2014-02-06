
# This set of tests should exercise the export capabilities of the
# INTERFACE_LINK_OPTIONS property of targets.

# First build the library libWithoutFooFunction.   LibWithoutFooFunction contains a couple
# exported (in the library sense) functions, but does not contain a function called foo().
# The idea is to create this library, export() it and install(EXPORT) it so that the Import
# tests can import the library.   The  import tests will create an executable based on
# the library that will make an explicit call to foo().   The test is to verify that linker
# options that instruct the linker to ignore missing symbols (or symbol foo) get passed
# correctly.

add_library(libWithoutFooFunction SHARED libWithoutFooFunction.c)
target_link_options(libWithoutFooFunction INTERFACE
  $<$<C_COMPILER_ID:GNU>:-Wl,--ignore-unresolved-symbol,foo>
  $<$<C_COMPILER_ID:Clang>:-Wl,-undefined,dynamic_lookup>
)
set_property(TARGET libWithoutFooFunction PROPERTY ENABLE_EXPORTS ON)

# Now install the target and mark it in the LinkOptions export group.
install(TARGETS libWithoutFooFunction
  EXPORT LinkOptions
  DESTINATION lib
)

# Now install the export .cmake file that contains the information for
# importing the targets from the installation tree.
install(EXPORT LinkOptions
  DESTINATION lib
  NAMESPACE LOInstall::
  FILE LinkOptions.cmake
)

# Create the export .cmake file that contains the information for
# importing the targets from the build tree.
export(TARGETS
  libWithoutFooFunction
  NAMESPACE LOBuild::
  FILE LinkOptions.cmake
)
