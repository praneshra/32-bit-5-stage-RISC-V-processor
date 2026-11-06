#!/bin/bash
echo "Run simulation using Vivado xsim or ModelSim"
xelab tb_riscv_single_cycle -s tb_sim
xsim tb_sim -runall
