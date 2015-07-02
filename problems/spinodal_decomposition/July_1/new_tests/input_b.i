#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2 (lev landau).
#

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
  max_h_level = 4
  initial_steps = 4

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

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = MultiBoxIC
    variable = c
    x1 = 5
    y1 = 2
    x2 = 30
    y2 = 6

    x3 = 0
    y3 = 8

    x4 = 30
    y4 = 12
    inside = 1
    inside2 = 1
    outside = -1
	
    
  [../]
[]

[Functions]
  active = 'ic_func ic_func2 ic_func_4'
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
    x = '0 2 6 8 12' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]

  [./ic_func_4]
    type = PiecewiseConstant
    axis = 1
    direction = 'left'
    x = '0 8 12'
    y = '-1 1 -1'

  [../]
  
[]

[Kernels]
  [./c_dot]
    type = CoupledImplicitEuler
    variable = w
    v = c
  [../]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = fbulk
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]


[BCs]
   #active = 'right left top bottom'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the problem


  [./right]
    type = FunctionDirichletBC
    variable = c
    boundary = 'right'
    function = ic_func2
  [../]

  [./left]
    type = FunctionDirichletBC
    variable = c
    boundary = 'left'
    function = ic_func_4
  [../]
  
  [./top]
    type = DirichletBC
    variable = c
    boundary = 'top'
    value = 0
  [../]

  [./bottom]
    type = DirichletBC
    variable = c
    boundary = 'bottom'
    value = 0
  [../]
 
  #[./Periodic]
    #[./all]
       #auto_direction = 'y'
    #[../]
  #[../]
[]

[Materials]
  [./mat]
    type = PFMobility_function
    block = 0
    independent_vals = '1 1 1'
    dependent_vals = '0 3 2'
    kappa = 0.1
    mob = 1
    #kappa above is the experimentally agreed upon input value (Dina and Nathan)
    #kappa is the coefficient of (del(c))^2, the penalty term of the cahn_hilliard
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = fbulk
    args = c
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(1-c)^2*(1+c)^2
    enable_jit = true
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  # petsc_options_value = 'hypre boomeramg 31'
  type = Transient
  scheme = bdf2
  #dt = timestep
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9
  end_time = 15000
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
  [../]
[]

[Outputs]
  file_base = 'close_packed_bilayer'
  interval = 1 #interval only outputs the results after every n  timesteps
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]

