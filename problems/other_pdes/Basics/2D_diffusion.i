[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  
  ymax = 100
  
  elem_type = EDGE
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
    function = ic_func
  [../]
[]

[Functions]
  active = 'ic_func ic_func_2'
  [./ic_func]
    type = ParsedFunction
    value = 'sin(x)'
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


[Executioner]
  type = Transient
  dt = 0.01
  start_time = 0
  num_steps = 100
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  #applicable for transient or steady state calculations


[]

[Outputs]
  file_base = 'diff_1D'
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
