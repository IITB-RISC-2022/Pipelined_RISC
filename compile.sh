#!/bin/zsh

echo "IIT-B RISC™ 2022"
echo -n "Starting Compilation (0/12)      \r"
ghdl -a muxes.vhdl
echo -n "Compilation Status (1/12)    \r"
ghdl -a ALU.vhdl
ghdl -e ALU
echo -n "Compilation Status (2/12)    \r"
ghdl -a FFs.vhdl
ghdl -e FF16
ghdl -e FF3
ghdl -e FF1
ghdl -e FFX
echo -n "Compilation Status (3/12)  \r"

ghdl -a Lshifters.vhdl
ghdl -e Lshifter7
ghdl -e Lshifter1
echo -n "Compilation Status (4/12)  \r"

ghdl -a Memory.vhdl
ghdl -e MEMORY 
ghdl -e IM
echo -n "Compilation Status (5/12)  \r"

ghdl -a priority_enc.vhdl
ghdl -e PRIORITY_ENC
echo -n "Compilation Status (6/12)  \r"

ghdl -a register_file.vhdl
ghdl -e REG_FILE
echo -n "Compilation Status (7/12)  \r"

ghdl -a SignExtenders.vhdl
ghdl -e SignExt9
ghdl -e SignExt6
echo -n "Compilation Status (8/12)  \r"

ghdl -a fwdr.vhdl
# ghdl -e rf_fwdr
echo -n "Compilation Status (9/12)  \r"

ghdl -a *_Stage.vhdl
ghdl -e if_stage
ghdl -e id_stage
ghdl -e rr_stage
ghdl -e ex_stage
ghdl -e mm_stage
ghdl -e wb_stage
echo -n "Compilation Status (10/12)  \r"

ghdl -a pipeline_datapath.vhdl
ghdl -e pipe_datapath
echo -n "Compilation Status (11/12)  \r"

ghdl -a DUT.vhdl
ghdl -e DUT
echo "Compilation Status (12/12)"

ghdl -a Testbench.vhdl
ghdl -e Testbench

echo "Compilation finished        "
echo "Running Simulation using ghdl"
ghdl -r testbench --wave=waveform.ghw > .output
echo "Simulation Complete, command output stored in '.output'"