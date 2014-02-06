LINK_OPTIONS
------------

List of options to pass to the linker.

This property specifies the list of options specified so far for this
property.

The generators use this ``LINK_OPTIONS`` target property to set the
options for the linker.

Contents of ``LINK_OPTIONS`` may use "generator expressions" with the syntax
``$<...>``.  See the :manual:`cmake-generator-expressions(7)` manual for
available expressions.  See the :manual:`cmake-buildsystem(7)` manual for
more infomation on defining buildsystem properties.
