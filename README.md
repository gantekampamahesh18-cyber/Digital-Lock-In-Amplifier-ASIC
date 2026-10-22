# Digital Lock-In Amplifier ASIC

An RTL-to-physical-design project implementing a digital lock-in amplifier using Verilog HDL and the SKY130A open-source process design kit. The project covers RTL simulation, synthesis, floorplanning, placement, routing, and static timing analysis (STA) using an OpenLane-based flow.

> **Project status:** OpenLane run2 completed. The current implementation has reported antenna violations, so it should be treated as a working implementation rather than a timing-closed, signoff-ready ASIC.

## Table of Contents

- [Project Overview](#project-overview)
- [How a Digital Lock-In Amplifier Works](#how-a-digital-lock-in-amplifier-works)
- [Project Objectives](#project-objectives)
- [Tools and Technologies](#tools-and-technologies)
- [Repository Structure](#repository-structure)
- [RTL Modules](#rtl-modules)
- [RTL Simulation](#rtl-simulation)
- [ASIC Implementation Flow](#asic-implementation-flow)
- [Implementation Results](#implementation-results)
- [Static Timing Analysis](#static-timing-analysis)
- [Physical Verification](#physical-verification)
- [How to Reproduce the Work](#how-to-reproduce-the-work)
- [Known Limitations and Future Work](#known-limitations-and-future-work)
- [References](#references)

## Project Overview

A lock-in amplifier extracts a signal of interest from noisy measurements by comparing the input with a reference signal. This project explores a digital implementation in RTL and takes the design through an ASIC implementation flow using open-source tools.

The project demonstrates how a Verilog design progresses from source code to a synthesized standard-cell netlist and then through physical implementation. Simulation waveforms provide evidence of RTL behavior, while STA reports help evaluate whether timing requirements are satisfied.

## How a Digital Lock-In Amplifier Works

A typical lock-in amplifier uses a reference signal related to the frequency or phase of the signal being measured. In a digital implementation, the main conceptual operations can include:

1. **Reference generation:** Generate a digital reference used by the detection logic.
2. **Signal processing:** Combine or correlate the input with the reference to emphasize the component of interest.
3. **Accumulation or filtering:** Reduce unwanted components and noise over time, depending on the implemented architecture.
4. **Output generation:** Produce the digital result defined by the RTL.

The exact functionality and numerical behavior are determined by the modules in `rtl/` and the testbench in `tb/`. Consult those files for the implemented signal widths, arithmetic, reset behavior, and output interpretation.

## Project Objectives

- Implement the lock-in amplifier architecture using Verilog HDL.
- Simulate the RTL and inspect signal behavior in a waveform viewer.
- Synthesize the RTL into a gate-level standard-cell netlist.
- Perform floorplanning, placement, clock-tree synthesis, and routing.
- Inspect physical-design stages using the SKY130A technology setup and Magic where applicable.
- Evaluate setup timing using OpenSTA reports.
- Record physical-verification and timing results and identify remaining issues.

## Tools and Technologies

| Tool / Technology | Role |
|---|---|
| Verilog HDL | RTL description of the design |
| Icarus Verilog (`iverilog`) | Compile the RTL and testbench for simulation |
| `vvp` | Execute the compiled simulation |
| GTKWave | Inspect simulation waveforms |
| Yosys | Synthesize RTL into a gate-level netlist |
| OpenLane | Orchestrate the RTL-to-GDSII implementation flow |
| OpenROAD | Perform physical-design operations within the flow |
| OpenSTA | Analyze timing paths and slack |
| Magic | Inspect physical layout and perform layout-related checks |
| SKY130A PDK / SKY130 HD cells | Technology and standard-cell library used for implementation |
| Git and GitHub | Version control and project hosting |

Tool versions and environment details can affect reproducibility. The project environment used Ubuntu in a VirtualBox virtual machine, OpenLane v0.21, and the SKY130A PDK.

## Repository Structure

The following is the intended high-level organization. Some files may be present only if they have been added to the repository.

```text
Digital-Lock-In-Amplifier-ASIC/
├── rtl/
│   ├── reference_gen.v
│   ├── lockin_core.v
│   └── lockin_top.v
├── tb/
│   └── lockin_tb.v
├── simulation/
│   ├── README.md
│   └── waveforms/
│       └── lockin_waveform.png
├── constraints/
│   └── lockin.sdc
├── layout/
│   └── synthesis/
│       └── lockin_top.synthesis.v
├── STA/
│   ├── README.md
│   └── reports/
│       ├── 24-opensta_spef.timing.rpt
│       ├── 24-opensta_spef_wns.rpt
│       └── 24-opensta_spef_tns.rpt
└── README.md
```

The OpenLane run directory also contains implementation outputs and reports. Generated databases and large temporary files are not necessarily stored in this Git repository. Update this tree if the repository layout changes.

## RTL Modules

### `reference_gen.v`

Contains the reference-generation logic used by the design. Its actual waveform, phase behavior, frequency, and reset behavior are defined by the RTL source.

### `lockin_core.v`

Contains the core lock-in processing logic. Review the RTL to determine the exact arithmetic, data widths, and output behavior implemented in this version.

### `lockin_top.v`

Top-level module that integrates the design blocks and exposes the module's external interface for simulation and synthesis.

### `tb/lockin_tb.v`

The testbench applies stimulus to the design and may generate a Value Change Dump (VCD) waveform file. The testbench defines the simulation duration and the signals that are observed. Check the source for the exact assertions and test coverage; a waveform alone does not prove all functional cases.

## RTL Simulation

RTL simulation is used to check the behavior of the design before synthesis. Icarus Verilog compiles the RTL and testbench, `vvp` runs the compiled simulation, and GTKWave displays the recorded signal transitions.

### Compile the design

From the project root, run:

```bash
iverilog -o lockin_sim rtl/reference_gen.v rtl/lockin_core.v rtl/lockin_top.v tb/lockin_tb.v
```

If compilation succeeds, the command normally returns to the shell without reporting errors.

### Run the simulation

```bash
vvp lockin_sim
```

The testbench must contain appropriate `$dumpfile` and `$dumpvars` statements for VCD output to be generated. Confirm the filename in `tb/lockin_tb.v`. If the testbench uses `lockin.vcd`, verify that the file exists:

```bash
ls -lh lockin.vcd
```

### Open the waveform

```bash
gtkwave lockin.vcd
```

In GTKWave, add relevant signals from the hierarchy and use Zoom Fit to view the simulation interval. Save a readable screenshot in `simulation/waveforms/`.

### Waveform screenshot

![RTL simulation waveform](simulation/waveforms/lockin_waveform.png)

*Figure: GTKWave simulation waveform. Interpret the signals against the RTL and testbench; replace this image path if your screenshot uses a different filename.*

## ASIC Implementation Flow

The design was processed through the following general stages in OpenLane.

### 1. RTL Synthesis

Synthesis translates Verilog RTL into a gate-level netlist using the target standard-cell library. The generated netlist is a logical representation of the circuit and does not, by itself, contain final physical placement and routing geometry.

Recorded output:
- `lockin_top.synthesis.v`

The final run summary recorded **2011 standard cells**.

### 2. Floorplanning

Floorplanning establishes the core and die regions and prepares the design for physical implementation. It provides the initial physical organization and supports subsequent power-distribution and placement operations.

Recorded output:
- `results/floorplan/lockin_top.floorplan.def`

### 3. Placement

Placement assigns physical locations to standard cells inside the floorplan. Placement tools consider factors such as timing, congestion, and wirelength.

Recorded output:
- `results/placement/lockin_top.placement.def`

### 4. Clock-Tree Synthesis (CTS)

Clock-tree synthesis builds the clock distribution network for sequential elements. It manages clock propagation and skew and may insert clock buffers and other cells. The CTS stage has its own timing reports.

### 5. Routing

Routing creates interconnect between placed standard cells. Extracted interconnect parasitics can then be used for more realistic timing analysis.

Recorded output:
- `results/routing/lockin_top.def`

### 6. Physical Inspection

Magic can be used to inspect physical layout data with the appropriate SKY130A technology setup. A synthesized Verilog netlist should not be opened directly as if it were a physical layout; use a compatible physical database such as a DEF together with the required technology and cell information.

## Implementation Results

The following values are recorded from the completed OpenLane run2 summary.

| Metric | Recorded result |
|---|---:|
| OpenLane run | `run2` |
| Flow status | Completed |
| Standard-cell count | 2011 |
| Core utilization | Approximately 49% |
| Magic DRC violations | 0 |
| LVS errors | 0 |
| Antenna violations | 10 |
| Target clock period | 10 ns |
| Target clock frequency | 100 MHz |

Core utilization is reported as an approximate final-run value. It should not be interpreted as a floorplan-only metric unless verified against the relevant stage report.

## Static Timing Analysis

Static Timing Analysis (STA) evaluates timing paths using cell timing models, timing constraints, and interconnect parasitics. It does not require input test vectors to exercise every path.

The project includes reports generated by the OpenLane flow and copied into `STA/reports/`.

### Timing constraints

The target clock period is 10 ns:

\[
f = \frac{1}{T} = \frac{1}{10\text{ ns}} = 100\text{ MHz}
\]

Timing results depend on the SDC constraints and the libraries and parasitics loaded for the analysis. Confirm the timing setup before comparing results between runs or process corners.

### Recorded final extracted-parasitics results

| Metric | Result |
|---|---:|
| Worst Negative Slack (WNS) | -4.71 ns |
| Total Negative Slack (TNS) | -85.95 ns |

**Interpretation:** Negative WNS means at least one analyzed setup path fails its required timing target. Negative TNS indicates accumulated negative slack across violating paths covered by the report. Therefore, the current implementation does **not** meet the 10 ns target timing constraint.

### Reports in `STA/reports/`

- `24-opensta_spef.timing.rpt` — detailed timing report associated with extracted parasitic information.
- `24-opensta_spef_wns.rpt` — WNS summary.
- `24-opensta_spef_tns.rpt` — TNS summary.

These reports were found under the OpenLane run's `reports/synthesis/` directory, despite the `spef` filename. Refer to the report contents and flow logs to confirm the exact analysis stage before describing them as post-route signoff results. The WNS/TNS values above are the recorded final extracted-parasitics values for run2.

### Setup and hold timing

- **Setup analysis** checks that data arrives early enough before the capture clock edge.
- **Hold analysis** checks that data does not change too soon after the capture clock edge.

Setup and hold are separate checks. The negative WNS/TNS values cited above indicate setup timing problems; do not infer a hold violation from those values alone.

## Physical Verification

The final summary records zero Magic DRC violations and zero LVS errors. These results indicate that the reported checks did not find violations in those categories for that run. They do not establish that timing is met or that every possible verification requirement has been completed.

The run also reports **10 antenna violations**. These should be reviewed in the detailed reports and addressed before claiming full physical signoff.

## How to Reproduce the Work

1. Set up the documented Ubuntu environment with compatible OpenLane and SKY130A PDK versions.
2. Obtain the project repository and inspect the RTL, testbench, and SDC constraints.
3. Compile and run the RTL simulation using the commands above.
4. Inspect the VCD waveform in GTKWave.
5. Configure the design in OpenLane and run the RTL-to-GDSII flow using the project's configuration and constraints.
6. Inspect the synthesis, floorplan, placement, CTS, and routing outputs.
7. Review the timing reports and physical-verification reports.
8. Save the relevant reports and update the project documentation after each new run.

The exact OpenLane launch command depends on the local installation and design configuration; use the configuration and command appropriate to your installed environment.

## Known Limitations and Future Work

### Current limitations

- The final extracted-parasitics WNS is -4.71 ns and TNS is -85.95 ns, so the 10 ns timing target is not met.
- Ten antenna violations are reported.
- The current summary does not by itself demonstrate timing closure across all PVT corners.
- A successful flow completion is not equivalent to signoff closure.

### Future improvements

1. Inspect the detailed critical paths and identify the largest cell and net delay contributors.
2. Validate the SDC clock definition and input/output timing constraints.
3. Review RTL logic depth, synthesis mapping, and high-fanout nets.
4. Evaluate placement and routing changes that could reduce interconnect delay.
5. Address the antenna violations using the applicable physical-design flow.
6. Run STA for the required process-voltage-temperature (PVT) corners with the correct Liberty models and constraints.
7. Rerun the implementation after changes and compare WNS, TNS, DRC, LVS, and antenna results.
8. Add updated waveforms and reports only when they correspond to the documented RTL revision and implementation run.

## References

- OpenLane documentation: https://openlane.readthedocs.io/
- OpenROAD documentation: https://openroad.readthedocs.io/
- SKYWater SKY130 PDK: https://github.com/google/skywater-pdk
- GTKWave: https://gtkwave.sourceforge.net/
- Icarus Verilog: https://steveicarus.github.io/iverilog/

---

**Authoring note:** Update this README whenever RTL, constraints, PDK/library corner, or OpenLane run changes. Keep the reported metrics tied to the specific run and reports from which they were obtained.
