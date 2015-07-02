/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "TestIC1.h"

template<>
InputParameters validParams<TestIC1>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<Real>("coefficient", "A coefficient");
 

  return params;
}

TestIC1::TestIC1(const std::string & name,
                               InputParameters parameters) :
    InitialCondition(name, parameters),_coefficient(getParam<Real>("coefficient"))
{
}

Real
TestIC1::value(const Point & p)
{
   return 2.0*_coefficient*std::abs(p(0));
}
