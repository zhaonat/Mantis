/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/


#include "SecondDerivative.h"
#include "SubProblem.h"

template<>
InputParameters validParams<SecondDerivative>()
{
  InputParameters params = validParams<TimeKernel>();
  return params;
}

SecondDerivative::SecondDerivative(const std::string & name, InputParameters parameters) :
    TimeKernel(name, parameters),
    _u_old(valueOld()),
    _u_older(valueOlder())
{}

Real
SecondDerivative::computeQpResidual()
{
  return _test[_i][_qp]*((_u[_qp]-2*_u_old[_qp]+_u_older[_qp])/(_dt*_dt));
}

Real
SecondDerivative::computeQpJacobian()
{
  return _test[_i][_qp]*(_phi[_j][_qp]/(_dt*_dt));
}
