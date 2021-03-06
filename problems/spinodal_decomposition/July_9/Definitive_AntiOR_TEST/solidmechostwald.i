[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 15
  ny = 15
  xmax = 20
  ymax = 20
  elem_type = QUAD4
[]

[Adaptivity]
  marker = errorfrac
  steps = 1
  max_h_level = 4
  initial_steps = 2

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

  #Piecewise Bilinear attempt 1
  #[./ic_func_3]
    #type = PiecewiseBilinear
    #data_file = '40x40.csv'
    #the specifications below correspond axes in data files to those in simulation
    #xaxis = 0
    #yaxis = 1
    # scale_factor = 0.2    
  #[../]
  
[]
[Variables]
  [./c]
  [../]
  [./w]
  [../]

  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]

[]

[ICs]
  [./c_IC]
    type = SpecifiedSmoothCircleIC
    variable = c
    invalue = 1
    outvalue = -1
    int_width = 1
    3D_spheres = false
    x_positions = '10 20'
    y_positions = '10 20'
    z_positions = '0 0'
    radii = '2 7'
  [../]
[]

[Kernels]
  [./cres]
    type = SplitCHParsed
    variable = c
    kappa_name = kappa_c
    w = w
    f_name = T
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = M
    args = c
  [../]
  [./time]
    type = CoupledImplicitEuler
    variable = w
    v = c
  [../]

  [./TensorMechanics]
    disp_z = disp_z
    disp_y = disp_y
    disp_x = disp_x
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./kappa]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'kappa_c'
    prop_values = '0.01'
  [../]
  [./mob]
    type = DerivativeParsedMaterial
    block = 0
    f_name = M
    args = c
    function = 'exp(-c^2/.1)'
    outputs = exodus
    derivative_order = 1
  [../]
  [./free_energy]
    type = MathEBFreeEnergy
    block = 0
    f_name = F
    c = c
  [../]

  [./elasticenergy]
    type = ElasticEnergyMaterial
    block = 0
    args = 'c'
    f_name = A
  [../]
  

  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  [./strain]
    type = ComputeSmallStrain
    block = 0
    disp_z = disp_z
    disp_y = disp_y
    disp_x = disp_x
  [../]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    block = 0
    lambda = 113636
    shear_modulus = 454545
  [../]
  [./total_free_energy]
     type = DerivativeSumMaterial
     block = 0
     f_name = T
     sum_materials = 'F A'
     args = 'c'
  [../]

[]

[Preconditioning]
  [./SMP]
   type = SMP
   off_diag_row = 'w c'
   off_diag_column = 'c w'
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31      lu      1'

  l_max_its = 30
  l_tol = 1.0e-3
  nl_max_its = 50
  nl_rel_tol = 1.0e-9
  end_time = 150000 
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 2
  [../]
[]

[Outputs]
  file_base = 'solid_mech_ripening'
  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  output_initial = true
[]
