/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/


#ifndef SECONDDERIVATIVE_H
#define SECONDDERIVATIVE_H

#include "TimeKernel.h"

//Forward Declarations
class SecondDerivative;

template<>
InputParameters validParams<SecondDerivative>();

class SecondDerivative : public TimeKernel
{
public:
  SecondDerivative(const std::string & name, InputParameters parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  VariableValue & _u_old;
  VariableValue & _u_older;
};

#endif //SECONDDERIVATIVE_H
