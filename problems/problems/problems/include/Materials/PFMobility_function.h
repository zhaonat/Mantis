/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef PFMOBILITYFUNCTION_H
#define PFMOBILITYFUNCTION_H

#include "Material.h"
#include "LinearInterpolation.h"

//Forward Declarations
class PFMobility_function;

template<>
InputParameters validParams<PFMobility_function>();

class PFMobility_function : public Material
{
public:
  PFMobility_function(const std::string & name,
             InputParameters parameters);

protected:
  virtual void computeProperties();

private:
  MaterialProperty<Real> & _M;
  MaterialProperty<RealGradient> & _grad_M;
  MaterialProperty<Real> & _kappa_c;

  Real _kappa;
  LinearInterpolation _piecewise_func; //replaces mob
 
};

#endif //PFMOBILITY_H
