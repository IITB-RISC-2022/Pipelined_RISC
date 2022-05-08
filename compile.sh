#!/bin/zsh

echo "Hi"

ghdl -a muxes.vhdl

ghdl -a ALU.vhdl
ghdl -e ALU

ghdl -a FFs.vhdl
ghdl -e FF16
ghdl -e FF3
ghdl -e FF1
ghdl -e FFX

ghdl -a Lshifters.vhdl
ghdl -e Lshifter7
ghdl -e Lshifter1

ghdl -a Memory.vhdl
ghdl -e MEMORY 
ghdl -e IM

ghdl -a priority_enc.vhdl
ghdl -e PRIORITY_ENC

ghdl -a register_file.vhdl
ghdl -e REG_FILE

ghdl -a SignExtenders.vhdl
ghdl -e SignExt9
ghdl -e SignExt6

ghdl -a rf_fwdr.vhdl
# ghdl -e rf_fwdr

ghdl -a *_Stage.vhdl
ghdl -e if_stage
ghdl -e id_stage
ghdl -e rr_stage
ghdl -e ex_stage
ghdl -e mm_stage
ghdl -e wb_stage

ghdl -a pipeline_datapath.vhdl
ghdl -e pipe_datapath

ghdl -a DUT.vhdl
ghdl -e DUT

ghdl -a Testbench.vhdl
ghdl -e Testbench

echo "End"
