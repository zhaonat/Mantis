/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef POLYCRYSTALRANDOMIC_H
#define POLYCRYSTALRANDOMIC_H

#include "Kernel.h"
#include "InitialCondition.h"

// System includes
#include <string>

// Forward Declarations
class PolycrystalRandomIC;

template<>
InputParameters validParams<PolycrystalRandomIC>();

/**
 * PolycrystalRandomIC allows a random initial condition of a
*/
class PolycrystalRandomIC : public InitialCondition
{
public:
  /**
   * Constructor
   *
   * @param name The name given to the initial condition in the input file.
   * @param parameters The parameters object holding data for the class to use.
   * @param var_name The variable this InitialCondtion is supposed to provide values for.
   */
  PolycrystalRandomIC(const std::string & name,
                InputParameters parameters);

  /**
   * The value of the variable at a point.
   *
   * This must be overriden by derived classes.
   */
  virtual Real value(const Point & p);

private:
  unsigned int _op_num;
  unsigned int _op_index;
  unsigned int _typ;
};

#endif //POLYCRYSTALRANDOMIC_H
