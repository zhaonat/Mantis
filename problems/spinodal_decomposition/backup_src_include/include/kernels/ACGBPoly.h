/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ACBulk.h"

#ifndef ACGBPOLY_H
#define ACGBPOLY_H

//Forward Declarations
class ACGBPoly;

template<>
InputParameters validParams<ACGBPoly>();

class ACGBPoly : public ACBulk
{
public:
  ACGBPoly(const std::string & name, InputParameters parameters);

protected:
  virtual Real computeDFDOP(PFFunctionType type);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  /**
   * Coupled things come through as std::vector _refernces_.
   *
   * Since this is a reference it MUST be set in the Initialization List of the
   * constructor!
   */
  VariableValue & _c;
  unsigned int _c_var;

  MaterialProperty<Real> & _mu;
  MaterialProperty<Real> & _gamma;

  Real _en_ratio;
};

#endif //ACGBPOLY_H
