#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2 (lev landau).
#

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 100
  ny = 100
  nz = 100
  xmax = 100
  ymax = 100
  zmax = 100
  elem_type = HEX
[]
[Adaptivity]
  marker = errorfrac
  steps = 1
  max_h_level = 2
  initial_steps = 4

  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = c
    [../]
  [../]

  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.5
      coarsen = 0.1
      indicator = error
    [../]
  [../]


[]
[Variables]
  [./c]
  [../]
  [./w]
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = LatticeSmoothCircleIC
    variable = c
    radius = 5
    3D_spheres = 1
    Rnd_variation = 1
    invalue = 1
    outvalue = -1
    circles_per_side = '5 5 5'

    Lx = 100
    Ly = 100
    Lz = 100	
    
  [../]
[]

[Functions]
  active = 'ic_func ic_func2 ic_func_4'
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
    x = '0 4 8 12 16' # denotes position along horizontal axis where the interfaces will be
    y = '-1 1 -1 1 -1' #denotes magnitude of the variable at each of the partitions
  [../]

  [./ic_func_4]
    type = PiecewiseConstant
    axis = 1
    direction = 'left'
    x = '0 12 16'
    y = '-1 1 -1'

  [../]
  
[]

[Kernels]
  [./c_dot]
    type = CoupledImplicitEuler
    variable = w
    v = c
  [../]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = fbulk
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]


[BCs]
   #active = 'right left top bottom'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the prob
 
  [./Periodic]
    [./all]
       auto_direction = 'y'
    [../]
  [../]
[]

[Materials]
  [./mat]
    type = PFMobility
    block = 0
    mob = .1 #mobility is flexibile, jsut keep constant throughout all tests
    kappa = .01
    #kappa above is the experimentally agreed upon input value (Dina and Nathan)
    #kappa is the coefficient of (del(c))^2, the penalty term of the cahn_hilliard
  [../]
  [./free_energy]
    type = ParsedMaterial
    block = 0
    f_name = fbulk
    args = c
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(c^2-1)^2
    enable_jit = true
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./top]
    type = SideIntegralVariablePostprocessor
    variable = c
    boundary = top
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  # petsc_options_value = 'hypre boomeramg 31'
  type = Transient
  scheme = bdf2
  #dt = timestep
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9
  end_time = 15000
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .05
  [../]
[]

[Outputs]
  file_base = '3DClusterCircles'
  interval = 1 #interval only outputs the results after every n  timesteps
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]

