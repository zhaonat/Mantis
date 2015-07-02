/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef PFFRACCOUPLEDINTERFACE_H
#define PFFRACCOUPLEDINTERFACE_H

#include "KernelGrad.h"

/**
 * Phase-field fracture model
 * This class computes the contribution to residual and jacobian of the auxiliary variable beta
 * by the grad of c (damage variable)
 * Refer to formulation: Miehe et. al., Int. J. Num. Methods Engg., 2010, 83. 1273-1311 Equation 63
 */

//Forward Declarations
class PFFracCoupledInterface;

template<>
InputParameters validParams<PFFracCoupledInterface>();

class PFFracCoupledInterface : public KernelGrad
{
public:

  PFFracCoupledInterface(const std::string & name, InputParameters parameters);

protected:
  virtual RealGradient precomputeQpResidual();
  virtual RealGradient precomputeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  VariableValue & _c;
  VariableGradient & _grad_c;
  unsigned int _c_var;

private:
};
#endif //PFFRACCOUPLEDINTERFACE_H
