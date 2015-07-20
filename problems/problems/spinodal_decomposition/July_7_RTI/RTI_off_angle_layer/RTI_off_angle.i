[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 60
  ny = 25
  nz = 15
  xmax = 90
  ymax = 30
  zmax = 30
  elem_type = HEX8
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
    x = '0 10 20' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]

  [./ic_func_4]
    type = PiecewiseConstant
    axis = 1
    direction = 'right'
    x = '0 5 25'
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
    type = RTIangleIC
    variable = c
    x1 = 0
    y1 = 10
    z1 = 0

    x2 = 44.5
    y2 = 20
    z2 = 10

    x3 = 45
    y3 = 0
    z3 = 10
    
    x4 = 90
    y4 = 30
    z4 = 20

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
   active = 'right left'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the problem

  [./right]
      type = FunctionDirichletBC
      function = ic_func2
      boundary = left
      variable = c
  [../]
  [./left]
      type = FunctionDirichletBC
      function = ic_func_4
      variable = c
      boundary = right
  [../]
  [./Periodic]
    [./all]
       auto_direction = 'y z'
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
    function = '2'
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
  file_base = 'RTI_off_angle_testing'
  csv = 1
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
