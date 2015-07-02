[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
  
  
  elem_type = QUAD4
[]

[Variables]
  #a simple convection equation, convected is our composition variable
  active = 'diffusion '
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
  #usually, the wave equation has an initial profile and an initial speed 
[]

[Functions]
  active = 'ic_func ic_func_2 ic_func3'
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

  [./ic_func3]
    type = ParsedFunction
    value = '0'
    vars = 'diffusion'
    vals = '1'
  [../] 
[]

[Kernels]
  active = 'td conv'
  
  [./td]
    type = SecondDerivative
    variable = diffusion
  [../]

  [./conv]
    type = CoefDiffusion
    variable = diffusion
    coef = 1
    
  [../]
[]

[BCs]
  active = 'top bottom right left'
  [./bottom]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem

    type = DirichletBC
    variable = diffusion
    boundary = 'bottom'
    value = 0
  [../]
  [./top]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem

    type = DirichletBC
    variable = diffusion
    boundary = 'top'
    value = 0
  [../]
  [./right]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem

    type = DirichletBC
    variable = diffusion
    boundary = 'right'
    value = 0
  [../]
  [./left]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem

    type = DirichletBC
    variable = diffusion
    boundary = 'left'
    value = 0
  [../]



[]

[Executioner]
  type = Transient
  dt = 1
  start_time = 0
  num_steps = 100
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  #applicable for transient or steady state calculations


[]

[Outputs]
  file_base = 'Wave_2D'
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
