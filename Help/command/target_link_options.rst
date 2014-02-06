target_link_options
-------------------

Add link options to a target.

::

  target_link_options(<target> <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])

Specify link options to use when linking a given target.  The
named ``<target>`` must have been created by a command such as
:command:`add_executable` or :command:`add_library` and must not be an
:prop_tgt:`IMPORTED` target.

This command can be used to add any linker option, but an alternative
command exists to add libraries(:command:`target_link_libraries`) to the
linker comamnd line.  See documentation of the
:prop_tgt:`directory <LINK_OPTIONS>` and :prop_tgt:`target <LINK_OPTIONS>`
``LINK_OPTIONS`` properties.

The ``INTERFACE``, ``PUBLIC`` and ``PRIVATE`` keywords are required to
specify the scope of the following arguments.  ``PRIVATE`` and ``PUBLIC``
items will populate the :prop_tgt:`LINK_OPTIONS` property of ``<target>``.
``PUBLIC`` and ``INTERFACE`` items will populate the
:prop_tgt:`INTERFACE_LINK_OPTIONS property of ``<target>``.  The
following arguments specify link options.  Repeated calls for the same
``<target>`` append items in the order called.

Arguments to ``target_link_options`` may use "generator expressions"
with the syntax ``$<...>``.  See the :manual:`cmake-generator-expressions(7)`
manual for available expressions.  See the :manual:`cmake-buildsystem(7)`
manaul for more information on defining buildsystem properties.
