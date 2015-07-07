[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  xmin = 0.0
  xmax = 30
  ymin = 0
  ymax = 30
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
  active = 'ic_func ic_func2 ic_func_3'
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
  [./ic_func_3]
    type = PiecewiseBilinear
    data_file = 'height=10.csv'
    #the specifications below correspond axes in data files to those in simulation
    xaxis = 0
    yaxis = 1
    # scale_factor = 0.5
    
  [../]
  
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
    y1 = 4
    x2 = 30
    y2 = 8

    x3 = 0
    y3 = 12

    x4 = 30
    y4 = 16
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
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./kappa]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'kappa_c'
    prop_values = '.5'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = c
    function = '1+.95*c'
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
  l_tol = 1.0e-4
  nl_max_its = 50
  nl_rel_tol = 1.0e-10

  dt = 5.0
  num_steps = 250
[]

[Outputs]
  file_base = 'variable_mobility'
  csv = 1
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
