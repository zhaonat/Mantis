/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef MATDIFFUSION_H
#define MATDIFFUSION_H

#include "Diffusion.h"
#include "Material.h"

//Forward Declarations
class MatDiffusion;

template<>
InputParameters validParams<MatDiffusion>();

class MatDiffusion : public Diffusion
{
public:
  MatDiffusion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

private:
  std::string _D_name;

  MaterialProperty<Real> & _D;
};

#endif //MATDIFFUSION_H
