# Static Timing Analysis (STA)
## Digital Lock-In Amplifier ASIC

## 1. Introduction

Static Timing Analysis (STA) verifies whether a digital circuit satisfies its timing constraints without requiring simulation test vectors. It analyzes signal propagation through combinational logic and sequential elements using cell timing models, interconnect delays, and design constraints.

This project implements a Digital Lock-In Amplifier using Verilog RTL, OpenLane, OpenSTA, and the SKY130A standard-cell library. STA is used to evaluate the timing performance of the design and identify paths that fail to meet the target clock period.

## 2. Objectives

- Evaluate the timing performance of the ASIC implementation.
- Identify critical paths and excessive propagation delays.
- Examine setup and hold timing requirements.
- Analyze timing with extracted parasitic information.
- Determine whether the design meets the target clock period.
- Document timing violations and possible optimization strategies.

## 3. Tools and Technologies

- OpenLane — RTL-to-GDSII implementation flow.
- OpenSTA — static timing analysis.
- OpenROAD — physical-design implementation.
- Yosys — RTL synthesis.
- SKY130A PDK — 130 nm process design kit.
- SKY130 HD standard-cell library.
- Verilog HDL — hardware description language.
- SDC — timing constraint format.

## 4. Design Under Analysis

The top-level module is `lockin_top`. The design implements digital logic associated with reference generation and lock-in signal processing.

The RTL is synthesized into a gate-level netlist. The physical-design flow then performs floorplanning, placement, clock-tree synthesis, and routing. Timing analysis evaluates the delays through the resulting logic and sequential elements.

## 5. Timing Constraints

The target clock period is 10 ns, corresponding to a target frequency of 100 MHz.

The relationship between clock period and frequency is:

    f = 1 / T

For a clock period of 10 ns:

    f = 1 / (10 × 10^-9) = 100 MHz

The SDC file defines the clock and other applicable timing constraints. Input delays, output delays, clock uncertainty, and other constraints must accurately represent the intended operating conditions.

## 6. Static Timing Analysis

STA evaluates timing paths using cell-delay and interconnect-delay information. It checks whether data reaches its destination within the required timing window.

The analysis considers:

- Cell propagation delay.
- Interconnect delay.
- Clock arrival times.
- Setup and hold requirements.
- Data arrival times and required arrival times.
- Timing slack.

Unlike dynamic simulation, STA does not require input vectors to exercise every timing path.

## 7. Setup Timing Analysis

Setup timing ensures that data arrives early enough before the active clock edge and remains stable for the required setup interval.

Setup slack is calculated as:

    Setup Slack = Required Time - Arrival Time

- Positive slack indicates that the analyzed path meets its setup requirement.
- Zero slack indicates that the path is at its timing limit.
- Negative slack indicates a setup timing violation.

Setup violations may result from excessive logic depth, large cell delays, high fanout, long interconnects, or an aggressive clock period.

## 8. Hold Timing Analysis

Hold timing ensures that data does not change too soon after the active clock edge.

A hold violation occurs when data arrives too early relative to the capture clock. Hold timing depends on minimum data-path delay, clock arrival times, and the receiving sequential cell's hold requirement.

Possible remedies include adding delay buffers or modifying the physical implementation. After any modification, timing analysis must be repeated to verify the result.

Setup and hold are separate checks: setup primarily constrains maximum path delay, while hold constrains minimum path delay.

## 9. Timing Reports

The `reports/` directory contains the following reports from OpenLane run2.

### 9.1 Detailed Timing Report

File: `24-opensta_spef.timing.rpt`

This report contains timing information for analyzed paths using extracted parasitic information. It can be examined to identify path startpoints, endpoints, cell delays, net delays, arrival times, required times, and slack.

### 9.2 Worst Negative Slack Report

File: `24-opensta_spef_wns.rpt`

Worst Negative Slack (WNS) represents the most negative slack among the paths covered by the analysis. A negative WNS indicates that at least one analyzed path fails its timing requirement.

### 9.3 Total Negative Slack Report

File: `24-opensta_spef_tns.rpt`

Total Negative Slack (TNS) summarizes negative slack across violating paths covered by the relevant analysis. It helps indicate the overall extent of timing violations.

## 10. Final Timing Results

The recorded final extracted-parasitics results for OpenLane run2 are:

| Parameter | Result |
|---|---:|
| Target clock period | 10 ns |
| Target clock frequency | 100 MHz |
| Worst Negative Slack (WNS) | -4.71 ns |
| Total Negative Slack (TNS) | -85.95 ns |

### WNS Interpretation

The WNS of -4.71 ns indicates that the worst analyzed timing path misses its required timing target by 4.71 ns. The detailed timing report should be inspected to identify the path and the delay contributions responsible for this violation.

### TNS Interpretation

The TNS of -85.95 ns indicates accumulated negative slack across violating paths covered by the summary. WNS and TNS should be considered together when evaluating timing performance.

The current implementation does not meet the 10 ns target clock period.

## 11. Physical Verification Context

The final OpenLane run summary records:

- Magic DRC violations: 0
- LVS errors: 0
- Antenna violations: 10

Design Rule Check (DRC) checks physical layout rules. Layout Versus Schematic (LVS) checks whether the extracted layout connectivity matches the intended circuit connectivity. Antenna checks identify potential antenna-rule violations.

Zero reported Magic DRC violations and zero LVS errors do not imply that timing requirements are met. The ten antenna violations also remain to be investigated.

## 12. Analysis and Discussion

The OpenLane flow completed and generated physical-design outputs and timing reports. However, the final extracted-parasitics results show negative WNS and TNS.

Flow completion does not mean that every performance target has been satisfied. The current implementation requires further timing investigation before it can meet the 10 ns target clock period.

The critical paths should be examined to determine whether the largest delays arise from logic depth, cell selection, fanout, or interconnect parasitics. The SDC constraints should also be reviewed to ensure that the timing analysis represents the intended operating conditions.

## 13. Future Improvements

1. Inspect the detailed critical-path timing report.
2. Validate the clock definition and input/output constraints.
3. Review RTL logic depth and synthesis mapping.
4. Examine high-fanout nets and cell delays.
5. Investigate placement and routing contributions to delay.
6. Address the reported antenna violations.
7. Rerun the implementation and STA after optimization.
8. Compare WNS and TNS across verified design revisions.

## 14. Conclusion

STA provides an essential evaluation of the timing performance of the Digital Lock-In Amplifier ASIC.

The final extracted-parasitics results for OpenLane run2 report WNS of -4.71 ns and TNS of -85.95 ns against a target clock period of 10 ns. These negative slack values indicate that the current implementation does not meet its timing target.

Although the flow completed and the final summary reports zero Magic DRC violations and zero LVS errors, ten antenna violations remain, and timing optimization is necessary.

Further critical-path analysis, constraint validation, optimization, and re-verification are required to improve timing performance.

## 15. Project Directory

    STA/
    ├── README.md
    └── reports/
        ├── 24-opensta_spef.timing.rpt
        ├── 24-opensta_spef_wns.rpt
        └── 24-opensta_spef_tns.rpt

These files document the timing-analysis results associated with OpenLane run2.
