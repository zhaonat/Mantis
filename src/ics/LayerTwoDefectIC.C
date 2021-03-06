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

/*notes for the user*/
/*For this IC, make sure that your grid is at least as fine as the dimensions of the layer spacing and thickness...*/
/*if you create a 30x30x30 grid with 10 stripes spaced 3 units apart (3 units means each strip is 3 units thick), make sure that the axis can resolve 3 units!*/
/*the parameter x specifies location of the defect in x direction*/

#include "LayerTwoDefectIC.h"
#include "libmesh/point.h"

template<>
InputParameters validParams<LayerTwoDefectIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredParam<Real>("x1", "The x coordinate of the lower left-hand corner of the box, or where the first layer is");
  params.addRequiredParam<Real>("y1", "The y coordinate of the lower left-hand corner of the box");
  params.addParam<Real>("z1", 0.0, "The z coordinate of the lower left-hand corner of the box");

  params.addRequiredParam<Real>("x2", "The x coordinate of the upper right-hand corner of the box");
  params.addRequiredParam<Real>("y2", "The y coordinate of the upper right-hand corner of the box");
  params.addParam<Real>("z2", 0.0, "The z coordinate of the upper right-hand corner of the box");

  params.addParam<Real>("inside", 0.0, "The value of the variable inside the box");
  params.addParam<Real>("spacing", 1.0, "spacing between layers");
  params.addParam<Real>("outside", 0.0, "The value of the variable outside the box");
  params.addParam<Real>("numlayer", 0.0, "The value of the variable outside the box");
  params.addParam<Real>("thickness", 0.0, "The thickness of each layer");
  params.addParam<Real>("zthick", 1.0, "thickness in z direction, which for this IC is really a lateral thickness, y is the vertical, x is the length-wise");
  params.addParam<Real>("defectloc", 0.0, "an integer value denoting the layer that the defect will occur");
  params.addParam<Real>("defectloc2", 0.0, "an integer value denoting the layer that the defect will occur");
  params.addParam<Real>("defectthick", 0.0, "an integer value denoting the x-thickness of the defect will occur");
  params.addParam<Real>("defectthick2", 0.0, "an integer value denoting the x-thickness of the defect will occur");
  params.addParam<Real>("defectzthick", 0.0, "an integer value denoting the z-thickness of the defect");
  params.addParam<Real>("defectzthick2", 0.0, "an integer value denoting the z-thickness of the defect");
  params.addParam<Real>("defectzloc", 0.0, "an integer value denoting the z location of the defect");
  params.addParam<Real>("defectzloc2", 0.0, "an integer value denoting the z location of the defect");
  return params;
}

/* parameter order here must match the order in which you listed them in the header file (.h)! */
LayerTwoDefectIC::LayerTwoDefectIC(const std::string & name, InputParameters parameters) :
  InitialCondition(name, parameters),
  _x1(getParam<Real>("x1")),
  _y1(getParam<Real>("y1")),
  _z1(getParam<Real>("z1")),
  _x2(getParam<Real>("x2")),
  _y2(getParam<Real>("y2")),
  _z2(getParam<Real>("z2")),
  
 
  _inside(getParam<Real>("inside")),
  _spacing(getParam<Real>("spacing")),
  _outside(getParam<Real>("outside")),
  _numlayer(getParam<Real>("numlayer")),
  _thickness(getParam<Real>("thickness")),
  _zthickness(getParam<Real>("zthick")),
  _defectloc(getParam<Real>("defectloc")),
  _defectloc2(getParam<Real>("defectloc2")),
  _defect_thick(getParam<Real>("defectthick")),
  _defect_thick2(getParam<Real>("defectthick2")),
  _defect_zthick(getParam<Real>("defectzthick")),
  _defect_zthick2(getParam<Real>("defectzthick2")),
  _defect_z_loc(getParam<Real>("defectzloc")),
  _defect_z_loc2(getParam<Real>("defectzloc2")),

  /*these two things below just store the coordinates so they are somewhat extraneous but I keep them since they are derived from the BoundingBoxIC*/
  _bottom_left(_x1,_y1,_z1),
  _top_right(_x2,_y2,_z2)

/*It is critical that _name and "name" are the same...as in you can't have _numlayer and "numcrap"*/  

/*argument in p: 0 = x, y = 1, z = 2  */
{
}

Real
LayerTwoDefectIC::value(const Point & p)
{
  double j = _thickness + _spacing;
  double side_one = _x1;
  double side_two = _x1 + _defect_thick;

  double side_one2 = _x2;
  double side_two2 = _x2 + _defect_thick;

if ( ((p(1) > _bottom_left(1) + (_defectloc2) * (j)) && ( p(1) <= _bottom_left(1) + _defectloc2 * (j) + _thickness  ) && p(0) >= _bottom_left(0) && p(0) <= (_bottom_left(0) + _defect_thick) && ( _defect_z_loc2 < p(2) && p(2) < _defect_z_loc2 + _defect_zthick2))  )
  {
          return _outside;
  }


else if ( ((p(1) > _top_right(1) + (_defectloc) * (j)) && ( p(1) <= _top_right(1) + _defectloc * (j) + _thickness  ) && p(0) >= _top_right(0) && p(0) <= (_top_right(0) + _defect_thick) && ( _defect_z_loc < p(2) && p(2) < _defect_z_loc + _defect_zthick))  )
 {
          return _inside;
 }


for (j = 0; j < _numlayer; j++)
  {
     if((p(1) > _bottom_left(1) + j * (_thickness+_spacing)) && (p(1) <= (_bottom_left(1) + _thickness) + j * (_thickness + _spacing)) && ( _bottom_left(2) <= p(2) && p(2) <= _bottom_left(2) + _zthickness))
   	{return _inside;}
  }
  

  

  return _outside;
  
}




