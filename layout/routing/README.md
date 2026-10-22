# Routing

## Overview
Routing connects the placed standard cells using metal interconnects according to the design's connectivity and physical-design constraints.

## Objectives
- Connect cell pins and nets.
- Complete signal routing and power connectivity.
- Extract parasitic resistance and capacitance.
- Evaluate timing and physical verification results.

## Tools Used
- OpenLane
- OpenROAD
- Magic
- SKY130A PDK

## Output
The routed DEF file is `lockin_top.def`, available under the OpenLane run directory at `results/routing/`.

## Final Physical-Design Results
- **Standard cells:** 2011
- **Core utilization:** approximately 49%
- **Magic DRC violations:** 0
- **LVS errors:** 0
- **Antenna violations:** 10
- **Final extracted-parasitics WNS:** -4.71 ns
- **Final extracted-parasitics TNS:** -85.95 ns

## Timing Analysis
The target clock period was 10 ns (100 MHz). The negative worst negative slack (WNS) indicates that the design does not meet the target timing constraint. Timing optimization is a recommended next step.

## Screenshot
Upload a Magic screenshot showing the routed layout as `routing_magic.png`.

## Note
The OpenLane flow completed successfully, but the final results still contain timing and antenna violations. These should be documented and addressed in future optimization work.
