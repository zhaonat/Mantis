[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  nz = 0
  xmin = 0
  xmax = 50
  ymin = 0
  ymax = 50
  zmin = 0
  zmax = 50
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = THIRD
    family = HERMITE
  [../]
[]

[ICs]
  [./c]
    type = SmoothCircleIC
    variable = c
    x1 = 25.0
    y1 = 25.0
    radius = 6.0
    invalue = 1.0
    outvalue = -0.8
    int_width = 4.0
  [../]
[]

[Kernels]
  [./ie_c]
    type = TimeDerivative
    variable = c
  [../]
  [./CHSolid]
    type = CHParsed
    variable = c
    mob_name = M
    f_name = F
  [../]
  [./CHInterface]
    type = CHInterface
    variable = c
    kappa_name = kappa_c
    mob_name = M
    grad_mob_name = grad_M
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
  [./constant]
    type = PFMobility
    block = 0
    mob = 1.0
    kappa = 1.0
  [../]
  [./free_energy]
    type = MathFreeEnergy
    block = 0
    f_name = F
    c = c
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 101'
  l_max_its = 20
  l_tol = 1.0e-5
  nl_max_its = 40
  nl_rel_tol = 5.0e-14
  start_time = 0.0
  num_steps = 1
  dt = 2.0
[]

[Outputs]
  # exodus = true
  output_on = 'initial timestep_end'
  [./circle_oversample]
    type = Exodus
    file_base = MathFreeEnergy_test_oversample
    refinements = 3
  [../]
  [./console]
    type = Console
    perf_log = true
    output_on = 'timestep_end nonlinear linear failed'
  [../]
[]

