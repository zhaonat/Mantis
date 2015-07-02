[Mesh]
  file = mug.e
  # convergence issue occurs with a generated mesh of these properties
  #type = GeneratedMesh
  #dim = 2
  #xmin = 0
  #xmax = 150
  #ymin = 0
  #ymax = 150
  #nx = 60
  #ny = 60
  #elem_type = QUAD4
[]

[Variables]
  active = 'diffused'

  [./diffused]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./testICs]
    type = ConstantIC
    variable = diffused
    value = 5
  [../]
[]

[Kernels]
  active = 'diff'

  [./diff]
    type = Diffusion
    variable = diffused
  [../]

  [./difftime]
    type = TimeDerivative
    variable = diffused
    time_coefficient = 20.0
  [../]
[]

[BCs]
  active = 'bottom top'

  [./bottom]
    type = DirichletBC
    variable = diffused
    boundary = 'bottom'
    value = 10
  [../]

  [./top]
    type = DirichletBC
    variable = diffused
    boundary = 'top'
    value = 2
  [../]

[]

[Executioner]
  type = Transient
  dt = .1
  
  num_steps = 10
  #n_rel_tol = 0
  l_max_its = 5 #seems to have some effect, not definitive
  nl_max_its = 5 #seems to make it worse
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


[]

[Outputs]
  file_base = out
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
