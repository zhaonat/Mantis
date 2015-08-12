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

#include "LayerGrooveIC.h"
#include "libmesh/point.h"

/*This will create a single layer with a groove running along the z axis. user will specify two rectangles, the 1,2 rectangle is the larger layer*/
/* the 3,4 rectangle is the groove through it...which means that all the coordinates of 1,2 are larger than 3,4*/
/*there is no control in the z direction so far so the groove is infinite in z length */
template<>
InputParameters validParams<LayerGrooveIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<Real>("x1", "The x coordinate of the lower left-hand corner of the box");
  params.addRequiredParam<Real>("y1", "The y coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("z1", 0.0, "The z coordinate of the lower left-hand corner of the box");

  params.addRequiredParam<Real>("x2", "The x coordinate of the upper right-hand corner of the box");
  params.addRequiredParam<Real>("y2", "The y coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("z2", 0.0, "The z coordinate of the upper right-hand corner of the box");

  params.addParam<Real>("x3", 0.0, "The x coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("y3", 0.0, "The y coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("z3", 0.0, "The z coordinate of the lower left-hand corner of the box");

  params.addParam<Real>("x4", 0.0, "The x coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("y4", 0.0, "The y coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("z4", 0.0, "The z coordinate of the upper right-hand corner of the box");

  params.addParam<Real>("inside", 0.0, "The value of the variable inside the box");
 
  params.addParam<Real>("outside", 0.0, "The value of the variable outside the box");


  return params;
}

LayerGrooveIC::LayerGrooveIC(const InputParameters & parameters) :
  InitialCondition(parameters),
  _x1(getParam<Real>("x1")),
  _y1(getParam<Real>("y1")),
  _z1(getParam<Real>("z1")),
  _x2(getParam<Real>("x2")),
  _y2(getParam<Real>("y2")),
  _z2(getParam<Real>("z2")),
  _x3(getParam<Real>("x3")),
  _y3(getParam<Real>("y3")),
  _z3(getParam<Real>("z3")),
  _x4(getParam<Real>("x4")),
  _y4(getParam<Real>("y4")),
  _z4(getParam<Real>("z4")),
  _inside(getParam<Real>("inside")),
  _outside(getParam<Real>("outside")),
  _bottom_left(_x1,_y1,_z1),
  _top_right(_x2,_y2,_z2),
  _bottom_left_a(_x3,_y3,_z3),
  _top_right_a(_x4,_y4,_z4)
{
}

Real
LayerGrooveIC::value(const Point & p)
{ 
  double _groove_height = _y2 - _y4;
    if ( p(1) > _y4 && p(1) <= _y2)
    {
       if ( (p(0) > _x1 && p(0) < _x3) || (p(0) > _x4 && p(0) < _x2 ) )
          return _inside;
    }
    else if ( p(1) <= _y4 && p(1) >= _y1)
    {
       if (p(0) > _x1 && p(0) < _x2)
   	  return _inside;
    }
   
  return _outside;
    
}




