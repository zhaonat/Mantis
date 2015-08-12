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

#include "LayerIC.h"
#include "libmesh/point.h"

template<>
InputParameters validParams<LayerIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<Real>("x1", "The x coordinate of the lower left-hand corner of the box");
  params.addRequiredParam<Real>("y1", "The y coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("z1", 0.0, "The z coordinate of the lower left-hand corner of the box");

  params.addRequiredParam<Real>("x2", "The x coordinate of the upper right-hand corner of the box");
  params.addRequiredParam<Real>("y2", "The y coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("z2", 0.0, "The z coordinate of the upper right-hand corner of the box");

  params.addRequiredParam<Real>("x3", "The x coordinate of the lower left-hand corner of the box");
  params.addRequiredParam<Real>("y3", "The y coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("z3", 0.0, "The z coordinate of the lower left-hand corner of the box");

  params.addRequiredParam<Real>("x4", "The x coordinate of the upper right-hand corner of the box");
  params.addRequiredParam<Real>("y4", "The y coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("z4", 0.0, "The z coordinate of the upper right-hand corner of the box");

  params.addParam<Real>("inside", 0.0, "The value of the variable inside the box");
  params.addParam<Real>("inside2", 0.0, "The value of overpressurized");
  params.addParam<Real>("outside", 0.0, "The value of the variable outside the box");
  params.addParam<Real>("numlayer", 0.0, "The value of the variable outside the box");

  return params;
}

LayerIC::LayerIC(const InputParameters & parameters) :
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
  _inside2(getParam<Real>("inside2")),
  _outside(getParam<Real>("outside")),
  _numlayer(getParam<Real>("numlayer")),
  _bottom_left(_x1,_y1,_z1),
  _top_right(_x2,_y2,_z2)

  
{}

Real
LayerIC::value(const Point & p)
{
  unsigned int j;
  for (unsigned int i=0; i<LIBMESH_DIM; ++i)
  	for (j = 0; j < _numlayer; ++j)
            /*if(p(1) > _bottom_left(1)+ j * 2 * _thickness && p(1) < _top_right(1)+j * 2 * _thickness) */
   		return _inside;
  return _outside;
  
}




