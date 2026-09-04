FSM Traffic Light Controller
A SystemVerilog Moore Finite State Machine (FSM) designed to control a single-intersection traffic light. It manages main and crossroad traffic while handling dynamic pedestrian crossing requests and high-priority emergency vehicle overrides.

Key Features
Moore Architecture: Utilizes a strict three-block SystemVerilog design pattern (sequential memory, next-state logic, combinational output) for glitch-free operation.

Pedestrian Integration: Diverts to a dedicated pedestrian walk phase from a wait state upon request without breaking the primary cycle.

Emergency Override: Instantly forces an all-red state across the intersection for emergency vehicles, safely resuming the cycle once cleared.

Modular Codebase: Encapsulates state enumerations and cycle countdown timers in a shared package (traffic_pkg.sv) to eliminate duplication.

File Structure
traffic_pkg.sv: Defines state parameters and timer constants.

traffic_light.sv: The core FSM controller logic.

tb_traffic_light.sv: Testbench for verifying transitions, timers, and priority interrupts.

Simulation Setup
When simulating in your preferred EDA tool (ModelSim, Vivado, etc.), ensure the package file is compiled before the main module and testbench:

Bash
vlog traffic_pkg.sv
vlog traffic_light.sv
vlog tb_traffic_light.sv
