/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "PFFracBulkRateMaterial.h"

template<>
InputParameters validParams<PFFracBulkRateMaterial>()
{
  InputParameters params = validParams<Material>();
  params.addParam<FunctionName>("function", "", "Function describing energy release rate type parameter distribution");
  params.addParam<Real>("gc", 1.0, "Energy release rate type parameter");

  return params;
}

PFFracBulkRateMaterial::PFFracBulkRateMaterial(const std::string & name,
                                               InputParameters parameters) :
  Material(name, parameters),
  _gc(getParam<Real>("gc")),
  _gc_prop(declareProperty<Real>("gc_prop"))
{
}

void
PFFracBulkRateMaterial::initQpStatefulProperties()
{
  _gc_prop[_qp] = _gc;
}

void
PFFracBulkRateMaterial::computeQpProperties()
{
  _gc_prop[_qp] = _gc;
  /**
   * This function computes heterogeneous gc
   * User should override this function if heterogenities needs consideration
   */
  getProp();
}
