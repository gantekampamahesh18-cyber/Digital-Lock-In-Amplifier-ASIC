# Placement

## Overview
Placement assigns physical locations to the synthesized standard cells within the floorplan. The objective is to arrange cells while considering timing, congestion, and wirelength.

## Objectives
- Place standard cells inside the core.
- Improve timing and wirelength.
- Reduce placement congestion.
- Prepare the design for clock-tree synthesis and routing.

## Tools Used
- OpenLane
- OpenROAD
- SKY130A PDK
- Magic

## Output
The placement DEF file is `lockin_top.placement.def`, available under the OpenLane run directory at `results/placement/`.

## Results
The placement stage completed as part of the successful OpenLane run. The placed design can be inspected using Magic with the appropriate SKY130A technology configuration.

## Screenshot
Upload a Magic screenshot showing the standard-cell placement as `lockinplacement.png`.

## Note
Placement determines the physical locations of standard cells. Clock-tree synthesis and routing follow in subsequent stages.
