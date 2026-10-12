#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -s tb_adventure_fsm -o build/adventure_sim rtl/adventure_fsm.sv tb/tb_adventure_fsm.sv
vvp build/adventure_sim
printf '\nWaveform generated: build/adventure_fsm.vcd\n'
