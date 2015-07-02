/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef RNDBOUNDINGBOXIC_H
#define RNDBOUNDINGBOXIC_H

#include "Kernel.h"
#include "InitialCondition.h"

// System includes
#include <string>

// Forward Declarations
class RndBoundingBoxIC;

template<>
InputParameters validParams<RndBoundingBoxIC>();

/**
 * RndBoundingBoxIC allows setting the initial condition of a value inside and outside of a specified box.
 * The box is aligned with the x,y,z axis... and is specified by passing in the x,y,z coordinates of the bottom
 * left point and the top right point. Each of the coordinates of the "bottom_left" point MUST be less than
 * those coordinates in the "top_right" point.
 *
 * When setting the initial condition if bottom_left <= Point <= top_right then the "inside" value is used.
 * Otherwise the "outside" value is used.
 **/
class RndBoundingBoxIC : public InitialCondition
{
public:
  /**
   * Constructor
   *
   * @param name The name given to the initial condition in the input file.
   * @param parameters The parameters object holding data for the class to use.
   * @param var_name The variable this InitialCondtion is supposed to provide values for.
   */
  RndBoundingBoxIC(const std::string & name,
                InputParameters parameters);

  /**
   * The value of the variable at a point.
   *
   * This must be overriden by derived classes.
   */
  virtual Real value(const Point & p);

private:
  Real _x1;
  Real _y1;
  Real _z1;
  Real _x2;
  Real _y2;
  Real _z2;
  Real _mx_invalue;
  Real _mx_outvalue;
  Real _mn_invalue;
  Real _mn_outvalue;
  Real _range_invalue;
  Real _range_outvalue;

  Point _bottom_left;
  Point _top_right;
};

#endif //RNDBOUNDINGBOXIC_H
