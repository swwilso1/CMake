add_link_options
----------------

Adds options to the link commands of targets.

::

  add_link_options(<option> ...)

Adds options to the linker command line for targets in the current
directory and below.  This command can be used to add any link options, but
an alternative command exists to list libraries
(:command:`target_link_libraries`) to use for linking a particular target.
See documentation of the :prop_tgt:`directory <LINK_OPTIONS>` and
:prop_tgt:`target <LINK_OPTIONS>` ``LINK_OPTIONS`` properties.

Arguments to ``add_link_options`` may use "generator expressions" with
the syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)`
manual for available expressions.  See the :manual:`cmake-buildsystem(7)`
manual for more information on defining buildsystem properties.
