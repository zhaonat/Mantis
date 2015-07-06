/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PFMobility_function.h"

template<>
InputParameters validParams<PFMobility_function>()
{
  InputParameters params = validParams<Material>();
  params.addRequiredParam<std::vector<Real> >("independent_vals", "The vector of indepedent values for building the piecewise function");
  params.addRequiredParam<std::vector<Real> >("dependent_vals", "The vector of depedent values for building the piecewise function");
  params.addRequiredParam<FunctionName>("mob", "The mobility value");
  params.addParam<Real>("kappa", 1.0, "The kappa parameter for the vacancy concentration");
  return params;
}

PFMobility_function::PFMobility_function(const std::string & name,
                       InputParameters parameters) :

    Material(name, parameters),
    _M(declareProperty<Real>("M")),
    _grad_M(declareProperty<RealGradient>("grad_M")),
    _kappa_c(declareProperty<Real>("kappa_c")),
    _kappa(getParam<Real>("kappa"))
{}

void
PFMobility_function::computeProperties()
{
  for (unsigned int qp = 0; qp < _qrule->n_points(); ++qp)
  {
    _M[qp] = _piecewise_func.sample(_q_point[qp](2));
    _grad_M[qp] = 0;
    _kappa_c[qp] = _kappa;
  }
}
