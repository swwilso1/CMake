INTERFACE_LINK_OPTIONS
----------------------

List of interface options to pass to the linker.

Targets may populate this property to publish the linker options
required to link against the libraries for the target.  Consuming
targets can add entries to their own :prop_tgt:`LINK_OPTIONS` property
such as ``$<TARGET_PROPERTY:foo,INTERFACE_LINK_OPTIONS>`` to use the
linker options specified in the interface of ``foo``.

Contents of ``INTERFACE_LINK_OPTIONS`` may use "generator expressions"
with the syntax ``$<...>``. See the :manual:`cmakegenerator-expressions(7)`
manual for available expressions.  See the :manual:`cmake-buildsystem(7)`
manual for more information on defining buildsystem properties.
