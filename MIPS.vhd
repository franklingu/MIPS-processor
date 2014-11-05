----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	MIPS
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: MIPS processor
--
-- Dependencies: PC, ALU, ControlUnit, RegFile
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: DO NOT modify the interface (entity). Implementation (architecture) can be modified.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity MIPS is -- DO NOT modify the interface (entity)
    Port ( 	
			Addr_Instr 		: out STD_LOGIC_VECTOR (31 downto 0);
			Instr 			: in STD_LOGIC_VECTOR (31 downto 0);
			Addr_Data		: out STD_LOGIC_VECTOR (31 downto 0);
			Data_In			: in STD_LOGIC_VECTOR (31 downto 0);
			Data_Out			: out  STD_LOGIC_VECTOR (31 downto 0);
			MemRead 			: out STD_LOGIC; 
			MemWrite 		: out STD_LOGIC; 
			RESET				: in STD_LOGIC;
			CLK				: in STD_LOGIC
			);
end MIPS;


architecture arch_MIPS of MIPS is

----------------------------------------------------------------
-- PC
----------------------------------------------------------------
component PC is
		Port(	
				PC_in 	: in  STD_LOGIC_VECTOR (31 downto 0);
				PC_out 	: out STD_LOGIC_VECTOR (31 downto 0);
				RESET		: in  STD_LOGIC;
				Stall		: in  STD_LOGIC;
				CLK		: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- ALU
----------------------------------------------------------------
component ALU is
		Port (
				CLK			: in  STD_LOGIC;
				ALU_InA 		: in  STD_LOGIC_VECTOR (31 downto 0);				
				ALU_InB 		: in  STD_LOGIC_VECTOR (31 downto 0);
				ALU_Out 		: out STD_LOGIC_VECTOR (31 downto 0);
				ALU_Control	: in  STD_LOGIC_VECTOR (7 downto 0);
				ALU_zero		: out STD_LOGIC;
				ALU_overflow: out STD_LOGIC;
				ALU_busy		: out STD_LOGIC);
end component;

----------------------------------------------------------------
-- Control Unit
----------------------------------------------------------------
component ControlUnit is
		Port ( 	
				Instr	 		: in   STD_LOGIC_VECTOR (31 downto 0);
				ALU_Control : out  STD_LOGIC_VECTOR (7 downto 0);
				Branch 		: out  STD_LOGIC;		
				Jump	 		: out  STD_LOGIC;	
				JumpR	 		: out  STD_LOGIC;	
				MemRead 		: out  STD_LOGIC;	
				MemtoReg 	: out  STD_LOGIC;	
				InstrtoReg	: out  STD_LOGIC;
				PcToReg		: out  STD_LOGIC;
				MemWrite		: out  STD_LOGIC;	
				ALUSrc 		: out  STD_LOGIC;	
				SignExtend 	: out  STD_LOGIC;
				RegWrite		: out  STD_LOGIC;	
				RegDst		: out  STD_LOGIC;
				ZeroToAlu	: out	 STD_LOGIC);
end component;

----------------------------------------------------------------
-- Register File
----------------------------------------------------------------
component RegFile is
		Port ( 	
				ReadAddr1_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
				ReadAddr2_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
				ReadData1_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);
				ReadData2_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);				
				WriteAddr_Reg	: in  STD_LOGIC_VECTOR (4 downto 0); 
				WriteData_Reg 	: in  STD_LOGIC_VECTOR (31 downto 0);
				RegWrite 		: in  STD_LOGIC; 
				CLK 				: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- IF/ID Pipe
----------------------------------------------------------------
component Pipe_If_Id is
		Port (
			  Instr		 	: in  STD_LOGIC_VECTOR(31 downto 0);
           PcPlus4 		: in  STD_LOGIC_VECTOR(31 downto 0);
           Out_Instr 	: out STD_LOGIC_VECTOR(31 downto 0);
           Out_PcPlus4 	: out STD_LOGIC_VECTOR(31 downto 0);
			  Stall			: in  STD_LOGIC;
			  Flush			: in  STD_LOGIC;
           CLK 			: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- ID/EX Pipe
----------------------------------------------------------------
component Pipe_Id_Ex is
		Port (
			  ALUSrc      			: in  STD_LOGIC;
			  ZeroToAlu   			: in  STD_LOGIC;
			  MemRead     			: in  STD_LOGIC;
			  MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
			  PcToReg     			: in  STD_LOGIC;
			  RegWrite    			: in  STD_LOGIC;
			  InstrRs				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRt				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRd				: in  STD_LOGIC_VECTOR(4 downto 0);
			  ALU_Control 			: in  STD_LOGIC_VECTOR(7 downto 0);
			  InstrLower 			: in  STD_LOGIC_VECTOR(15 downto 0);
			  ReadData1_Reg		: in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData2_Reg	   : in  STD_LOGIC_VECTOR(31 downto 0);
			  PcPlus4 				: in  STD_LOGIC_VECTOR(31 downto 0);
			  SignExtended  		: in  STD_LOGIC_VECTOR(31 downto 0);
           Out_ALUSrc      	: out STD_LOGIC;
           Out_ZeroToAlu   	: out STD_LOGIC;
           Out_MemRead     	: out STD_LOGIC;
           Out_MemWrite    	: out STD_LOGIC;
           Out_MemToReg    	: out STD_LOGIC;
           Out_InstrToReg  	: out STD_LOGIC;
           Out_PcToReg     	: out STD_LOGIC;
           Out_RegWrite    	: out STD_LOGIC;
			  Out_InstrRs			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRt			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRd			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_ALU_Control 	: out STD_LOGIC_VECTOR(7 downto 0);
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0);
			  Out_ReadData1_Reg  : out STD_LOGIC_VECTOR(31 downto 0);
           Out_ReadData2_Reg  : out STD_LOGIC_VECTOR(31 downto 0);
			  Out_PcPlus4 			: out STD_LOGIC_VECTOR(31 downto 0);
			  Out_SignExtended  	: out STD_LOGIC_VECTOR(31 downto 0);
			  Stall					: in  STD_LOGIC;
			  CLK 					: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- EX/MEM Pipe
----------------------------------------------------------------
component Pipe_Ex_Mem is
		Port (
			  ALUZero				: in  STD_LOGIC;
           MemRead     			: in  STD_LOGIC;
           MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
           PcToReg     			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
           RegWrite    			: in  STD_LOGIC;
			  InstrRd 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrLower 			: in  STD_LOGIC_VECTOR(15 downto 0);
           PcPlus4 				: in  STD_LOGIC_VECTOR(31 downto 0);
           Alu_out   			: in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData2_Reg  		: in  STD_LOGIC_VECTOR(31 downto 0);
			  Out_ALUZero			: out STD_LOGIC;
           Out_MemRead     	: out STD_LOGIC;
           Out_MemWrite    	: out STD_LOGIC;
			  Out_MemToReg    	: out STD_LOGIC;
           Out_PcToReg     	: out STD_LOGIC;
			  Out_InstrToReg  	: out STD_LOGIC;
			  Out_RegWrite    	: out STD_LOGIC;
			  Out_InstrRd 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0);
           Out_PcPlus4			: out STD_LOGIC_VECTOR(31 downto 0);
           Out_ALU_out  		: out STD_LOGIC_VECTOR(31 downto 0);
           Out_ReadData2_Reg 	: out STD_LOGIC_VECTOR(31 downto 0);
			  Stall					: in  STD_LOGIC;
			  CLK 					: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- MEM/WB Pipe
----------------------------------------------------------------
component Pipe_Mem_Wb is
		Port (
				PcToReg     		: in  STD_LOGIC;
				MemToReg    		: in  STD_LOGIC;
				InstrToReg  		: in  STD_LOGIC;
				RegWrite    		: in  STD_LOGIC;
				InstrRd		 		: in  STD_LOGIC_VECTOR(4 downto 0);
				InstrLower			: in  STD_LOGIC_VECTOR(15 downto 0);
				PcPlus4				: in  STD_LOGIC_VECTOR(31 downto 0);
				MemReadData 		: in  STD_LOGIC_VECTOR(31 downto 0);
				ALU_out				: in  STD_LOGIC_VECTOR(31 downto 0);
				Out_PcToReg 		: out STD_LOGIC;
				Out_MemToReg		: out STD_LOGIC;
				Out_InstrToReg		: out STD_LOGIC;
				Out_RegWrite		: out STD_LOGIC;
				Out_InstrRd			: out STD_LOGIC_VECTOR(4 downto 0);
				Out_InstrLower		: out STD_LOGIC_VECTOR(15 downto 0);
				Out_PCPlus4 		: out STD_LOGIC_VECTOR(31 downto 0);
				Out_MemReadData 	: out STD_LOGIC_VECTOR(31 downto 0);
				Out_ALU_out			: out STD_LOGIC_VECTOR(31 downto 0);
				Stall					: in  STD_LOGIC;
				CLK					: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- PC Signals
----------------------------------------------------------------
	signal	PC_in 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	PC_out 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	PcStall				:  STD_LOGIC;

----------------------------------------------------------------
-- ALU Signals
----------------------------------------------------------------
	signal	ALU_InA 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_InB 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_Out 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_Control			:  STD_LOGIC_VECTOR(7 downto 0);
	signal	ALU_zero				:  STD_LOGIC;
	signal   ALU_overflow		:  STD_LOGIC;
	signal   ALU_busy    		:  STD_LOGIC;

----------------------------------------------------------------
-- Control Unit Signals
----------------------------------------------------------------
	signal	Contr_Branch 		:  STD_LOGIC;
	signal	Contr_Jump	 		:  STD_LOGIC;
	signal	Contr_JumpR	 		:  STD_LOGIC;
	signal	Contr_MemRead 		:  STD_LOGIC;
	signal	Contr_MemWrite		:  STD_LOGIC;
	signal	Contr_MemToReg		:  STD_LOGIC;
	signal	Contr_InstrToReg	:  STD_LOGIC;
	signal	Contr_PcToReg		:  STD_LOGIC;
	signal	Contr_ALUSrc		:  STD_LOGIC;
	signal	Contr_SignExtend 	: 	STD_LOGIC;
	signal	Contr_RegWrite	 	:  STD_LOGIC;
	signal	Contr_RegDst		:  STD_LOGIC;
	signal	Contr_ZeroToALU	:  STD_LOGIC;

----------------------------------------------------------------
-- Register File Signals
----------------------------------------------------------------
 	signal	ReadAddr1_Reg 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ReadAddr2_Reg 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ReadData1_Reg 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ReadData2_Reg 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	WriteAddr_Reg		:  STD_LOGIC_VECTOR(4 downto 0); 
	signal	WriteData_Reg 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	RegWrite				:  STD_LOGIC;

----------------------------------------------------------------
-- IF/ID Pipe Signals
----------------------------------------------------------------
	signal	IfId_Instr			:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_PcPlus4		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_Out_Instr		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_Out_PcPlus4	:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_Stall			:  STD_LOGIC;
	signal	IfId_Flush			:	STD_LOGIC;

----------------------------------------------------------------
-- ID/EX Pipe Signals
----------------------------------------------------------------
	signal	IdEx_ALUSrc      			:  STD_LOGIC;
	signal	IdEx_ZeroToAlu   			:  STD_LOGIC;
	signal	IdEx_MemRead     			:  STD_LOGIC;
	signal	IdEx_MemWrite    			:  STD_LOGIC;
	signal	IdEx_MemToReg    			:  STD_LOGIC;
	signal	IdEx_InstrToReg  			:  STD_LOGIC;
	signal	IdEx_PcToReg     			:  STD_LOGIC;
	signal	IdEx_RegWrite    			:  STD_LOGIC;
	signal	IdEx_InstrRs				:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_InstrRt				:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_InstrRd				:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_ALU_Control 			:  STD_LOGIC_VECTOR(7 downto 0);
	signal	IdEx_InstrLower 			:  STD_LOGIC_VECTOR(15 downto 0);
	signal	IdEx_ReadData1_Reg		:  STD_LOGIC_VECTOR(31 downto 0);
   signal	IdEx_ReadData2_Reg	   :  STD_LOGIC_VECTOR(31 downto 0);
	signal	IdEx_PcPlus4 				:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IdEx_SignExtended  		:  STD_LOGIC_VECTOR(31 downto 0);
   signal	IdEx_Out_ALUSrc      	:  STD_LOGIC;
   signal	IdEx_Out_ZeroToAlu   	:  STD_LOGIC;
   signal	IdEx_Out_MemRead     	:  STD_LOGIC;
   signal	IdEx_Out_MemWrite    	:  STD_LOGIC;
   signal	IdEx_Out_MemToReg    	:  STD_LOGIC;
   signal	IdEx_Out_InstrToReg  	:  STD_LOGIC;
   signal	IdEx_Out_PcToReg     	:  STD_LOGIC;
   signal	IdEx_Out_RegWrite    	:  STD_LOGIC;
	signal	IdEx_Out_RegDst      	:  STD_LOGIC;
	signal	IdEx_Out_InstrRs			:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_Out_InstrRt			:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_Out_InstrRd			:  STD_LOGIC_VECTOR(4 downto 0);
	signal	IdEx_Out_ALU_Control 	:  STD_LOGIC_VECTOR(7 downto 0);
	signal	IdEx_Out_InstrLower 		:  STD_LOGIC_VECTOR(15 downto 0);
	signal	IdEx_Out_ReadData1_Reg  :  STD_LOGIC_VECTOR(31 downto 0);
   signal	IdEx_Out_ReadData2_Reg  :  STD_LOGIC_VECTOR(31 downto 0);
	signal	IdEx_Out_PcPlus4 			:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IdEx_Out_SignExtended  	:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IdEx_Stall					:  STD_LOGIC;

----------------------------------------------------------------
-- EX/MEM Pipe Signals
----------------------------------------------------------------
	signal	ExMem_ALUZero				:  STD_LOGIC;
	signal   ExMem_MemRead     		:  STD_LOGIC;
	signal   ExMem_MemWrite    		:  STD_LOGIC;
	signal	ExMem_MemToReg    		:  STD_LOGIC;
	signal   ExMem_PcToReg     		:  STD_LOGIC;
	signal	ExMem_InstrToReg  		:  STD_LOGIC;
	signal   ExMem_RegWrite    		:  STD_LOGIC;
	signal	ExMem_InstrRd 				:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_InstrLower 			:  STD_LOGIC_VECTOR(15 downto 0);
	signal   ExMem_PcPlus4				:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_ALU_out   			:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_ReadData2_Reg  	:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ExMem_Out_ALUZero			:  STD_LOGIC;
	signal   ExMem_Out_MemRead     	:  STD_LOGIC;
	signal   ExMem_Out_MemWrite    	:  STD_LOGIC;
	signal	ExMem_Out_MemToReg    	:  STD_LOGIC;
	signal   ExMem_Out_PcToReg     	:  STD_LOGIC;
	signal	ExMem_Out_InstrToReg  	:  STD_LOGIC;
	signal	ExMem_Out_RegWrite    	:  STD_LOGIC;
	signal	ExMem_Out_InstrRd 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_Out_InstrLower 	:  STD_LOGIC_VECTOR(15 downto 0);
	signal   ExMem_Out_PcPlus4			:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_Out_Alu_out  		:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_Out_ReadData2_Reg :  STD_LOGIC_VECTOR(31 downto 0);
	signal	ExMem_Stall					:  STD_LOGIC;

----------------------------------------------------------------
-- MEM/Wb Pipe Signals
----------------------------------------------------------------
    signal 	MemWb_PcToReg     		:  STD_LOGIC;
    signal 	MemWb_MemToReg    		:  STD_LOGIC;
    signal 	MemWb_InstrToReg  		:  STD_LOGIC;
    signal 	MemWb_RegWrite    		:  STD_LOGIC;
    signal 	MemWb_InstrRd		 		:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_InstrLower			:  STD_LOGIC_VECTOR(15 downto 0);
    signal 	MemWb_PcPlus4				:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_MemReadData 		:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_ALu_out				:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_PcToReg 		:  STD_LOGIC;
    signal 	MemWb_Out_MemToReg		:  STD_LOGIC;
    signal 	MemWb_Out_InstrToReg		:  STD_LOGIC;
    signal 	MemWb_Out_RegWrite		:  STD_LOGIC;
    signal 	MemWb_Out_InstrRd			:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_Out_InstrLower		:  STD_LOGIC_VECTOR(15 downto 0);
    signal 	MemWb_Out_PCPlus4 		:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_MemReadData 	:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_Alu_out			:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	MemWb_Stall					:  STD_LOGIC;

----------------------------------------------------------------
-- Other Signals
----------------------------------------------------------------
-- Id stage
	 signal	JumpPcTgt					:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	BranchPcTgt					:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	BranchCmp1					:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	BranchCmp2					:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	SignExtended				:  STD_LOGIC_VECTOR(31 downto 0);
-- ex stage
	 signal	ALU_InBCand					:  STD_LOGIC_VECTOR(31 downto 0);
	 signal	ResultFromMem				:  STD_LOGIC_VECTOR(31 downto 0);  -- also used for id stage
	 signal	ResultFromWb				:  STD_LOGIC_VECTOR(31 downto 0);  -- also used for mem stage
-- temp--will be changed later
	 signal	TempALUZero					:  STD_LOGIC;
-- Hazard control
	 signal	LoadUseHazard				:  STD_LOGIC;
	 signal	UpdateBranchHazard		:  STD_LOGIC;
	 signal	UpdateJumpRHazard			:  STD_LOGIC;
	 signal	ControlHazard				:  STD_LOGIC;
	 signal	ALUBusyHazard				:  STD_LOGIC;

----------------------------------------------------------------	
----------------------------------------------------------------
----------------------------------------------------------------
-- <MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
begin

----------------------------------------------------------------
-- PC port map
----------------------------------------------------------------
PC1				: PC port map
						(
						PC_in 	=> PC_in, 
						PC_out 	=> PC_out, 
						RESET 	=> RESET,
						Stall		=> PcStall,
						CLK 		=> CLK
						);
						
----------------------------------------------------------------
-- ALU port map
----------------------------------------------------------------
ALU1 				: ALU port map
						(
						CLK			=> CLK,
						ALU_InA 		=> ALU_InA, 
						ALU_InB 		=> ALU_InB, 
						ALU_Out 		=> ALU_Out, 
						ALU_Control => ALU_Control, 
						ALU_zero  	=> ALU_zero,
						ALU_overflow=> ALU_overflow,
						ALU_busy		=> ALU_busy
						);
						
----------------------------------------------------------------
-- ControlUnit port map
----------------------------------------------------------------
ControlUnit1 	: ControlUnit port map
						(
						Instr 		=> IfId_Out_Instr,
						ALU_Control => IdEx_ALU_Control,
						Branch 		=> Contr_Branch, 
						Jump 			=> Contr_Jump, 
						JumpR 		=> Contr_JumpR, 
						MemRead 		=> Contr_MemRead, 
						MemtoReg 	=> Contr_MemToReg, 
						InstrtoReg 	=> Contr_InstrToReg, 
						PcToReg		=> Contr_PcToReg,
						MemWrite 	=> Contr_MemWrite, 
						ALUSrc 		=> Contr_ALUSrc, 
						SignExtend 	=> Contr_SignExtend, 
						RegWrite 	=> Contr_RegWrite, 
						RegDst 		=> Contr_RegDst,
						ZeroToAlu	=> Contr_ZeroToAlu
						);
						
----------------------------------------------------------------
-- Register file port map
----------------------------------------------------------------
RegFile1			: RegFile port map
						(
						ReadAddr1_Reg 	=>  ReadAddr1_Reg,
						ReadAddr2_Reg 	=>  ReadAddr2_Reg,
						ReadData1_Reg 	=>  ReadData1_Reg,
						ReadData2_Reg 	=>  ReadData2_Reg,
						WriteAddr_Reg 	=>  WriteAddr_Reg,
						WriteData_Reg 	=>  WriteData_Reg,
						RegWrite 		=>  MemWb_Out_RegWrite,
						CLK 				=>  CLK				
						);

----------------------------------------------------------------
-- If/Id pipe port map
----------------------------------------------------------------
PipeIfId1		: Pipe_If_Id port map
						(
						Instr		 		=> IfId_Instr,
						PcPlus4 			=> IfId_PcPlus4,
						Out_Instr 		=> IfId_Out_Instr,
						Out_PcPlus4 	=> IfId_Out_PcPlus4,
						Stall				=> IfId_Stall,
						Flush				=> IfId_Flush,
						CLK 				=> CLK
						);

----------------------------------------------------------------
-- Id/Ex pipe port map
----------------------------------------------------------------
PipeIdEx1		: Pipe_Id_Ex port map
						(
						ALUSrc				=> IdEx_ALUSrc,
						ZeroToAlu   		=> IdEx_ZeroToAlu,
						MemRead     		=> IdEx_MemRead,
						MemWrite    		=> IdEx_MemWrite,
						MemToReg    		=> IdEx_MemToReg,
						InstrToReg  		=> IdEx_InstrToReg,
						PcToReg     		=> IdEx_PcToReg,
						RegWrite    		=> IdEx_RegWrite,
						InstrRs				=> IdEx_InstrRs,
						InstrRt				=> IdEx_InstrRt,
						InstrRd				=> IdEx_InstrRd,
						ALU_Control 		=> IdEx_ALU_Control,
						InstrLower 			=> IdEx_InstrLower,  -- no need to send this for this pipe. sign-extended contains it and will be available for next stage
						ReadData1_Reg		=> IdEx_ReadData1_Reg,
						ReadData2_Reg		=> IdEx_ReadData2_Reg,
						PcPlus4 		   	=> IdEx_PcPlus4,
						SignExtended  		=> IdEx_SignExtended,
						Out_ALUSrc     	=> IdEx_Out_ALUSrc,
						Out_ZeroToAlu  	=> IdEx_Out_ZeroToAlu,
						Out_MemRead    	=> IdEx_Out_MemRead,
						Out_MemWrite   	=> IdEx_Out_MemWrite,
						Out_MemToReg   	=> IdEx_Out_MemToReg,
						Out_InstrToReg 	=> IdEx_Out_InstrToReg,
						Out_PcToReg    	=> IdEx_Out_PcToReg,
						Out_RegWrite   	=> IdEx_Out_RegWrite,
						Out_InstrRs			=> IdEx_Out_InstrRs,
						Out_InstrRt			=> IdEx_Out_InstrRt,
						Out_InstrRd			=> IdEx_Out_InstrRd,
						Out_ALU_Control	=> IdEx_Out_ALU_Control,
						Out_InstrLower 	=> IdEx_Out_InstrLower,
						Out_ReadData1_Reg => IdEx_Out_ReadData1_Reg,
						Out_ReadData2_Reg => IdEx_Out_ReadData2_Reg,
						Out_PcPlus4 	   => IdEx_Out_PcPlus4,
						Out_SignExtended  => IdEx_Out_SignExtended,
						Stall					=> IdEx_Stall,
						CLK 			      => CLK
						);

----------------------------------------------------------------
-- Ex/Mem pipe port map
----------------------------------------------------------------
PipeExMem1		: Pipe_Ex_Mem port map
						(
						ALUZero				=>  ExMem_ALUZero,
						MemRead     		=>  ExMem_MemRead,
						MemWrite    		=>  ExMem_MemWrite,
						MemToReg    		=>  ExMem_MemToReg,
						PcToReg     		=>  ExMem_PcToReg,
						InstrToReg  		=>  ExMem_InstrToReg,
						RegWrite    		=>  ExMem_RegWrite,
						InstrRd 				=>  ExMem_InstrRd,
						InstrLower 			=>  ExMem_InstrLower,
						PcPlus4 				=>  ExMem_PcPlus4,
						ALU_out   			=>  ExMem_ALU_out,
						ReadData2_Reg  	=>  ExMem_ReadData2_Reg,
						Out_ALUZero			=>  ExMem_Out_ALUZero,
						Out_MemRead     	=>  ExMem_Out_MemRead ,
						Out_MemWrite    	=>  ExMem_Out_MemWrite,
						Out_MemToReg    	=>  ExMem_Out_MemToReg,
						Out_PcToReg     	=>  ExMem_Out_PcToReg,
						Out_InstrToReg  	=>  ExMem_Out_InstrToReg,
						Out_RegWrite    	=>  ExMem_Out_RegWrite,
						Out_InstrRd 		=>  ExMem_Out_InstrRd,
						Out_InstrLower 	=>  ExMem_Out_InstrLower,
						Out_PcPlus4			=>  ExMem_Out_PcPlus4,
						Out_ALU_out  		=>  ExMem_Out_ALU_out,
						Out_ReadData2_Reg =>  ExMem_Out_ReadData2_Reg,
						Stall					=>  ExMem_Stall,
						CLK 					=>  CLK
						);

----------------------------------------------------------------
-- Ex/Mem pipe port map
----------------------------------------------------------------
PipeMemWb1      : Pipe_Mem_Wb port map
						(
						PcToReg     		=>  MemWb_PcToReg,
						MemToReg    		=>  MemWb_MemToReg,
						InstrToReg  		=>  MemWb_InstrToReg,
						RegWrite    		=>  MemWb_RegWrite,
						InstrRd		 		=>  MemWb_InstrRd,
						InstrLower			=>  MemWb_InstrLower,
						PcPlus4				=>  MemWb_PcPlus4,
						MemReadData 		=>  MemWb_MemReadData,
						Alu_out				=>  MemWb_Alu_out,
						Out_PcToReg 		=>  MemWb_Out_PcToReg,
						Out_MemToReg		=>  MemWb_Out_MemToReg ,
						Out_InstrToReg		=>  MemWb_Out_InstrToReg,
						Out_RegWrite		=>  MemWb_Out_RegWrite,
						Out_InstrRd			=>  MemWb_Out_InstrRd,
						Out_InstrLower		=>  MemWb_Out_InstrLower,
						Out_PCPlus4 		=>  MemWb_Out_PCPlus4,
						Out_MemReadData 	=>  MemWb_Out_MemReadData,
						Out_Alu_out			=>  MemWb_Out_Alu_out,
						Stall					=>  MemWb_Stall,
						CLK					=>  CLK
						);

----------------------------------------------------------------
----------------------------------------------------------------
-- Processor logic
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------
-- IF stage
----------------------------------------------------------------
-- stall
PcStall <= LoadUseHazard when LoadUseHazard = '1' else
			  UpdateBranchHazard when UpdateBranchHazard = '1' else
			  UpdateJumpRHazard when UpdateJumpRHazard = '1' else
			  ALUBusyHazard;
IfId_Stall <= LoadUseHazard when LoadUseHazard = '1' else
				  UpdateBranchHazard when UpdateBranchHazard = '1' else
				  UpdateJumpRHazard when UpdateJumpRHazard = '1' else
				  ALUBusyHazard;
IfId_Flush <= '1' when ControlHazard = '1' and UpdateBranchHazard = '0' and UpdateJumpRHazard = '0' else
				  '0';
-- for InstrMem
Addr_Instr <= PC_out;
-- for pipe
IfId_Instr <= Instr;
IfId_PcPlus4 <= PC_out + 4;
-- multiplexer
PC_in <= JumpPcTgt when Contr_JumpR = '1' else
			JumpPcTgt when Contr_Jump = '1' else
			BranchPcTgt when Contr_Branch = '1' else
			IfId_PcPlus4;

----------------------------------------------------------------
-- ID stage
----------------------------------------------------------------
-- stall
IdEx_Stall <= ALUBusyHazard;
-- read addr
ReadAddr1_Reg <= IfId_Out_Instr(25 downto 21);
ReadAddr2_Reg <= IfId_Out_Instr(20 downto 16);
-- sign-extended
SignExtended(31 downto 16) <= (others => (Contr_SignExtend and IfId_Out_Instr(15)));
SignExtended(15 downto 0) <= IfId_Out_Instr(15 downto 0);
-- jump
JumpPcTgt <= ResultFromMem when Contr_JumpR = '1' 
										and not(ExMem_Out_InstrRd = "00000")
										and ExMem_Out_InstrRd = IfId_Out_Instr(25 downto 21) else
				 ReadData1_Reg when Contr_JumpR = '1' else
				 IfId_Out_PcPlus4(31 downto 28) & IfId_Out_Instr(25 downto 0) & "00" when Contr_Jump = '1' else
				 IfId_PcPlus4;
-- branch (beq, bgez, bgezal)
BranchCmp1 <= ResultFromMem when Contr_Branch = '1' 
										and not(ExMem_Out_InstrRd = "00000")
										and ExMem_Out_InstrRd = IfId_Out_Instr(25 downto 21) else
				  ReadData1_Reg;
BranchCmp2 <= ResultFromMem when Contr_Branch = '1' 
										and not(ExMem_Out_InstrRd = "00000")
										and ExMem_Out_InstrRd = IfId_Out_Instr(20 downto 16) else
				  ReadData2_Reg;
BranchPcTgt <= IdEx_Out_PcPlus4 + (SignExtended(29 downto 0) & "00") when Contr_Branch = '1' 
																								and Contr_ZeroToALU = '0'
																								and BranchCmp1 = BranchCmp2 else
					IdEx_Out_PcPlus4 + (SignExtended(29 downto 0) & "00") when Contr_Branch = '1' 
																								and Contr_ZeroToALU = '1'
																								and (not(BranchCmp1(31) = '1')) else
					IfId_PcPlus4;
-- pipe
IdEx_ALUSrc <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					Contr_ALUSrc;
IdEx_ZeroToALU <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
						Contr_ZeroToALU;
IdEx_MemRead <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					 Contr_MemRead;
IdEx_MemWrite <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					  Contr_MemWrite;
IdEx_MemToReg <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					  Contr_MemToReg;
IdEx_InstrToReg <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
						 Contr_InstrToReg;
IdEx_PcToReg <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					 Contr_PcToReg;
IdEx_RegWrite <= '0' when LoadUseHazard = '1' or ALUBusyHazard = '1' else
					  Contr_RegWrite;

IdEx_InstrRs <= IfId_Out_Instr(25 downto 21);
IdEx_InstrRt <= IfId_Out_Instr(20 downto 16);
IdEx_InstrRd <= "11111" when Contr_PcToReg = '1' else
					 IfId_Out_Instr(15 downto 11) when Contr_RegDst = '1' else
					 IfId_Out_Instr(20 downto 16);
IdEx_InstrLower <= IfId_Out_Instr(15 downto 0);
IdEx_ReadData1_Reg <= ReadData1_Reg;
IdEx_ReadData2_Reg <= ReadData2_Reg;
IdEx_PcPlus4 <= IfId_Out_PcPlus4;
IdEx_SignExtended <= SignExtended;

----------------------------------------------------------------
-- Hazard control
----------------------------------------------------------------
LoadUseHazard <= '1' when IdEx_Out_MemRead = '1' 
								and (IdEx_Out_InstrRt = IfId_Out_Instr(25 downto 21)
									or IdEx_Out_InstrRt = IfId_Out_Instr(25 downto 21)) else
					  '0';
ControlHazard <= '1' when Contr_Branch = '1' or Contr_Jump = '1' or Contr_JumpR = '1' else
					  '0';
UpdateBranchHazard <= '1' when Contr_Branch = '1' 
										and not(IdEx_Out_InstrRd = "00000")
										and IdEx_Out_InstrRd = IfId_Out_Instr(25 downto 21) else
							 '1' when Contr_Branch = '1'  -- only beq has rt
										and Contr_ZeroToALU = '0'
										and not(IdEx_Out_InstrRd = "00000")
										and IdEx_Out_InstrRd = IfId_Out_Instr(20 downto 16) else
							 '0';
UpdateJumpRHazard <= '1' when Contr_JumpR = '1'
										and not(IdEx_Out_InstrRd = "00000")
										and IdEx_Out_InstrRd = IfId_Out_Instr(25 downto 21) else
							'0';
ALUBusyHazard <= ALU_busy;

----------------------------------------------------------------
-- EX stage
----------------------------------------------------------------
-- stall
ExMem_Stall <= '0';  -- most likely will be deleted afterwards
-- control signals
ALU_Control <= IdEx_Out_ALU_Control;
-- forward unit
ResultFromMem <= ExMem_Out_PCPlus4 when ExMem_Out_PcToReg = '1' else
					  ExMem_Out_InstrLower & "0000000000000000" when ExMem_Out_InstrToReg = '1' else
					  ExMem_Out_Alu_out;
ResultFromWb <= MemWb_Out_PCPlus4 when MemWb_Out_PcToReg = '1' else
					 MemWb_Out_MemReadData when MemWb_Out_MemToReg = '1' else
					 MemWb_Out_InstrLower & "0000000000000000" when MemWb_Out_InstrToReg = '1' else
					 MemWb_Out_Alu_out;
ALU_InA <= ResultFromMem when ExMem_Out_RegWrite = '1' 
										and not(ExMem_Out_InstrRd = "00000") 
										and ExMem_Out_InstrRd = IdEx_Out_InstrRs else
			  ResultFromWb when MemWb_Out_RegWrite = '1' 
										and not(MemWb_Out_InstrRd = "00000") 
										and not(ExMem_Out_InstrRd = MemWb_Out_InstrRd) 
										and MemWb_Out_InstrRd = IdEx_Out_InstrRs else
			  IdEx_Out_ReadData1_Reg;
ALU_InBCand <= ResultFromMem when ExMem_Out_RegWrite = '1' 
										and not(ExMem_Out_InstrRd = "00000") 
										and ExMem_Out_InstrRd = IdEx_Out_InstrRt else
					ResultFromWb when MemWb_Out_RegWrite = '1' 
										and not(MemWb_Out_InstrRd = "00000") 
										and not(ExMem_Out_InstrRd = MemWb_Out_InstrRd) 
										and MemWb_Out_InstrRd = IdEx_Out_InstrRt else
					IdEx_Out_ReadData2_Reg;
-- other multiplexers
ALU_InB <= (others => '0') when IdEx_Out_ZeroToAlu = '1' else
			  IdEx_Out_SignExtended when IdEx_Out_ALUSrc = '1' else
			  ALU_InBCand;
-- pipe
TempALUZero <= ALU_zero;
ExMem_ALUZero <= TempALUZero;
ExMem_MemRead <= IdEx_Out_MemRead;
ExMem_MemWrite <= IdEx_Out_MemWrite;
ExMem_MemToReg <= IdEx_Out_MemToReg;
ExMem_PcToReg <= IdEx_Out_PcToReg;
ExMem_InstrToReg <= IdEx_Out_InstrToReg;
ExMem_RegWrite <= IdEx_Out_RegWrite;
ExMem_InstrRd <= IdEx_Out_InstrRd;
ExMem_InstrLower <= IdEx_Out_InstrLower;
ExMem_PcPlus4 <= IdEx_Out_PcPlus4;
ExMem_ALU_out <= ALU_out;
ExMem_ReadData2_Reg <= IdEx_Out_ReadData2_Reg;

----------------------------------------------------------------
-- MEM stage
----------------------------------------------------------------
-- stall
MemWb_Stall <= '0';  -- most likely will be deleted afterwards
-- send to memory
MemRead <= ExMem_Out_MemRead;
MemWrite <= ExMem_Out_MemWrite;
Addr_Data <= ExMem_Out_ALU_out;
Data_Out <= ResultFromWb when MemWb_Out_RegWrite = '1' 
										and not(MemWb_Out_InstrRd = "00000") 
										and MemWb_Out_InstrRd = ExMem_Out_InstrRd else
				ExMem_Out_ReadData2_Reg;  -- fwd from mem to mem
-- pipe
MemWb_PcToReg <= ExMem_Out_PcToReg;
MemWb_MemToReg <= ExMem_Out_MemToReg;
MemWb_InstrToReg <= ExMem_Out_InstrToReg;
MemWb_RegWrite <= ExMem_Out_RegWrite;
MemWb_InstrRd <= ExMem_Out_InstrRd;
MemWb_InstrLower <= ExMem_Out_InstrLower;
MemWb_PcPlus4 <= ExMem_Out_PcPlus4;
MemWb_MemReadData <= Data_In;
MemWb_Alu_out <= ExMem_Out_ALU_out;

----------------------------------------------------------------
-- WB stage
----------------------------------------------------------------
WriteAddr_Reg <= MemWb_Out_InstrRd;
WriteData_Reg <= MemWb_Out_PCPlus4 when MemWb_Out_PcToReg = '1' else
					  MemWb_Out_MemReadData when MemWb_Out_MemToReg = '1' else
					  MemWb_Out_InstrLower & "0000000000000000" when MemWb_Out_InstrToReg = '1' else
					  MemWb_Out_ALU_out;

end arch_MIPS;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
