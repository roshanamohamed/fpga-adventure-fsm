# State machine design

The six states are encoded in three bits. Outputs are Moore-style: they depend
only on the current state. Reset (`reset_n=0`) asynchronously returns to START.

| Current state | Input | Next state |
| --- | --- | --- |
| START | North | HALL |
| HALL | East | ARMORY |
| HALL | North | DRAGON |
| HALL | South | START |
| ARMORY | West | HALL |
| DRAGON | South | HALL |
| DRAGON | East + sword | WIN |
| DRAGON | East + no sword | LOSE |
| WIN / LOSE | Any direction | No change |

Unsupported directions, no direction and simultaneous directions leave the state unchanged.
`sword` is an external condition sampled when entering the terminal state; it is
not automatically acquired in ARMORY. `room` reflects the current state encoding.

## Board hookup (optional)

The RTL is board-agnostic. To deploy on an Intel DE10, add an appropriate
board top module, debounced/synchronized physical button inputs, an FPGA clock,
and an assignment file with pin locations matching your *exact DE10 model*.
Do not assign arbitrary board pins. This repository does not claim completed
on-board timing closure, button debouncing, or physical DE10 testing.
