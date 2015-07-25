[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 50
  ny = 80
  nz = 65
  xmax = 50
  ymax = 40
  zmax = 50
  elem_type = HEX8
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

[]
[Variables]
  [./c]
  [../]
  [./w]
  [../]
[]

[ICs]
  [./c_IC]
    type = WeldIC
    variable = c
    
    #x1 is the location of the defect!
    x1 = 23
    y1 = 2
    z1 = 0
    
    x2 = 23
    y2 = 0
    z2 = 0
    inside = 1
    spacing = 2
    outside = -1
    numlayer = 10
    thickness = 2

    zthick = 60
    defectthick = 5
    defectloc = 9
    defectloc2 = 0
    defectzthick = 50
    defectzthick2 = 50
    defectzloc = 0
    defectzloc2 = 0 

    anglespace = 4
    slope = 4

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

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31      lu      1'

  l_max_its = 30
  l_tol = 1.0e-3
  nl_max_its = 50
  nl_rel_tol = 1.0e-9
  end_time = 5000
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 2
  [../]
[]

[Outputs]
  file_base = 'TEST'
  interval = 1
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
