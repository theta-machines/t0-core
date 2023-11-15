# Quit Previous Simulation
quit -sim

# Compile Source Files
vlog ../src/control_unit/*
vlog ../src/datapath/*
vlog ../src/t0_core.sv
vlog t0_core_tb.sv

# Run Simulation
vsim t0_core_tb

# Simulation Window Setup
source wave.do

# Run
run 65 us
