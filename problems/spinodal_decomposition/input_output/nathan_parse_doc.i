#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2 (lev landau).
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
 
  xmax = 20
  ymax = 20
  
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
    max = 1
    min = -1
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
  #Significant difference between NuemannBC and Dirichlet BCs
  active = 'bottom top left right center'

  [./bottom]
    #0 dirichlet boundaries do nothing...
    #a single nonzero dirichlet boundary condition completely screws up the problem
    type = DirichletBC
    variable = c
    boundary = 'bottom'
    value = 0
    
  [../]

  [./top]
    type = DirichletBC
    variable = c
    boundary = 'top'
    value = 0
  [../]

  [./left]
    type = DirichletBC
    variable = c
    boundary = 'left'
    value = 0

  [../]

  [./right]
    type = DirichletBC
    variable = c
    boundary = 'right'
    value = 0
  [../]
[]

[Materials]
  [./mat]
    type = PFMobility
    block = 0
    mob = 0.1 #increasing this increases speed and also seems to have some directional properties
    kappa = 1 #increasing this parameter increases the speed at which the decomposition occurs
    #Identify what the variables mean
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = fbulk
    args = c
    constant_names = W
    constant_expressions = 1.0/2^2
    function = W*(1+c+c^2/2+c^3/6+c^4/24+c^5/120+c^6/720+c^7/4900+c^8/32000+c^9/270000+c^10/3000000)
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
  dt = 2
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9
  end_time = 20
[]

[Outputs]
  output_initial = true
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
[]

