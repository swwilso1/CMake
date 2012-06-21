/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2000-2010 Kitware, Inc., Insight Software Consortium

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmCustomCommandGenerator.h"

#include "cmMakefile.h"
#include "cmCustomCommand.h"
#include "cmLocalGenerator.h"
#include "cmGeneratorExpression.h"

//----------------------------------------------------------------------------
cmCustomCommandGenerator::cmCustomCommandGenerator(
  cmCustomCommand const& cc, const char* config, cmMakefile* mf):
  CC(cc), Config(config), Makefile(mf), LG(mf->GetLocalGenerator()),
  OldStyle(cc.GetEscapeOldStyle()), MakeVars(cc.GetEscapeAllowMakeVars()),
  GE(new cmGeneratorExpression(cc.GetBacktrace()))
{
}

//----------------------------------------------------------------------------
cmCustomCommandGenerator::~cmCustomCommandGenerator()
{
  delete this->GE;
}

//----------------------------------------------------------------------------
unsigned int cmCustomCommandGenerator::GetNumberOfCommands(std::string& configName) const
{
  return static_cast<unsigned int>(this->CC.GetCommandLines(configName).size());
}

//----------------------------------------------------------------------------
unsigned int cmCustomCommandGenerator::GetNumberOfCommands(const 
  char *configName) const
{
  std::string config(configName);
  return this->GetNumberOfCommands(config);
}

//----------------------------------------------------------------------------
std::string cmCustomCommandGenerator::GetCommand(unsigned int c, std::string& configName) const
{
  std::string const& argv0 = this->CC.GetCommandLines(configName)[c][0];
  cmTarget* target = this->Makefile->FindTargetToUse(argv0.c_str());
  if(target && target->GetType() == cmTarget::EXECUTABLE &&
     (target->IsImported() || !this->Makefile->IsOn("CMAKE_CROSSCOMPILING")))
    {
    return target->GetLocation(this->Config);
    }
  return this->GE->Parse(argv0).Evaluate(this->Makefile, this->Config);
}

//----------------------------------------------------------------------------
std::string cmCustomCommandGenerator::GetCommand(unsigned int c, const 
  char *configName) const
{
	std::string config(configName);
	return this->GetCommand(c, config);
}

//----------------------------------------------------------------------------
void
cmCustomCommandGenerator
::AppendArguments(unsigned int c, std::string& cmd, std::string& configName) const
{
  cmCustomCommandLine const& commandLine = this->CC.GetCommandLines(configName)[c];
  for(unsigned int j=1;j < commandLine.size(); ++j)
    {
    std::string arg = this->GE->Parse(commandLine[j]).Evaluate(this->Makefile,
                                                               this->Config);
    cmd += " ";
    if(this->OldStyle)
      {
      cmd += this->LG->EscapeForShellOldStyle(arg.c_str());
      }
    else
      {
      cmd += this->LG->EscapeForShell(arg.c_str(), this->MakeVars);
      }
    }
}
//----------------------------------------------------------------------------
void
cmCustomCommandGenerator
::AppendArguments(unsigned int c, std::string& cmd, const 
  char *configName) const
{
	std::string config(configName);
	return this->AppendArguments(c, cmd, config);
}
