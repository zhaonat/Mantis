/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PFMobility_function.h"
#include "Function.h"

template<>
InputParameters validParams<PFMobility_function>()
{
  InputParameters params = validParams<Material>();
  params.addRequiredCoupledVar("mobility_gradient", "The mobility function");
  params.addRequiredParam<FunctionName>("O","function");
  params.addParam<Real>("kappa", 1.0, "The kappa parameter for the vacancy concentration");
  return params;
}

PFMobility_function::PFMobility_function(const std::string & name,
                       InputParameters parameters) :

    Material(name, parameters),
    _M(declareProperty<Real>("M")),
    _grad_M(declareProperty<RealGradient>("grad_M")),
    _O(getFunction("O")),
    _mobility_gradient(coupledGradient("mobility_gradient")),
    _kappa_c(declareProperty<Real>("kappa_c")),
    _kappa(getParam<Real>("kappa"))
{}
Real
PFMobility_function::f()
{
  return _O.value(_t,*current_node);
}
void
PFMobility_function::computeProperties()
{

   _M[_qp] = _O.f();
   _grad_M[_qp] = _mobility_gradient[_qp];
   _kappa_c[_qp] = _kappa;
  
}
