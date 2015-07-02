[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  ymax = 100
  xmax = 100
  elem_type = QUAD4
[]

[Variables]
  #a simple convection equation, convected is our composition variable
  active = 'convected'
  [./cdot]
    type = TimeDerivative
    variable = convected	
  [../]
  [./convected]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./cIC]
    type = FunctionIC
    variable = convected
    function = ic_func_2
  [../]
[]

[Functions]
  active = 'ic_func ic_func_2'
  [./ic_func]
    type = ParsedFunction
    value = 'sin(x)+sin(y)'
    vars = 'convected'
    vals = '1'
  [../] 

  [./ic_func_2]
    type = PiecewiseConstant
    variable = convected
    axis = 1
    direction = 'left'
    x = '0 50' # denotes position along horizontal axis where the interfaces will be
    y = '1 1' 
  [../]
[]

[Kernels]
  active = 'td conv'
  
  [./td]
    type = TimeDerivative
    variable = convected
  [../]

  [./conv]
    type = Convection
    variable = convected
    velocity = '1.0 1.0'
    x = 1.5
    y = 1
  [../]
[]

[BCs]
  active = 'bottom top left right'

  [./bottom]
    type = DirichletBC
    variable = convected
    boundary = 'bottom'
    value = 10
  [../]

  [./top]
    type = DirichletBC
    variable = convected
    boundary = 'top'
    value = 0
  [../]
  [./left]
    type = DirichletBC
    variable = convected
    boundary = 'bottom'
    value = 10
  [../]

  [./right]
    type = DirichletBC
    variable = convected
    boundary = 'top'
    value = 10
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.5
  start_time = 0
  num_steps = 1000
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  #applicable for transient or steady state calculations


[]

[Outputs]
  file_base = 'adv'
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
