[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 10
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
[Functions]
  active = 'ic_func ic_func2'
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
    x = '0 5 10 15 20 25 30 35 40' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]

  #Piecewise Bilinear attempt 1
  #[./ic_func_3]
    #type = PiecewiseBilinear
    #data_file = '40x40.csv'
    #the specifications below correspond axes in data files to those in simulation
    #xaxis = 0
    #yaxis = 1
    # scale_factor = 0.2    
  #[../]
  
[]
[Variables]
  [./c]
  [../]
  [./w]
  [../]

[]

[ICs]
  [./c_IC]
  type = MultiBoxIC
    variable = c
    x1 = 5
    y1 = 1
    x2 = 30
    y2 = 6

    x3 = 0
    y3 = 8

    x4 = 30
    y4 = 13
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
 
  [./Periodic]
    [./all]
       auto_direction = 'x'
    [../]
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
    function = '100*exp(-c^2/0.1)'
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
  nl_max_its = 30
  nl_rel_tol = 1.0e-9
  end_time = 50000 
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .1
  [../]
[]

[Outputs]
  file_base = 'mobility_speed_M=100'
  interval = 5
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
