[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 40
  ny = 40
  nz = 40
  xmax = 40
  ymax = 40
  zmax = 40
  elem_type = HEX27
[]

[Adaptivity]
  marker = errorfrac
  steps = 1
  max_h_level = 1
  initial_steps = 1

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
  [./c_IC]
    type = FunctionIC
    function = ic_func_3
    variable = c
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
  active = 'top bottom'

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
      auto_direction = 'x z'
    [../]
  [../]
[]

[Materials]
  [./kappa]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'kappa_c'
    prop_values = '.1'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = c
    function = '25*exp(-c^2/0.1)'
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

  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'

  l_max_its = 30
  l_tol = 1.0e-3
  nl_max_its = 50
  nl_rel_tol = 1.0e-9
  end_time = 5000
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
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
    type = PiecewiseMultilinear
    data_file = 'diagonal3D.txt'
    xaxis = 0
    yaxis = 1
  [../]
[]

[Outputs]
  file_base = '3D_diagonals'
  interval = 20
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
