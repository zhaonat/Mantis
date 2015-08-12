#include "MantisApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "SecondDerivative.h"
#include "MultiBoxIC.h"
#include "RTI_IC.h"
#include "RTIangleIC.h"

template<>
InputParameters validParams<MantisApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

MantisApp::MantisApp(InputParameters parameters) :
    MooseApp(parameters)
{

  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  MantisApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  MantisApp::associateSyntax(_syntax, _action_factory);
}

MantisApp::~MantisApp()
{
}

// External entry point for dynamic application loading
extern "C" void MantisApp__registerApps() { MantisApp::registerApps(); }
void
MantisApp::registerApps()
{
  registerApp(MantisApp);
}

// External entry point for dynamic object registration
extern "C" void MantisApp__registerObjects(Factory & factory) { MantisApp::registerObjects(factory); }
void
MantisApp::registerObjects(Factory & factory)
{
  registerInitialCondition(MultiBoxIC);
  registerInitialCondition(RTI_IC);
  registerKernel(SecondDerivative);
  registerInitialCondition(RTIangleIC);
  
}

// External entry point for dynamic syntax association
extern "C" void MantisApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { MantisApp::associateSyntax(syntax, action_factory); }
void
MantisApp::associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
}
