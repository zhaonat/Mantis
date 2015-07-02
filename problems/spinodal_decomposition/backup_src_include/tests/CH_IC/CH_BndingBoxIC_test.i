[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 2
  nz = 0
  xmax = 50
  ymax = 25
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
[]

[Variables]
  [./c]
    order = THIRD
    family = HERMITE
    [./InitialCondition]
      type = BoundingBoxIC
      x1 = 15.0
      x2 = 35.0
      y1 = 0.0
      y2 = 25.0
      inside = 1.0
      outside = -0.8
      variable = c
    [../]
  [../]
[]

[Kernels]
  [./ie_c]
    type = TimeDerivative
    variable = c
  [../]
  [./CHSolid]
    type = CHMath
    variable = c
    mob_name = M
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
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 101'
  l_max_its = 15
  nl_max_its = 10
  start_time = 0.0
  num_steps = 2
  dt = 1.0
[]

[Outputs]
  file_base = box
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
