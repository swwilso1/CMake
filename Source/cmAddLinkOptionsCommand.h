/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2014 Steve Wilson <stevew@wolfram.com>

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#ifndef cmAddLinkOptionsCommand_h
#define cmAddLinkOptionsCommand_h

#include "cmCommand.h"

class cmAddLinkOptionsCommand : public cmCommand
{
public:
  /**
   * This is a virtual constructor for the command.
   */
  virtual cmCommand* Clone()
    {
    return new cmAddLinkOptionsCommand;
    }

  /**
   * This is called when the command is first encountered in
   * the CMakeLists.txt file.
   */
  virtual bool InitialPass(std::vector<std::string> const& args,
                           cmExecutionStatus &status);

  /**
   * The name of the command as specified in CMakeList.txt.
   */
  virtual const char * GetName() const {return "add_link_options";}

  cmTypeMacro(cmAddLinkOptionsCommand, cmCommand);
};

#endif
