/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2014 Steve Wilson <stevew@wolfram.com>

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmTargetLinkOptionsCommand.h"

bool cmTargetLinkOptionsCommand
::InitialPass(std::vector<std::string> const& args, cmExecutionStatus &)
{
  return this->HandleArguments(args, "LINK_OPTIONS");
}

void cmTargetLinkOptionsCommand
::HandleImportedTarget(const std::string &tgt)
{
  cmOStringStream e;
  e << "Cannot specify link options for imported target \""
    << tgt << "\".";
  this->Makefile->IssueMessage(cmake::FATAL_ERROR, e.str());
}

void cmTargetLinkOptionsCommand
::HandleMissingTarget(const std::string &name)
{
  cmOStringStream e;
  e << "Cannot specify link options for target \"" << name << "\" "
       "which is not built by this project.";
  this->Makefile->IssueMessage(cmake::FATAL_ERROR, e.str());
}

//----------------------------------------------------------------------------
std::string cmTargetLinkOptionsCommand
::Join(const std::vector<std::string> &content)
{
  std::string defs;
  std::string sep;
  for(std::vector<std::string>::const_iterator it = content.begin();
    it != content.end(); ++it)
    {
    defs += sep + *it;
    sep = ";";
    }
  return defs;
}

//----------------------------------------------------------------------------
void cmTargetLinkOptionsCommand
::HandleDirectContent(cmTarget *tgt, const std::vector<std::string> &content,
                                   bool, bool)
{
  cmListFileBacktrace lfbt;
  this->Makefile->GetBacktrace(lfbt);
  cmValueWithOrigin entry(this->Join(content), lfbt);
  tgt->InsertLinkOption(entry);
}
