Digital Lock-In Amplifier ASIC

Overview

This project implements a digital lock-in amplifier using Verilog RTL and takes the design through the OpenLane physical-design flow using the SkyWater SKY130A PDK.

A lock-in amplifier extracts a signal of interest from noise by correlating the input signal with a reference signal and accumulating the resulting components.

Tools and Technology

- Verilog HDL
- Icarus Verilog
- GTKWave
- OpenLane v0.21
- OpenROAD
- Magic VLSI
- SKY130A standard-cell library

Project Structure

- "rtl/" — RTL source files
- "tb/" — Testbench
- "constraints/" — Timing constraints
- "reports/" — Simulation, synthesis, timing and physical-design reports
- "layout/" — Floorplan, placement and routed DEF files
- "screenshots/" — Magic layout screenshots

Physical Design Results

The OpenLane "run2" flow completed in approximately 10 minutes and 39 seconds.

Metric| Result
Standard-cell count| 2,011
Core utilization| Approximately 49%
Magic DRC violations| 0
LVS errors| 0
Antenna violations| 10
Final extracted-parasitics WNS| −4.71 ns
Final extracted-parasitics TNS| −85.95 ns
Target clock period| 10 ns (100 MHz)

Timing Analysis

The final extracted-parasitics timing report shows a worst setup slack of −4.71 ns. Therefore, the design does not meet the 10 ns target clock period yet. Timing optimization remains future work.

Physical Verification

The flow summary reports zero Magic DRC violations and zero LVS errors. However, ten antenna violations remain and should be investigated before considering the layout fully clean.

Repository Contents

This repository contains RTL source code, testbench files, timing constraints, selected OpenLane reports, layout files and screenshots for project documentation.

Future Improvements

- Investigate and resolve antenna violations.
- Analyze the critical input-to-register timing paths.
- Optimize the RTL and physical design to improve setup timing.
- Rerun verification after making changes.

Disclaimer

The reported metrics describe the current OpenLane "run2" results. A completed flow does not by itself mean that all timing and physical-verification requirements have passed.
