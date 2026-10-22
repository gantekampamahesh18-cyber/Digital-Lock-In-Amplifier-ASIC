# Synthesis

## Overview
Synthesis converts the RTL Verilog design of the Digital Lock-In Amplifier into a gate-level netlist using the SKY130 standard-cell library.

## Design
The top-level module is `lockin_top`. The synthesis flow translates the RTL logic into standard cells while optimizing the implementation according to the synthesis constraints.

## Tools Used
- OpenLane
- Yosys
- SKY130A PDK
- SKY130 HD standard-cell library

## Output
- `lockin_top.synthesis.v` — synthesized gate-level Verilog netlist.

## Results
The synthesized design contains **2011 standard cells** according to the final OpenLane run summary.

## Screenshot
Upload the synthesis statistics screenshot to this folder as `synthesis.png`.

## Note
The synthesized netlist represents the logical implementation of the design. It does not yet contain the physical placement and routing geometry required for a physical layout view in Magic.
