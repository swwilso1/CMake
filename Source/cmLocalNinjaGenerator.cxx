/*============================================================================
  CMake - Cross Platform Makefile Generator
  Copyright 2011 Peter Collingbourne <peter@pcc.me.uk>
  Copyright 2011 Nicolas Despres <nicolas.despres@gmail.com>

  Distributed under the OSI-approved BSD License (the "License");
  see accompanying file Copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the License for more information.
============================================================================*/
#include "cmLocalNinjaGenerator.h"
#include "cmCustomCommandGenerator.h"
#include "cmMakefile.h"
#include "cmGlobalNinjaGenerator.h"
#include "cmNinjaTargetGenerator.h"
#include "cmGeneratedFileStream.h"
#include "cmSourceFile.h"
#include "cmake.h"

#include <assert.h>

cmLocalNinjaGenerator::cmLocalNinjaGenerator()
  : cmLocalGenerator()
  , ConfigName("")
  , HomeRelativeOutputPath("")
{
#ifdef _WIN32
  this->WindowsShell = true;
#endif
  this->TargetImplib = "$TARGET_IMPLIB";
}

//----------------------------------------------------------------------------
// Virtual public methods.

cmLocalNinjaGenerator::~cmLocalNinjaGenerator()
{
}

void cmLocalNinjaGenerator::Generate()
{
  this->SetConfigName();

  this->WriteProcessedMakefile(this->GetBuildFileStream());
#ifdef NINJA_GEN_VERBOSE_FILES
  this->WriteProcessedMakefile(this->GetRulesFileStream());
#endif

  // We do that only once for the top CMakeLists.txt file.
  if(this->isRootMakefile())
    {
    this->WriteBuildFileTop();

    this->WritePools(this->GetRulesFileStream());

    const std::string showIncludesPrefix = this->GetMakefile()
             ->GetSafeDefinition("CMAKE_CL_SHOWINCLUDES_PREFIX");
    if (!showIncludesPrefix.empty())
      {
      cmGlobalNinjaGenerator::WriteComment(this->GetRulesFileStream(),
                                           "localized /showIncludes string");
      this->GetRulesFileStream()
            << "msvc_deps_prefix = " << showIncludesPrefix << "\n\n";
      }
    }

  cmGeneratorTargetsType targets = this->GetMakefile()->GetGeneratorTargets();
  for(cmGeneratorTargetsType::iterator t = targets.begin();
      t != targets.end(); ++t)
    {
    if (t->second->Target->GetType() == cmTarget::INTERFACE_LIBRARY
        || t->second->Target->IsImported())
      {
      continue;
      }
    cmNinjaTargetGenerator* tg = cmNinjaTargetGenerator::New(t->second);
    if(tg)
      {
      tg->Generate();
      // Add the target to "all" if required.
      if (!this->GetGlobalNinjaGenerator()->IsExcluded(
            this->GetGlobalNinjaGenerator()->GetLocalGenerators()[0],
            *t->second->Target))
        this->GetGlobalNinjaGenerator()->AddDependencyToAll(t->second->Target);
      delete tg;
      }
    }

  this->WriteCustomCommandBuildStatements();
}

// Implemented in:
//   cmLocalUnixMakefileGenerator3.
// Used in:
//   Source/cmMakefile.cxx
//   Source/cmGlobalGenerator.cxx
void cmLocalNinjaGenerator::Configure()
{
  // Compute the path to use when referencing the current output
  // directory from the top output directory.
  this->HomeRelativeOutputPath =
    this->Convert(this->Makefile->GetStartOutputDirectory(), HOME_OUTPUT);
  if(this->HomeRelativeOutputPath == ".")
    {
    this->HomeRelativeOutputPath = "";
    }
  this->cmLocalGenerator::Configure();

}

// TODO: Picked up from cmLocalUnixMakefileGenerator3.  Refactor it.
std::string cmLocalNinjaGenerator
::GetTargetDirectory(cmTarget const& target) const
{
  std::string dir = cmake::GetCMakeFilesDirectoryPostSlash();
  dir += target.GetName();
#if defined(__VMS)
  dir += "_dir";
#else
  dir += ".dir";
#endif
  return dir;
}

//----------------------------------------------------------------------------
// Non-virtual public methods.

const cmGlobalNinjaGenerator*
cmLocalNinjaGenerator::GetGlobalNinjaGenerator() const
{
  return
    static_cast<const cmGlobalNinjaGenerator*>(this->GetGlobalGenerator());
}

cmGlobalNinjaGenerator* cmLocalNinjaGenerator::GetGlobalNinjaGenerator()
{
  return static_cast<cmGlobalNinjaGenerator*>(this->GetGlobalGenerator());
}

//----------------------------------------------------------------------------
// Virtual protected methods.

std::string
cmLocalNinjaGenerator::ConvertToLinkReference(std::string const& lib)
{
  return this->Convert(lib.c_str(), HOME_OUTPUT, SHELL);
}

std::string
cmLocalNinjaGenerator::ConvertToIncludeReference(std::string const& path)
{
  return this->Convert(path.c_str(), HOME_OUTPUT, SHELL);
}

//----------------------------------------------------------------------------
// Private methods.

cmGeneratedFileStream& cmLocalNinjaGenerator::GetBuildFileStream() const
{
  return *this->GetGlobalNinjaGenerator()->GetBuildFileStream();
}

cmGeneratedFileStream& cmLocalNinjaGenerator::GetRulesFileStream() const
{
  return *this->GetGlobalNinjaGenerator()->GetRulesFileStream();
}

const cmake* cmLocalNinjaGenerator::GetCMakeInstance() const
{
  return this->GetGlobalGenerator()->GetCMakeInstance();
}

cmake* cmLocalNinjaGenerator::GetCMakeInstance()
{
  return this->GetGlobalGenerator()->GetCMakeInstance();
}

bool cmLocalNinjaGenerator::isRootMakefile() const
{
  return (strcmp(this->Makefile->GetCurrentDirectory(),
                 this->GetCMakeInstance()->GetHomeDirectory()) == 0);
}

void cmLocalNinjaGenerator::WriteBuildFileTop()
{
  // For the build file.
  this->WriteProjectHeader(this->GetBuildFileStream());
  this->WriteNinjaFilesInclusion(this->GetBuildFileStream());

  // For the rule file.
  this->WriteProjectHeader(this->GetRulesFileStream());
}

void cmLocalNinjaGenerator::WriteProjectHeader(std::ostream& os)
{
  cmGlobalNinjaGenerator::WriteDivider(os);
  os
    << "# Project: " << this->GetMakefile()->GetProjectName() << std::endl
    << "# Configuration: " << this->ConfigName << std::endl
    ;
  cmGlobalNinjaGenerator::WriteDivider(os);
}

void cmLocalNinjaGenerator::WritePools(std::ostream& os)
{
  cmGlobalNinjaGenerator::WriteDivider(os);

  const char* jobpools = this->GetCMakeInstance()
                               ->GetProperty("JOB_POOLS", cmProperty::GLOBAL);
  if (jobpools)
    {
    cmGlobalNinjaGenerator::WriteComment(os,
                            "Pools defined by global property JOB_POOLS");
    std::vector<std::string> pools;
    cmSystemTools::ExpandListArgument(jobpools, pools);
    for (size_t i = 0; i < pools.size(); ++i)
      {
      const std::string pool = pools[i];
      const std::string::size_type eq = pool.find("=");
      unsigned int jobs;
      if (eq != std::string::npos &&
          sscanf(pool.c_str() + eq, "=%u", &jobs) == 1)
        {
        os << "pool " << pool.substr(0, eq) << std::endl;
        os << "  depth = " << jobs << std::endl;
        os << std::endl;
        }
      else
        {
        cmSystemTools::Error("Invalid pool defined by property 'JOB_POOLS': ",
                             pool.c_str());
        }
      }
    }
}

void cmLocalNinjaGenerator::WriteNinjaFilesInclusion(std::ostream& os)
{
  cmGlobalNinjaGenerator::WriteDivider(os);
  os
    << "# Include auxiliary files.\n"
    << "\n"
    ;
  cmGlobalNinjaGenerator::WriteInclude(os,
                                      cmGlobalNinjaGenerator::NINJA_RULES_FILE,
                                       "Include rules file.");
  os << "\n";
}

void cmLocalNinjaGenerator::SetConfigName()
{
  // Store the configuration name that will be generated.
  if(const char* config =
       this->GetMakefile()->GetDefinition("CMAKE_BUILD_TYPE"))
    {
    // Use the build type given by the user.
    this->ConfigName = config;
    }
  else
    {
    // No configuration type given.
    this->ConfigName = "";
    }
}

void cmLocalNinjaGenerator::WriteProcessedMakefile(std::ostream& os)
{
  cmGlobalNinjaGenerator::WriteDivider(os);
  os
    << "# Write statements declared in CMakeLists.txt:" << std::endl
    << "# " << this->Makefile->GetCurrentListFile() << std::endl
    ;
  if(this->isRootMakefile())
    os << "# Which is the root file." << std::endl;
  cmGlobalNinjaGenerator::WriteDivider(os);
  os << std::endl;
}

std::string cmLocalNinjaGenerator::ConvertToNinjaPath(const char *path)
{
  std::string convPath = this->Convert(path, cmLocalGenerator::HOME_OUTPUT);
#ifdef _WIN32
  cmSystemTools::ReplaceString(convPath, "/", "\\");
#endif
  return convPath;
}

void
cmLocalNinjaGenerator
::AppendTargetOutputs(cmTarget* target, cmNinjaDeps& outputs)
{
  this->GetGlobalNinjaGenerator()->AppendTargetOutputs(target, outputs);
}

void
cmLocalNinjaGenerator
::AppendTargetDepends(cmTarget* target, cmNinjaDeps& outputs)
{
  this->GetGlobalNinjaGenerator()->AppendTargetDepends(target, outputs);
}

void cmLocalNinjaGenerator::AppendCustomCommandDeps(const cmCustomCommand *cc,
                                                    cmNinjaDeps &ninjaDeps)
{
  const std::vector<std::string> &deps = cc->GetDepends();
  for (std::vector<std::string>::const_iterator i = deps.begin();
       i != deps.end(); ++i) {
    std::string dep;
    if (this->GetRealDependency(i->c_str(), this->GetConfigName(), dep))
      ninjaDeps.push_back(ConvertToNinjaPath(dep.c_str()));
  }
}

std::string cmLocalNinjaGenerator::BuildCommandLine(
                                    const std::vector<std::string> &cmdLines)
{
  // If we have no commands but we need to build a command anyway, use ":".
  // This happens when building a POST_BUILD value for link targets that
  // don't use POST_BUILD.
  if (cmdLines.empty())
#ifdef _WIN32
    return "cd .";
#else
    return ":";
#endif

  cmOStringStream cmd;
  for (std::vector<std::string>::const_iterator li = cmdLines.begin();
       li != cmdLines.end(); ++li)
#ifdef _WIN32
    {
    if (li != cmdLines.begin())
      {
      cmd << " && ";
      }
    else if (cmdLines.size() > 1)
      {
      cmd << "cmd.exe /C \"";
      }
    cmd << *li;
    }
  if (cmdLines.size() > 1)
    {
    cmd << "\"";
    }
#else
    {
    if (li != cmdLines.begin())
      {
      cmd << " && ";
      }
    cmd << *li;
    }
#endif
  return cmd.str();
}

void cmLocalNinjaGenerator::AppendCustomCommandLines(const cmCustomCommand *cc,
                                            std::vector<std::string> &cmdLines)
{
  cmCustomCommandGenerator ccg(*cc, this->GetConfigName(), this->Makefile);
  if (ccg.GetNumberOfCommands(this->GetConfigName()) > 0) {
    const char* wd = cc->GetWorkingDirectory();
    if (!wd)
      wd = this->GetMakefile()->GetStartOutputDirectory();

    cmOStringStream cdCmd;
#ifdef _WIN32
        std::string cdStr = "cd /D ";
#else
        std::string cdStr = "cd ";
#endif
    cdCmd << cdStr << this->ConvertToOutputFormat(wd, SHELL);
    cmdLines.push_back(cdCmd.str());
  }

  std::string launcher = this->MakeCustomLauncher(*cc);

  for (unsigned i = 0;
    i != ccg.GetNumberOfCommands(this->GetConfigName()); ++i) {
    cmdLines.push_back(launcher +
      this->ConvertToOutputFormat(ccg.GetCommand(i,
        this->GetConfigName()).c_str(), SHELL));

    std::string& cmd = cmdLines.back();
    ccg.AppendArguments(i, cmd, this->GetConfigName());
  }
}

void
cmLocalNinjaGenerator::WriteCustomCommandBuildStatement(
  cmCustomCommand const *cc, const cmNinjaDeps& orderOnlyDeps)
{
  if (this->GetGlobalNinjaGenerator()->SeenCustomCommand(cc))
    return;

  const std::vector<std::string> &outputs = cc->GetOutputs();
  cmNinjaDeps ninjaOutputs(outputs.size()), ninjaDeps;

  std::transform(outputs.begin(), outputs.end(),
                 ninjaOutputs.begin(), MapToNinjaPath());
  this->AppendCustomCommandDeps(cc, ninjaDeps);

  for (cmNinjaDeps::iterator i = ninjaOutputs.begin(); i != ninjaOutputs.end();
       ++i)
    this->GetGlobalNinjaGenerator()->SeenCustomCommandOutput(*i);

  std::vector<std::string> cmdLines;
  this->AppendCustomCommandLines(cc, cmdLines);

  if (cmdLines.empty()) {
    this->GetGlobalNinjaGenerator()->WritePhonyBuild(
      this->GetBuildFileStream(),
      "Phony custom command for " +
      ninjaOutputs[0],
      ninjaOutputs,
      ninjaDeps,
      cmNinjaDeps(),
      orderOnlyDeps,
      cmNinjaVars());
  } else {
    this->GetGlobalNinjaGenerator()->WriteCustomCommandBuild(
      this->BuildCommandLine(cmdLines),
      this->ConstructComment(*cc),
      "Custom command for " + ninjaOutputs[0],
      ninjaOutputs,
      ninjaDeps,
      orderOnlyDeps);
  }
}

void cmLocalNinjaGenerator::AddCustomCommandTarget(cmCustomCommand const* cc,
                                                   cmTarget* target)
{
  this->CustomCommandTargets[cc].insert(target);
}

void cmLocalNinjaGenerator::WriteCustomCommandBuildStatements()
{
  for (CustomCommandTargetMap::iterator i = this->CustomCommandTargets.begin();
       i != this->CustomCommandTargets.end(); ++i) {
    // A custom command may appear on multiple targets.  However, some build
    // systems exist where the target dependencies on some of the targets are
    // overspecified, leading to a dependency cycle.  If we assume all target
    // dependencies are a superset of the true target dependencies for this
    // custom command, we can take the set intersection of all target
    // dependencies to obtain a correct dependency list.
    //
    // FIXME: This won't work in certain obscure scenarios involving indirect
    // dependencies.
    std::set<cmTarget*>::iterator j = i->second.begin();
    assert(j != i->second.end());
    std::vector<std::string> ccTargetDeps;
    this->AppendTargetDepends(*j, ccTargetDeps);
    std::sort(ccTargetDeps.begin(), ccTargetDeps.end());
    ++j;

    for (; j != i->second.end(); ++j) {
      std::vector<std::string> jDeps, depsIntersection;
      this->AppendTargetDepends(*j, jDeps);
      std::sort(jDeps.begin(), jDeps.end());
      std::set_intersection(ccTargetDeps.begin(), ccTargetDeps.end(),
                            jDeps.begin(), jDeps.end(),
                            std::back_inserter(depsIntersection));
      ccTargetDeps = depsIntersection;
    }

    this->WriteCustomCommandBuildStatement(i->first, ccTargetDeps);
  }
}

std::string cmLocalNinjaGenerator::MakeCustomLauncher(
  const cmCustomCommand& cc)
{
  const char* property = "RULE_LAUNCH_CUSTOM";
  const char* property_value = this->Makefile->GetProperty(property);

  if(!property_value || !*property_value)
  {
    return std::string();
  }

  // Expand rules in the empty string.  It may insert the launcher and
  // perform replacements.
  RuleVariables vars;
  vars.RuleLauncher = property;
  std::string output;
  const std::vector<std::string>& outputs = cc.GetOutputs();
  if(!outputs.empty())
  {
    RelativeRoot relative_root =
      cc.GetWorkingDirectory() ? NONE : START_OUTPUT;

    output = this->Convert(outputs[0].c_str(), relative_root, SHELL);
  }
  vars.Output = output.c_str();

  std::string launcher;
  this->ExpandRuleVariables(launcher, vars);
  if(!launcher.empty())
  {
    launcher += " ";
  }

  return launcher;
}
