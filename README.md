Digital Lock-In Amplifier ASIC

1. Project Overview

This project implements a digital lock-in amplifier using Verilog HDL and takes the design through the RTL-to-GDSII physical-design flow using OpenLane and the SKY130A PDK.

A digital lock-in amplifier extracts a signal of interest by correlating the input signal with a reference signal and accumulating the resulting components.

2. Tools and Technologies

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- OpenLane v0.21
- OpenROAD
- OpenSTA
- Magic VLSI
- SKY130A standard-cell library

3. Repository Structure

rtl/             RTL source modules
tb/              Verilog testbench
constraints/     Timing constraints (SDC)
reports/         Synthesis and timing reports
layout/
  synthesis/     Synthesized Verilog netlist
  floorplan/     Floorplan DEF
  placement/     Placement DEF
  routing/       Routed DEF
screenshots/     Physical-design screenshots
README.md        Project documentation

4. RTL Design

The design contains the following modules:

- "reference_gen.v" — reference signal generation.
- "lockin_core.v" — lock-in processing core.
- "lockin_top.v" — top-level module connecting the design blocks.

The testbench is located in "tb/lockin_tb.v".

5. Physical-Design Flow

The design was processed using OpenLane with the SKY130A standard-cell library.

The completed run included:

1. RTL synthesis
2. Floorplanning
3. Standard-cell placement
4. Clock-tree synthesis (CTS)
5. Timing optimization
6. Routing
7. Physical verification and report generation

Selected results from OpenLane run "run2" are included in this repository.

6. Physical-Design Results

Metric| Result
OpenLane flow status| Completed
Total runtime| 10 min 39 sec
Standard-cell count| 2,011
Core utilization| Approximately 49%
Magic DRC violations| 0
LVS errors| 0
Antenna violations| 10
Target clock period| 10 ns (100 MHz)

7. Static Timing Analysis

The final extracted-parasitics timing report contains the following results:

Timing metric| Result
Worst negative slack (WNS)| -4.71 ns
Total negative slack (TNS)| -85.95 ns
Target clock period| 10 ns

The worst reported path starts at "sample_in[6]" and ends at a flip-flop. Its data arrival time is 14.42 ns, while the required time is 9.71 ns.

Timing status: The design does not meet the 10 ns target. Further timing analysis and optimization are required.

8. Physical Verification

The OpenLane summary reports zero Magic DRC violations and zero LVS errors. However, ten antenna violations remain to be investigated.

A completed flow does not imply that every timing and physical-verification requirement has passed.

9. Future Improvements

- Investigate and resolve antenna violations.
- Analyze critical input-to-register timing paths.
- Optimize RTL logic depth and timing constraints where appropriate.
- Rerun the physical-design flow after making changes.
- Verify timing and physical-design results after optimization.

10. Project Status

The RTL-to-physical-design flow has completed, and selected synthesis, floorplan, placement, routing, and timing artifacts have been collected.

Timing closure and antenna-violation resolution remain outstanding tasks.
