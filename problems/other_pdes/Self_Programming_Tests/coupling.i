#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2 (lev landau).
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  #nz = 10
  xmax = 100
  ymax = 100
  #zmax = 10
  elem_type = QUAD4
[]

[Variables]
  [./c1]
    Order = FIRST
    Family = LAGRANGE
  [../]
  [./c2]
    Order = FIRST
    Family = LAGRANGE
  [../]
[]

[ICs]
  [./type1]
    variable = c1
    type = SmoothCircleIC
    x1 = 50
    y1 = 50
    radius = 10
    invalue = 1
    outvalue = -1
  [../]
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

  
[]

[Kernels]
  [./c1_dot]
    type = CoefTimeDerivative
    variable = c1
    coefficient = 1
  [../]
  [./c2_dot]
    type = CoefTimeDerivative
    variable = c2
    coefficient = -1
  [../]
   
  [./c1_diffused]
    type = Diffusion
    variable = c1
  [../]

  [./c2_diffused]
    type = Diffusion
    variable = c2
  [../]
[]


[BCs]
  active = 'top bottom right left'
  [./bottom]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem

    type = DirichletBC
    variable = c
    boundary = 'bottom'
    value = 0
    
  [../]

 
 
  #[./Periodic]
    #[./all]
       #auto_direction = 'x y'
    #[../]
  #[../]
[]


[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  dt = 1
  num_steps = 75
  #[./TimeStepper]
   # type = DT2
    #dt = 2
    #e_max = 0.05 #default e_max is usually too small
    #e_tol = 0.001
  #[../]
[]


[Outputs]
  file_base = 'TEST'
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]

