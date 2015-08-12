/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef RECONVARIC_H
#define RECONVARIC_H

#include "InitialCondition.h"
#include "EBSDReader.h"
#include "PolycrystalICTools.h"

// Forward Declarations
class ReconVarIC;

template<>
InputParameters validParams<ReconVarIC>();

/**
 * ReconVarIC creates a polycrystal initial condition from an EBSD dataset
*/
class ReconVarIC : public InitialCondition
{
public:

  ReconVarIC(const InputParameters & parameters);

  virtual void initialSetup();
  virtual Real value(const Point & /*p*/);

private:
  MooseMesh & _mesh;
  NonlinearSystem & _nl;
  const EBSDReader & _ebsd_reader;

  bool _consider_phase;
  unsigned int _phase;
  bool _all_to_one;
  unsigned int _op_num;
  unsigned int _op_index;

  unsigned int _grain_num;

  std::vector<Point> _centerpoints;
  std::vector<Real> _assigned_op;
  std::map<dof_id_type, std::vector<Real> > node_to_grn_weight_map;
};

#endif //RECONVARIC_H
