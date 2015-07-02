[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  xmin = 0.0
  xmax = 30.0
  ymin = 0.0
  ymax = 30.0
  elem_type = QUAD4
[]

[Variables]
  [./c]
    [./InitialCondition]
      type = CrossIC
      x1 = 0.0
      x2 = 30.0
      y1 = 0.0
      y2 = 30.0
    [../]
  [../]
  [./w]
  [../]
[]

[Preconditioning]
active = 'SMP'
  [./PBP]
   type = PBP
   solve_order = 'w c'
   preconditioner = 'AMG ASM'
   off_diag_row = 'c '
   off_diag_column = 'w '
  [../]

  [./SMP]
   type = SMP
   off_diag_row = 'w c'
   off_diag_column = 'c w'
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
  [../]

  [./time]
    type = CoupledImplicitEuler
    variable = w
    v = c
  [../]

[]

[BCs]
  [./Periodic]
    [./top_bottom]
      primary = 0
      secondary = 2
      translation = '0 30.0 0'
    [../]

    [./left_right]
      primary = 1
      secondary = 3
      translation = '-30.0 0 0'
    [../]
  [../]
[]

[Materials]

  [./constant]
    type = PFMobility
    block = 0
    mob = 1.0
    kappa = 2.0
  [../]
  [./free_energy]
    type = MathFreeEnergy
    block = 0
    f_name = F
    c = c
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  l_max_its = 30
  l_tol = 1.0e-3

  nl_max_its = 50
  nl_rel_tol = 1.0e-10

  dt = 10.0
  num_steps = 2
[]

[Outputs]
  exodus = true
  output_on = 'initial timestep_end'
  [./console]
    type = Console
    perf_log = true
    output_on = 'timestep_end failed nonlinear linear'
  [../]
[]
