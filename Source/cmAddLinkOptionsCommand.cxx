/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2014 Steve Wilson <stevew@wolfram.com>

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmAddLinkOptionsCommand.h"

bool cmAddLinkOptionsCommand
::InitialPass(std::vector<std::string> const& args, cmExecutionStatus &)
{
  if(args.size() < 1 )
    {
    return true;
    }

  for(std::vector<std::string>::const_iterator i = args.begin();
      i != args.end(); ++i)
    {
    this->Makefile->AddLinkOption(i->c_str());
    }
  return true;
}
