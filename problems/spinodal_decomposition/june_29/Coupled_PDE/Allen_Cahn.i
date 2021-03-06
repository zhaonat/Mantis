#
# Example problem showing how to use the DerivativeParsedMaterial with CHParsed.
# The free energy is identical to that from CHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2.
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmax = 50
  ymax = 50
  elem_type = QUAD4
[]

[Variables]
  # u = AC variable
  [./u]
    order = THIRD
    family = HERMITE
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./uIC]
    type = RandomIC
    variable = u
    auto_direction = 'x y'
    max = 1
    min = -1
  [../]
[]

[Kernels]
  active = 'u_dot u_dot AC_Parsed ACint'
  [./u_dot]
    type = TimeDerivative
    variable = u
  [../]
  [./AC_Parsed]
    type = ACParsed
    variable = u

    f_name = fbulk
    mob_name = M
  [../]
  
  #this encodes the gradient energy density!
  [./ACint]
    type = ACInterface
    variable = u
    mob_name = M

    kappa_name = kappa_c
    grad_mob_name = grad_M
  [../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = fbulk
    interfacial_vars = u
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  #we need to specify one for u and one for v.
  [./mat]
    #just defines coefficients, mobility has the possibility of being a specified function, particularly in the coupled case.
    type = PFMobility
    block = 0
    mob = 1
    kappa = .25
    #original kappa is 0.5, kappa denotes coefficient of (del(c))^2, the penalty term for the interface
  [../]


  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = fbulk
    args = 'u'
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(1-u)^2*(1+u)^2
    enable_jit = true
  [../]

[]

[Functions]
  active = 'ic_func ic_func2 ic_func_3'
  [./ic_func]
    type = ParsedFunction
    value = 'sin(x)+sin(y)'
    vars = 'u'
    vals = '1'
  [../] 
  
  #have a second active function to define the ICs
  [./ic_func2]
    type = PiecewiseConstant
    axis = 1 #function of position (0 -> x, 1->y, 2 -> solve fails to converge (defining a z axis is weird for a 2D problem isn't it?))
    direction = 'left'
    x = '0 5 10 15 20 25 30 35 40' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]

  #Piecewise multilinear attempt 1
  [./ic_func_3]
    type = PiecewiseBilinear
    data_file = 'double_bubble'
    #the specifications below correspond axes in data files to those in simulation
    xaxis = 0
    yaxis = 1
    # scale_factor = 0.5
  [../]

[Postprocessors]
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = u
    boundary = top
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]

  [./order_parameter_u]
    type = ElementIntegralVariablePostprocessor
    variable = u
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9
  end_time = 10000

  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
  [../]
[]

[Outputs]
  file_base = 'Allen_Cahn_test'
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]

