/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2000-2009 Kitware, Inc., Insight Software Consortium

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmCustomCommand.h"

#include "cmMakefile.h"

//----------------------------------------------------------------------------
cmCustomCommand::cmCustomCommand()
{
  this->HaveComment = false;
  this->EscapeOldStyle = true;
  this->EscapeAllowMakeVars = false;
}

//----------------------------------------------------------------------------
cmCustomCommand::cmCustomCommand(const cmCustomCommand& r):
  Outputs(r.Outputs),
  Depends(r.Depends),
  CommandLines(r.CommandLines),
  ConfigurationCommandLines(r.ConfigurationCommandLines),
  HaveComment(r.HaveComment),
  Comment(r.Comment),
  WorkingDirectory(r.WorkingDirectory),
  EscapeAllowMakeVars(r.EscapeAllowMakeVars),
  EscapeOldStyle(r.EscapeOldStyle),
  Backtrace(new cmListFileBacktrace(*r.Backtrace))
{
}

//----------------------------------------------------------------------------
cmCustomCommand::cmCustomCommand(cmMakefile* mf,
                                 const std::vector<std::string>& outputs,
                                 const std::vector<std::string>& depends,
                                 const cmCustomCommandLines& commandLines,
                                 const char* comment,
                                 const char* workingDirectory):
  Outputs(outputs),
  Depends(depends),
  CommandLines(commandLines),
  HaveComment(comment?true:false),
  Comment(comment?comment:""),
  WorkingDirectory(workingDirectory?workingDirectory:""),
  EscapeAllowMakeVars(false),
  EscapeOldStyle(true),
  Backtrace(new cmListFileBacktrace)
{
  this->EscapeOldStyle = true;
  this->EscapeAllowMakeVars = false;
  if(mf)
    {
    mf->GetBacktrace(*this->Backtrace);
    }
}

//----------------------------------------------------------------------------
cmCustomCommand::cmCustomCommand(cmMakefile* mf,
								 const std::vector<std::string>& outputs,
                                 const std::vector<std::string>& depends,
                                 const cmCustomCommandLines& commandLines,
                                 const char* comment,
                                 const char* workingDirectory,
                                 const std::string& configName):
  Outputs(outputs),
  Depends(depends),
  HaveComment(comment?true:false),
  Comment(comment?comment:""),
  WorkingDirectory(workingDirectory?workingDirectory:""),
  EscapeAllowMakeVars(false),
  EscapeOldStyle(true),
  Backtrace(new cmListFileBacktrace)
{
  ConfigurationCommandLines[configName] = commandLines;
  this->EscapeOldStyle = true;
  this->EscapeAllowMakeVars = false;
  if(mf)
    {
    mf->GetBacktrace(*this->Backtrace);
    }
}
//----------------------------------------------------------------------------
cmCustomCommand::~cmCustomCommand()
{
  delete this->Backtrace;
}

//----------------------------------------------------------------------------
const std::vector<std::string>& cmCustomCommand::GetOutputs() const
{
  return this->Outputs;
}

//----------------------------------------------------------------------------
const char* cmCustomCommand::GetWorkingDirectory() const
{
  if(this->WorkingDirectory.size() == 0)
    {
    return 0;
    }
  return this->WorkingDirectory.c_str();
}

//----------------------------------------------------------------------------
const std::vector<std::string>& cmCustomCommand::GetDepends() const
{
  return this->Depends;
}

//----------------------------------------------------------------------------
const cmCustomCommandLines& cmCustomCommand::GetCommandLines() const
{
  return this->CommandLines;
}

//----------------------------------------------------------------------------
const cmCustomCommandLines& cmCustomCommand::GetCommandLines(const 
  std::string& configName) const
{
  std::map<std::string, cmCustomCommandLines>::const_iterator ci =
   this->ConfigurationCommandLines.find(configName);
  if(ci != this->ConfigurationCommandLines.end())
    {
      return ci->second;
    }
  return this->CommandLines;
}

//----------------------------------------------------------------------------
const cmCustomCommandLines& cmCustomCommand::GetCommandLines(const 
  char *configName) const
{
  std::string config(configName);
  return this->GetCommandLines(config);
}

//----------------------------------------------------------------------------
const char* cmCustomCommand::GetComment() const
{
  const char* no_comment = 0;
  return this->HaveComment? this->Comment.c_str() : no_comment;
}

//----------------------------------------------------------------------------
void cmCustomCommand::AppendCommands(const cmCustomCommandLines& commandLines)
{
  for(cmCustomCommandLines::const_iterator i=commandLines.begin();
      i != commandLines.end(); ++i)
    {
    this->CommandLines.push_back(*i);
    }
}

//----------------------------------------------------------------------------
void cmCustomCommand::AppendCommands(const cmCustomCommandLines& commandLines,
  const std::string& configName)
{
  cmCustomCommandLines configLines = 
    this->ConfigurationCommandLines[configName];
  for(cmCustomCommandLines::const_iterator ci = commandLines.begin();
    ci != commandLines.end(); ci++)
    {
    configLines.push_back(*ci);
    }
  this->ConfigurationCommandLines[configName] = configLines;
}

//----------------------------------------------------------------------------
void cmCustomCommand::AppendCommands(const cmCustomCommandLines& commandLines,
  const char *configName)
{
  std::string config(configName);
  cmCustomCommandLines configLines = 
    this->ConfigurationCommandLines[config];
  for(cmCustomCommandLines::const_iterator ci = commandLines.begin();
    ci != commandLines.end(); ci++)
    {
    configLines.push_back(*ci);
    }
  this->ConfigurationCommandLines[config] = configLines;
}

//----------------------------------------------------------------------------
void cmCustomCommand::AppendDepends(const std::vector<std::string>& depends)
{
  for(std::vector<std::string>::const_iterator i=depends.begin();
      i != depends.end(); ++i)
    {
    this->Depends.push_back(*i);
    }
}

//----------------------------------------------------------------------------
bool cmCustomCommand::GetEscapeOldStyle() const
{
  return this->EscapeOldStyle;
}

//----------------------------------------------------------------------------
void cmCustomCommand::SetEscapeOldStyle(bool b)
{
  this->EscapeOldStyle = b;
}

//----------------------------------------------------------------------------
bool cmCustomCommand::GetEscapeAllowMakeVars() const
{
  return this->EscapeAllowMakeVars;
}

//----------------------------------------------------------------------------
void cmCustomCommand::SetEscapeAllowMakeVars(bool b)
{
  this->EscapeAllowMakeVars = b;
}

//----------------------------------------------------------------------------
cmListFileBacktrace const& cmCustomCommand::GetBacktrace() const
{
  return *this->Backtrace;
}

//----------------------------------------------------------------------------
bool cmCustomCommand::HasCommandLines() const
{
  if(! this->CommandLines.empty())
    {
    return true;
    }

  return false;
}

//----------------------------------------------------------------------------
bool cmCustomCommand::HasCommandLines(const std::string& configName) const
{
  if(! this->ConfigurationCommandLines.empty())
    {
    for(std::map<std::string,cmCustomCommandLines>::const_iterator ci =
      this->ConfigurationCommandLines.begin(); ci != 
      this->ConfigurationCommandLines.end(); ci++)
      {
      if(configName == ci->first && (! ci->second.empty()))
        {
        return true;
        }
      }
    }
  return false;
}

//----------------------------------------------------------------------------
bool cmCustomCommand::HasCommandLines(const char *configName) const
{
  std::string config(configName);
  return this->HasCommandLines(config);
}

//----------------------------------------------------------------------------
cmCustomCommand::ImplicitDependsList const&
cmCustomCommand::GetImplicitDepends() const
{
  return this->ImplicitDepends;
}

//----------------------------------------------------------------------------
void cmCustomCommand::SetImplicitDepends(ImplicitDependsList const& l)
{
  this->ImplicitDepends = l;
}

//----------------------------------------------------------------------------
void cmCustomCommand::AppendImplicitDepends(ImplicitDependsList const& l)
{
  this->ImplicitDepends.insert(this->ImplicitDepends.end(),
                               l.begin(), l.end());
}
