/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef LAYERIC_H
#define LAYERIC_H

#include "InitialCondition.h"
#include "InputParameters.h"

// System includes
#include <string>

// Forward Declarations
class LayerIC;
namespace libMesh { class Point; }

template<>
InputParameters validParams<LayerIC>();

/**
 * BoundingBoxIC allows setting the initial condition of a value inside and outside of a specified box.
 * The box is aligned with the x,y,z axis... and is specified by passing in the x,y,z coordinates of the bottom
 * left point and the top right point. Each of the coordinates of the "bottom_left" point MUST be less than
 * those coordinates in the "top_right" point.
 *
 * When setting the initial condition if bottom_left <= Point <= top_right then the "inside" value is used.
 * Otherwise the "outside" value is used.
 */
class LayerIC : public InitialCondition
{
public:

  /**
   * Constructor
   *
   * @param name The name given to the initial condition in the input file.
   * @param parameters The parameters object holding data for the class to use.
   */
  LayerIC(const InputParameters & parameters);

  /**
   * The value of the variable at a point.
   *
   * This must be overridden by derived classes.
   */
  virtual Real value(const Point & p);

protected:
  Real _x1;
  Real _y1;
  Real _z1;
  Real _x2;
  Real _y2;
  Real _z2;

  Real _inside;
  Real _spacing;
  Real _outside;
  Real _numlayer;
  Real _thickness;
  Real _zthickness;
  Point _bottom_left;
  Point _top_right;
  
  
};

#endif 
