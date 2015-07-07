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
#include "Function.h"
#include "NodalBC.h"
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
  /*virtual Real value(const Point & p);*/
  Real f();

private:
  MaterialProperty<Real> & _M;
  MaterialProperty<RealGradient> & _grad_M;
  
  Function & _O;
  VariableGradient & _mobility_gradient;

  MaterialProperty<Real> & _kappa_c;
  Real _kappa;
  
  
 
};

#endif //PFMOBILITY_H
