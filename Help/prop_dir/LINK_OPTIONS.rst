LINK_OPTIONS
------------

This property specifies the list of options give so far to the
:command:`add_link_options` command.

The ``LINK_OPTIONS`` property may be set to a semicolon-separated
list of linker options.

This property will be initialized in each directory by its value in the
directory's parent.

The generators use the LINK_OPTIONS property values to set the options
for the linker.

Contents of ``LINK_OPTIONS`` may use "generator expressions" with the syntax
``$<...>``.  See the :manual:`cmake-generator-expressions(7)` manual for
available expressions.  See the :manual:`cmake-buildsystem(7)` manual for
more information on defining buildsystem properties.
