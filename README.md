MIPS-processor
==============

VHDL implementation of MIPS processor

Pipeline done on pipeline branch. Explanation for different implementation vhd files:

* TOP.vhd: Act as the interface of the processor. It also contains Instruction Memory and Data Memory.
* MIPS.vhd: Contains all pipes and component. And it will also handle hazard control and data forwarding.
* PC.vhd: pc register
* pipe_if_id.vhd: pipe between if and id stages.
* ControlUnit.vhd: Determine control signals based on the format of instruction.
* RegFile.vhd: Contain 32 general registers.
* pipe_id_ex.vhd: pipe between id and ex stages.
* ALU.vhd: wrapper for alu_lab2, also contains hi lo register.
* alu_lab2.vhd: contains AddSub, shifter and other small components for ALU related operations.
* pipe_ex_mem.vhd: pipe between ex and mem stages.
* pipe_mem_wb.vhd: pipe between mem and wb stages.


Explanation for MIPS.vhd:

* Forwarding to Ex stage for ALU
* Forwarding to Id stage for branch and jr
* Mem-to-mem forwarding
* Load-use stall
* Jump/branch flush
* Jr/branch stall
