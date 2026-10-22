# Floorplanning

## Overview
Floorplanning is the initial physical-design stage after synthesis. It establishes the core and die dimensions and prepares the design for standard-cell placement and power distribution.

## Objectives
- Define the core and die area.
- Establish the initial physical design region.
- Prepare the design for power distribution network (PDN) generation.
- Check that the design can proceed to placement.

## Tools Used
- OpenLane
- OpenROAD
- SKY130A PDK
- Magic

## Output
The floorplan DEF file is `lockin_top.floorplan.def`, available under the OpenLane run directory at `results/floorplan/`.

## Results
The floorplan was generated successfully as part of the completed OpenLane run.

The final design reports approximately **49% core utilization**. This is a final-run metric and should not be interpreted as a floorplan-only measurement unless confirmed by the floorplan report.

## Screenshot
Upload a Magic screenshot showing the floorplanned design as `floorplan_magic.png`.

## Note
The floorplan view shows the early physical organization of the design before detailed standard-cell placement and routing.
