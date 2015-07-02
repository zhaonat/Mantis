/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef FUNCTIONMATERIALPROPERTYDESCRIPTOR_H
#define FUNCTIONMATERIALPROPERTYDESCRIPTOR_H

#include "DerivativeMaterialPropertyNameInterface.h"
#include "Material.h"

#include <string>
#include <vector>

/**
 * Material properties get fully described using this structure, including their dependent
 * variables and derivation state.
 */
class FunctionMaterialPropertyDescriptor :
  public DerivativeMaterialPropertyNameInterface
{
public:
  /*
   * The descriptor is constructed with an expression that describes the
   * material property.
   * Examples:
   *   'F'               A material property called 'F' with no declared variable
   *                     dependencies (i.e. vanishing derivatives)
   *   'F(c,phi)'        A material property called 'F' with declared dependence
   *                     on 'c' and 'phi' (uses DerivativeFunctionMaterial rules to
   *                     look up the derivatives)
   *   'a:=D[x(t),t,t]'  The second time derivative of the t-dependent material property 'x'
   *                     which will be referred to as 'a' in the function expression.
   */
  FunctionMaterialPropertyDescriptor(const std::string &, Material *);

  /// default constructor
  FunctionMaterialPropertyDescriptor();

  /// copy constructor
  FunctionMaterialPropertyDescriptor(const FunctionMaterialPropertyDescriptor &);

  /// get the fparser symbol name
  const std::string & getSymbolName() const { return _fparser_name; };

  /// get the property name
  const std::string getPropertyName() const
  {
    return propertyName(_base_name, _derivative_vars);
  };

  /// get the property reference
  const MaterialProperty<Real> & value() const
  {
    mooseAssert( _value != NULL, "_value pointer is NULL" );
    return *_value;
  }

  /// take another derivative
  void addDerivative(const std::string & var) { _derivative_vars.push_back(var); }

private:
  void parseDerivative(const std::string &);
  void parseDependentVariables(const std::string &);

  /// name used in function expression
  std::string _fparser_name;

  /// function material property base name
  std::string _base_name;

  std::vector<std::string> _dependent_vars;
  std::vector<std::string> _derivative_vars;

  /// material property value
  MaterialProperty<Real> * _value;
};

#endif // FUNCTIONMATERIALPROPERTYDESCRIPTOR_H
