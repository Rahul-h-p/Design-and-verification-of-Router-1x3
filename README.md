# Design-and-verification-of-Router-1x3-using UVM-Architecture-in-Questa-Simulator
<h2>Verifying the packet routing ability, parity checking, reset, sending packet and reading packet also tested the functional coverage and assertion successfully.</h2>
<br>
<h3>🛠️Router1x3</h3> 
RTL Design and UVM-Based Verification This repository showcases the RTL implementation and comprehensive verification of a Router1x3, a digital circuit component designed to route incoming data packets to one of three output ports based on address logic. The project is developed using Verilog HDL for design and UVM (Universal Verification Methodology) for structured, reusable verification.
<br>
<br>
<h3>🔍Overview</h3> 
Router1x3 acts as a data traffic controller, intelligently forwarding packets of varying lengths to their designated output channels. The module interprets the destination address within the packet to determine the appropriate route.
<br><br>
<h3>🔧 Design Components</h3> 
1. FIFO (First-In-First-Out) Buffer: Temporary storage for packet data.
<br><br>
2. Synchronizer: Handles asynchronous clock domain crossing.
<br><br>
3. Register Block: Holds control and data fields.
<br><br>
4. Controller: FSM-driven logic to manage routing based on address decoding.
<br><br>
<h3>✅ Verification Highlights </h3>
1. Universal Verification Methodology (UVM) testbench for scalable and modular verification.
<br><br>
2. Constraint-random test generation for wide functional coverage.
<br><br>
3. Assertions used to verify protocol compliance and catch corner cases.
<br><br>
4. Functional Coverage metrics implemented to ensure full feature testing and completeness of verification.
<br><br>
<h3>🧰 Tools & Environment</h3> 
1. Xilinx ISE: For simulation, synthesis, and analysis of RTL.
<br><br>
2. QuestaSim: Used for UVM simulation, debugging, and coverage analysis.
