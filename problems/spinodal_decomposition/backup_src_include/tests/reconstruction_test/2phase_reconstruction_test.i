[Problem]
  type = FEProblem
  solve = false
  kernel_coverage_check = false
[]

[Mesh]
  type = EBSDMesh
  filename = 'Ti_2Phase_28x28_Sqr_Marmot.txt'
[]

[GlobalParams]
  op_num = 4
  var_name_base = eta
[]

[UserObjects]
  [./ebsd]
    type = EBSDReader
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./ReconVarIC]
      ebsd_reader = ebsd
      consider_phase = false
    [../]
  [../]
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 0
[]

[Outputs]
  output_initial = true
  interval = 1
  exodus = true
  print_perf_log = true
[]


