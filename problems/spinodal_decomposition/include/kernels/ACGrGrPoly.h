/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ACBulk.h"

#ifndef ACGRGRPOLY_H
#define ACGRGRPOLY_H

//Forward Declarations
class ACGrGrPoly;

template<>
InputParameters validParams<ACGrGrPoly>();

/**
 * This kernel calculates the residual for grain growth.
 * It calculates the residual of the ith order parameter, and the values of
 * all other order parameters are coupled variables and are stored in vals.
 */
class ACGrGrPoly : public ACBulk
{
public:
  ACGrGrPoly(const InputParameters & parameters);

protected:
  virtual Real computeDFDOP(PFFunctionType type);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  std::vector<VariableValue *> _vals;
  std::vector<unsigned int> _vals_var;

  MaterialProperty<Real> & _mu;
  MaterialProperty<Real> & _gamma;
  MaterialProperty<Real> & _tgrad_corr_mult;

  bool _has_T;
  VariableGradient * _grad_T;

  unsigned int _ncrys;
  // Real _gamma;
};

#endif //ACGRGRPOLY_H
