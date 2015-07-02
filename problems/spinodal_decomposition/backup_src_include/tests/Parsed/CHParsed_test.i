#
# Test the non-split parsed function free enery Cahn-Hilliard Bulk kernel
# The free energy used here has the same functional form as the CHPoly kernel
# If everything works, the output of this test should replicate the output
# of marmot/tests/chpoly_test/CHPoly_test.i (exodiff match)
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 16
  ny = 16
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
  [./cv]
    order = THIRD
    family = HERMITE
    [./InitialCondition]
      type = CrossIC
      x1 = 5.0
      y1 = 5.0
      x2 = 45.0
      y2 = 45.0
    [../]
  [../]
[]

[Kernels]
  [./ie_c]
    type = TimeDerivative
    variable = cv
  [../]

  [./CHSolid]
    type = CHParsed
    variable = cv
    f_name = F
    mob_name = M
  [../]

  [./CHInterface]
    type = CHInterface
    variable = cv
    mob_name = M
    grad_mob_name = grad_M
    kappa_name = kappa_c
  [../]
[]

[Materials]
  [./consts]
    type = PFMobility
    block = 0
    kappa = 0.1
    mob = 1
  [../]

  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
    args = 'cv'
    function = '(1-cv)^2 * (1+cv)^2'
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 101'

  l_max_its = 15
  l_tol = 1.0e-4

  nl_max_its = 10
  nl_rel_tol = 1.0e-11

  start_time = 0.0
  num_steps = 2
  dt = 0.7
[]

[Outputs]
  output_initial = true
  interval = 1
  print_perf_log = true
  [./OverSampling]
    type = Exodus
    refinements = 1
    output_initial = true
    oversample = true
  [../]
[]
