[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 25
  ny = 25
  nz = 15
  xmax = 30
  ymax = 30
  zmax = 50
  elem_type = HEX8
[]


[Adaptivity]
  marker = errorfrac
  steps = 1
  max_h_level = 5
  initial_steps = 3

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
    x = '0 4 8 12 16' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
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

[ICs]
  [./c]
    type = SmoothCircleIC
    variable = c
    x1 = 15
    y1 = 15
    radius = 1
    invalue = 1.0
    outvalue = -1.0
    int_width = 1
    3D_spheres = false
    z1 = 25
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
   #active = 'right left top bottom'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the problem


 
  [./Periodic]
    [./all]
       auto_direction = 'x y z'
    [../]
  [../]
[]

#New CHParsed and CHinterface will take the mobility parameter as a derivative parsed material
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
  l_tol = 1.0e-4
  nl_max_its = 50
  nl_rel_tol = 1.0e-10
  end_time = 15000 
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
  [../]
[]

[Outputs]
  file_base = 'RTI_proof'
  csv = 1
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
