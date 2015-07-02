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
  active = 'diffusion'
  [./cdot]
    type = TimeDerivative
    variable = diffusion	
  [../]
  [./diffusion]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./cIC]
    type = FunctionIC
    variable = diffusion
    function = ic_func_2
  [../]
[]

[Functions]
  active = 'ic_func ic_func_2'
  [./ic_func]
    type = ParsedFunction
    value = 'sin(x)+sin(y)'
    vars = 'diffusion'
    vals = '1'
  [../] 

  [./ic_func_2]
    type = PiecewiseConstant
    variable = diffusion
    axis = 1
    direction = 'left'
    x = '0 50' # denotes position along horizontal axis where the interfaces will be
    y = '1 -1' 
  [../]
[]

[Kernels]
  active = 'td conv'
  
  [./td]
    type = TimeDerivative
    variable = diffusion
  [../]

  [./conv]
    type = CoefDiffusion
    variable = diffusion
    coef = 1
    
  [../]
[]

[BCs]
  active = 'bottom top'

  [./bottom]
    type = DirichletBC
    variable = diffusion
    boundary = 'bottom'
    value = 10
  [../]

  [./top]
    type = DirichletBC
    variable = diffusion
    boundary = 'top'
    value = 0
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.5
  start_time = 0
  num_steps = 100
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  #applicable for transient or steady state calculations


[]

[Outputs]
  file_base = 'diff_only'
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
