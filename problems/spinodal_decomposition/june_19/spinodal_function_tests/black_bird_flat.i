#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2 (lev landau).
#

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
    type = RandomIC
    variable = c
    auto_direction = 'x y'
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
   #active = 'top bottom right left'
   #0 dirichlet boundaries do nothing...
   #a single nonzero dirichlet boundary condition completely screws up the problem


  #[./bottom]
    #type = NeumannBC
    #variable = c
    #boundary = 'bottom'
    #value = 0
  #[../]
 
  [./Periodic]
    [./all]
       auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./mat]
    type = PFMobility
    block = 0
    mob = 4 #mobility is flexibile, jsut keep constant throughout all tests
    kappa = 0.25 
    #kappa above is the experimentally agreed upon input value (Dina and Nathan)
    #kappa is the coefficient of (del(c))^2, the penalty term of the cahn_hilliard
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = fbulk
    args = c
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(1/256)*(c^2/2-(17*c^4)/4+(56*c^6)/3-44*c^8+(256*c^10)/5-(64*c^12)/3)
    #does function specify the free energy...it seems so based on the block title.
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
  end_time = 2000
  #dt = 2
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = .15
    #requires a very small timestep (0.0001 seconds)
  [../] 


[]

[Outputs]
  file_base = 'blackbird'
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]
