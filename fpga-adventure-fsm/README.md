# FPGA Adventure Game: FSM Design & Functional Verification

A compact **SystemVerilog Moore finite-state machine** for an adventure-game
controller, with a self-checking simulation testbench and a Python behavioral
reference model. Intended as an educational RTL/verification portfolio project.

## Features
- Six states: START, HALL, ARMORY, DRAGON, WIN and LOSE
- North/east/south/west controls and sword condition
- Asynchronous active-low reset
- Ignores conflicting simultaneous direction inputs
- Sticky win/lose outputs until reset
- Self-checking SystemVerilog tests covering winning, losing, reset, backtracking and conflicting inputs
- Python reference model with `pytest` tests

## Repository layout
```
rtl/adventure_fsm.sv          Synthesizable FSM
 tb/tb_adventure_fsm.sv      Self-checking SystemVerilog testbench
 tools/fsm_reference.py      Python reference model
 tests/test_fsm_reference.py Model unit tests
 docs/STATE_MACHINE.md      Transition table and optional board notes
 run_sim.sh                 Linux/macOS simulation script
```

## Run the Python reference tests
Install Python and pytest, then run from the project root:
```
python -m pip install pytest
python -m pytest -q
```

## Run RTL simulation
Install **Icarus Verilog** (provides `iverilog` and `vvp`) and run:

**Linux/macOS:** `./run_sim.sh`

**Windows PowerShell:**
```powershell
New-Item -ItemType Directory -Force build | Out-Null
iverilog -g2012 -s tb_adventure_fsm -o build/adventure_sim rtl/adventure_fsm.sv tb/tb_adventure_fsm.sv
vvp build/adventure_sim
```

Expected final console line: `PASS: 15 FSM checks` (if all checks pass).
The testbench writes `build/adventure_fsm.vcd`, viewable in GTKWave.

## Important limitations
- This is a **new, independent portfolio implementation inspired by foundational
  digital-design lab concepts**; it is **not** presented as a verbatim export
  of a university lab or professor-provided starter code.
- Python tests do **not** establish successful RTL simulation.
- **DE10 board operation is not verified.** The RTL requires a board-specific
  wrapper, pin constraints, input synchronization/debouncing and actual hardware
  testing before claiming FPGA deployment.
- Use the project's actual completed verification level when describing it on a resume.

MIT licensed; see LICENSE.
