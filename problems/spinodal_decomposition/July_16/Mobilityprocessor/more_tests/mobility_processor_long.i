[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 30
  xmax = 150
  ymax = 40
  elem_type = QUAD4
[]


[Adaptivity]
  marker = errorfrac
  steps = 1
  #increase the bottom two values in cluster sims!!!!
  max_h_level = 2
  initial_steps = 2

  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = c
    [../]
  [../]

  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.5
      coarsen = 0.1
      indicator = error
    [../]
  [../]
[]
[Functions]
  active = 'ic_func ic_func2 ic_func_3 ic_func_4'
  [./ic_func]
    type = ParsedFunction
    value = 'sin(x)+sin(y)'
    vars = 'c'
    vals = '1'
  [../] 
  
  #have a second active function to define the ICs
  [./ic_func2]
    type = PiecewiseConstant
    axis = 1 #function of position (0 -> x, 1->y, 2 -> solve fails to converge (defining a z axis is weird for a 2D problem isn't it?))
    direction = 'left'
    x = '0 4 8 12 16' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]
  [./ic_func_3]
    type = PiecewiseBilinear
    data_file = '40x150.csv'
   
    xaxis = 0
    yaxis = 1    
  [../]
  [./ic_func_4]
    type = PiecewiseConstant
    axis = 1
    direction = 'left'
    x = '0 12 16'
    y = '-1 1 -1'

  [../]
  
[]
[Variables]
  [./c]
  [../]
  [./w]
  [../]
[]
[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mobility_var]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./grad_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
[ICs]
  [./c]
    type = FunctionIC
    variable = c
    function = ic_func_3
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = F
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = M
    args = c
  [../]
  [./time]
    type = CoupledImplicitEuler
    variable = w
    v = c
  [../]
[]
[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = F
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]

  [./CrossGradEnergy]
    type = CrossTermGradientFreeEnergy
    kappa_names = kappa_c
    variable = grad_energy
    interfacial_vars = c
  [../]

[]

[BCs]
   #active = 'right left top bottom'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the problem
   [./top]
    type = NeumannBC
    variable = c
    boundary = 'top'
    value = 0
  [../]

  [./bottom]
    type = NeumannBC
    variable = c
    boundary = 'bottom'
    value = 0
  [../]
  [./left]
    type = NeumannBC
    variable = c
    boundary = 'right'
    value = 0
  [../]
  [./right]
    type = NeumannBC
    variable = c
    boundary = 'left'
    value = 0
  [../]


[]

[Materials]
  [./kappa]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'kappa_c'
    prop_values = '0.1'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = c
    function = 'exp(-c^2/0.1)'
    outputs = exodus
    derivative_order = 1
  [../]
  [./free_energy]
    type = MathEBFreeEnergy
    block = 0
    f_name = F
    c = c
  [../]
[]

[Preconditioning]
  [./SMP]
   type = SMP
   off_diag_row = 'w c'
   off_diag_column = 'c w'
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31      lu      1'

  l_max_its = 30
  l_tol = 1.0e-3
  nl_max_its = 50
  nl_rel_tol = 1.0e-9
  end_time = 700000 
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
  [../]
[]

[Postprocessors]
  
  #what is this? I think it's a measurement of c at the top boundary of the system
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  
  #if the above hypothesis is right, this should show a very rapid change when the layer RTI decomposes
  [./right]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = right
  [../]

  #gibbs free energy
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
    
  [./Integrated_grad_energy]
    type = ElementIntegralVariablePostprocessor
    variable = grad_energy
  [../]

  [./average_composition]
    type = ElementAverageValue
    variable = c
  [../]

  #check to see conservation is satisfied
  [./order_parameter]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]

  #any measure of entropy?
  #system is effectively isothermal
  #if we integrate mobility, it is simply a measure of how much c is changing...
  
  #measure how far the system is from equilibrium (how fast is the chemical potential changing?)
  #at equilibrium, the chemical potential is constant across all portions of the system)
  [./chemical_potential_time_derivative]
    type = ElementAverageTimeDerivative
    variable = w
  [../]
  
  #the concentration will change fastest wherever the layer is coarsening, hopefully
  [./c_time_derivative]
    type = ElementAverageTimeDerivative
    variable = c
  [../]


  [./chemical_potential_integral]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]

  [./SideFluxIntegral]
    type = SideFluxIntegral
    diffusivity = M
    variable = c
  [../]
  [./mobility_integral]
    type = ExpFunction
    variable = c
  [../]

  #need a measure of how much interfacial area is left at any given time

  
[]

[Outputs]
  file_base = 'interfaceenergy_long_track'
  csv = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
