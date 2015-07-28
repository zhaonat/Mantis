[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 14
  xmax = 30
  ymax = 14
  elem_type = QUAD4
[]
[Adaptivity]
  marker = errorfrac
  steps = 1
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

[Variables]
  [./c]
  [../]
  [./w]
  [../]

[]

[ICs]
  [./cIC]
    type = BoundingBoxIC
    variable = c
    x1 = 5
    y1 = 5
    x2 = 30
    y2 = 9

    inside = 1
    inside2 = 1
    outside = -1
	
    
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

[BCs]
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
    prop_values = '0.158114'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = c
    function = '100*exp(-c^2/0.1)'
    outputs = exodus
    derivative_order = 1
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
    args = c
    constant_names = W
    constant_expressions = 0.158114
    function = W*(1-c)^2*(1+c)^2
    enable_jit = true
    outputs = exodus
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
  nl_max_its = 30
  nl_rel_tol = 1.0e-9
  end_time =  10000
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .1
  [../]
[]

[Outputs]
  file_base = 'thickness=1'
  interval = 5
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
