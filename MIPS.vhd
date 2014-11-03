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
				PC_in 	: in STD_LOGIC_VECTOR (31 downto 0);
				PC_out 	: out STD_LOGIC_VECTOR (31 downto 0);
				RESET		: in STD_LOGIC;
				CLK		: in STD_LOGIC);
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
           Out_Instr 	: out  STD_LOGIC_VECTOR(31 downto 0);
           Out_PcPlus4 	: out  STD_LOGIC_VECTOR(31 downto 0);
           CLK 			: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- ID/EX Pipe
----------------------------------------------------------------
component Pipe_Id_Ex is
		Port (
			  ALUSrc      			: in  STD_LOGIC;
			  ZeroToAlu   			: in  STD_LOGIC;
			  Branch      			: in  STD_LOGIC;
			  MemRead     			: in  STD_LOGIC;
			  MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
			  PcToReg     			: in  STD_LOGIC;
			  RegWrite    			: in  STD_LOGIC;
			  RegDst      			: in  STD_LOGIC;
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
           Out_Branch      	: out STD_LOGIC;
           Out_MemRead     	: out STD_LOGIC;
           Out_MemWrite    	: out STD_LOGIC;
           Out_MemToReg    	: out STD_LOGIC;
           Out_InstrToReg  	: out STD_LOGIC;
           Out_PcToReg     	: out STD_LOGIC;
           Out_RegWrite    	: out STD_LOGIC;
			  Out_RegDst      	: out STD_LOGIC;
			  Out_InstrRs			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRt			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRd			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_ALU_Control 	: out STD_LOGIC_VECTOR(7 downto 0);
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0);
			  Out_ReadData1_Reg  : out STD_LOGIC_VECTOR(31 downto 0);
           Out_ReadData2_Reg  : out STD_LOGIC_VECTOR(31 downto 0);
			  Out_PcPlus4 			: out STD_LOGIC_VECTOR(31 downto 0);
			  Out_SignExtended  	: out STD_LOGIC_VECTOR(31 downto 0);
			  CLK 					: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- EX/MEM Pipe
----------------------------------------------------------------
component Pipe_Ex_Mem is
		Port (
			  Branch      			: in  STD_LOGIC;
			  ALUZero				: in  STD_LOGIC;
           MemRead     			: in  STD_LOGIC;
           MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
           PcToReg     			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
			  RegDst					: in  STD_LOGIC;
           RegWrite    			: in  STD_LOGIC;
			  InstrRs 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRt 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRd 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrLower 			: in  STD_LOGIC_VECTOR(15 downto 0);
           PcPlus4 				: in  STD_LOGIC_VECTOR(31 downto 0);
			  BranchPcTgt 			: in  STD_LOGIC_VECTOR(31 downto 0);
           Alu_out   			: in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData2_Reg  		: in  STD_LOGIC_VECTOR(31 downto 0);
           Out_Branch      	: out STD_LOGIC;
			  Out_ALUZero			: out STD_LOGIC;
           Out_MemRead     	: out STD_LOGIC;
           Out_MemWrite    	: out STD_LOGIC;
			  Out_MemToReg    	: out STD_LOGIC;
           Out_PcToReg     	: out STD_LOGIC;
			  Out_InstrToReg  	: out STD_LOGIC;
			  Out_RegDst			: out STD_LOGIC;
			  Out_RegWrite    	: out STD_LOGIC;
			  Out_InstrRs 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRt 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRd 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0);
           Out_PcPlus4			: out STD_LOGIC_VECTOR(31 downto 0);
			  Out_BranchPcTgt		: out STD_LOGIC_VECTOR(31 downto 0);
           Out_Alu_out  		: out STD_LOGIC_VECTOR(31 downto 0);
           Out_ReadData2_Reg 	: out STD_LOGIC_VECTOR(31 downto 0);
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
				RegDst				: in  STD_LOGIC;
				RegWrite    		: in  STD_LOGIC;
				InstrRs		 		: in  STD_LOGIC_VECTOR(4 downto 0);
				InstrRt		 		: in  STD_LOGIC_VECTOR(4 downto 0);
				InstrRd		 		: in  STD_LOGIC_VECTOR(4 downto 0);
				InstrLower			: in  STD_LOGIC_VECTOR(15 downto 0);
				PcPlus4				: in  STD_LOGIC_VECTOR(31 downto 0);
				MemReadData 		: in  STD_LOGIC_VECTOR(31 downto 0);
				Alu_out				: in  STD_LOGIC_VECTOR(31 downto 0);
				Out_PcToReg 		: out STD_LOGIC;
				Out_MemToReg		: out STD_LOGIC;
				Out_InstrToReg		: out STD_LOGIC;
				Out_RegDst			: out STD_LOGIC;
				Out_RegWrite		: out STD_LOGIC;
				Out_InstrRs			: out STD_LOGIC_VECTOR(4 downto 0);
				Out_InstrRt			: out STD_LOGIC_VECTOR(4 downto 0);
				Out_InstrRd			: out STD_LOGIC_VECTOR(4 downto 0);
				Out_InstrLower		: out STD_LOGIC_VECTOR(15 downto 0);
				Out_PCPlus4 		: out STD_LOGIC_VECTOR(31 downto 0);
				Out_MemReadData 	: out STD_LOGIC_VECTOR(31 downto 0);
				Out_Alu_out			: out STD_LOGIC_VECTOR(31 downto 0);
				CLK					: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- PC Signals
----------------------------------------------------------------
	signal	PC_in 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	PC_out 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal 	PC_increment: 	STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	signal   PC_temp		: 	STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

----------------------------------------------------------------
-- ALU Signals
----------------------------------------------------------------
	signal	ALU_InA 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_InB 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_Out 		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ALU_Control	:  STD_LOGIC_VECTOR(7 downto 0);
	signal	ALU_zero		:  STD_LOGIC;
	signal   ALU_overflow:  STD_LOGIC;
	signal   ALU_busy    :  STD_LOGIC;

----------------------------------------------------------------
-- Control Unit Signals
----------------------------------------------------------------				
	signal	Branch 		:  STD_LOGIC;
	signal	Jump	 		:  STD_LOGIC;
	signal	JumpR	 		:  STD_LOGIC;	
	signal	MemtoReg 	:  STD_LOGIC;
	signal 	InstrtoReg	: 	STD_LOGIC;
	signal 	PcToReg		:	STD_LOGIC;
	signal	ALUSrc 		:  STD_LOGIC;	
	signal	SignExtend 	: 	STD_LOGIC;
	signal	RegWrite		: 	STD_LOGIC;	
	signal	RegDst		:  STD_LOGIC;
	signal	ZeroToAlu	:	STD_LOGIC;

----------------------------------------------------------------
-- Register File Signals
----------------------------------------------------------------
 	signal	ReadAddr1_Reg 	:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ReadAddr2_Reg 	:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ReadData1_Reg 	:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ReadData2_Reg 	:  STD_LOGIC_VECTOR(31 downto 0);
	signal	WriteAddr_Reg	:  STD_LOGIC_VECTOR(4 downto 0); 
	signal	WriteData_Reg 	:  STD_LOGIC_VECTOR(31 downto 0);

----------------------------------------------------------------
-- IF/ID Pipe Signals
----------------------------------------------------------------
	signal	IfId_Instr			:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_PcPlus4		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_Out_Instr		:  STD_LOGIC_VECTOR(31 downto 0);
	signal	IfId_Out_PcPlus4	:  STD_LOGIC_VECTOR(31 downto 0);

----------------------------------------------------------------
-- ID/EX Pipe Signals
----------------------------------------------------------------
	signal	IdEx_ALUSrc      			:  STD_LOGIC;
	signal	IdEx_ZeroToAlu   			:  STD_LOGIC;
	signal	IdEx_Branch      			:  STD_LOGIC;
	signal	IdEx_MemRead     			:  STD_LOGIC;
	signal	IdEx_MemWrite    			:  STD_LOGIC;
	signal	IdEx_MemToReg    			:  STD_LOGIC;
	signal	IdEx_InstrToReg  			:  STD_LOGIC;
	signal	IdEx_PcToReg     			:  STD_LOGIC;
	signal	IdEx_RegWrite    			:  STD_LOGIC;
	signal	IdEx_RegDst      			:  STD_LOGIC;
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
   signal	IdEx_Out_Branch      	:  STD_LOGIC;
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

----------------------------------------------------------------
-- EX/MEM Pipe Signals
----------------------------------------------------------------
	signal	ExMem_Branch      		: STD_LOGIC;
	signal	ExMem_ALUZero				: STD_LOGIC;
	signal   ExMem_MemRead     		: STD_LOGIC;
	signal   ExMem_MemWrite    		: STD_LOGIC;
	signal	ExMem_MemToReg    		: STD_LOGIC;
	signal   ExMem_PcToReg     		: STD_LOGIC;
	signal	ExMem_InstrToReg  		: STD_LOGIC;
	signal	ExMem_RegDst				: STD_LOGIC;
	signal   ExMem_RegWrite    		: STD_LOGIC;
	signal	ExMem_InstrRs 				: STD_LOGIC_VECTOR(4 downto 0); -- does not seem to be useful either
	signal	ExMem_InstrRt 				: STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_InstrRd 				: STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_InstrLower 			: STD_LOGIC_VECTOR(15 downto 0);
	signal   ExMem_PcPlus4 				: STD_LOGIC_VECTOR(31 downto 0);
	signal	ExMem_BranchPcTgt 		: STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_Alu_out   			: STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_ReadData2_Reg  	: STD_LOGIC_VECTOR(31 downto 0);		  
	signal   ExMem_Out_Branch      	:  STD_LOGIC;
	signal	ExMem_Out_ALUZero			:  STD_LOGIC;
	signal   ExMem_Out_MemRead     	:  STD_LOGIC;
	signal   ExMem_Out_MemWrite    	:  STD_LOGIC;
	signal	ExMem_Out_MemToReg    	:  STD_LOGIC;
	signal   ExMem_Out_PcToReg     	:  STD_LOGIC;
	signal	ExMem_Out_InstrToReg  	:  STD_LOGIC;
	signal	ExMem_Out_RegDst			:  STD_LOGIC;
	signal	ExMem_Out_RegWrite    	:  STD_LOGIC;
	signal	ExMem_Out_InstrRs 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_Out_InstrRt 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_Out_InstrRd 		:  STD_LOGIC_VECTOR(4 downto 0);
	signal	ExMem_Out_InstrLower 	:  STD_LOGIC_VECTOR(15 downto 0);
	signal   ExMem_Out_PcPlus4			:  STD_LOGIC_VECTOR(31 downto 0);
	signal	ExMem_Out_BranchPcTgt	:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_Out_Alu_out  		:  STD_LOGIC_VECTOR(31 downto 0);
	signal   ExMem_Out_ReadData2_Reg :  STD_LOGIC_VECTOR(31 downto 0);

----------------------------------------------------------------
-- MEM/Wb Pipe Signals
----------------------------------------------------------------
    signal 	MemWb_PcToReg     		:  STD_LOGIC;
    signal 	MemWb_MemToReg    		:  STD_LOGIC;
    signal 	MemWb_InstrToReg  		:  STD_LOGIC;
    signal 	MemWb_RegDst				:  STD_LOGIC;
    signal 	MemWb_RegWrite    		:  STD_LOGIC;
    signal 	MemWb_InstrRs		 		:  STD_LOGIC_VECTOR(4 downto 0); -- seems to be not really useful
    signal 	MemWb_InstrRt		 		:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_InstrRd		 		:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_InstrLower			:  STD_LOGIC_VECTOR(15 downto 0);
    signal 	MemWb_PcPlus4				:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_MemReadData 		:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Alu_out				:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_PcToReg 		:  STD_LOGIC;
    signal 	MemWb_Out_MemToReg		:  STD_LOGIC;
    signal 	MemWb_Out_InstrToReg		:  STD_LOGIC;
    signal 	MemWb_Out_RegDst			:  STD_LOGIC;
    signal 	MemWb_Out_RegWrite		:  STD_LOGIC;
    signal 	MemWb_Out_InstrRs			:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_Out_InstrRt			:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_Out_InstrRd			:  STD_LOGIC_VECTOR(4 downto 0);
    signal 	MemWb_Out_InstrLower		:  STD_LOGIC_VECTOR(15 downto 0);
    signal 	MemWb_Out_PCPlus4 		:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_MemReadData 	:  STD_LOGIC_VECTOR(31 downto 0);
    signal 	MemWb_Out_Alu_out			:  STD_LOGIC_VECTOR(31 downto 0);

----------------------------------------------------------------
-- Other Signals
----------------------------------------------------------------
 

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
						Instr 		=> Instr, 
						ALU_Control => ALU_Control,
						Branch 		=> Branch, 
						Jump 			=> Jump, 
						JumpR 		=> JumpR, 
						MemRead 		=> MemRead, 
						MemtoReg 	=> MemtoReg, 
						InstrtoReg 	=> InstrtoReg, 
						PcToReg		=> PcToReg,
						MemWrite 	=> MemWrite, 
						ALUSrc 		=> ALUSrc, 
						SignExtend 	=> SignExtend, 
						RegWrite 	=> RegWrite, 
						RegDst 		=> RegDst,
						ZeroToAlu	=> ZeroToAlu
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
						RegWrite 		=>  RegWrite,
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
						CLK 				=> CLK
						);

----------------------------------------------------------------
-- Id/Ex pipe port map
----------------------------------------------------------------
PipeIdEx1		: Pipe_Id_Ex port map
						(
						ALUSrc				=> IdEx_ALUSrc,
						ZeroToAlu   		=> IdEx_ZeroToAlu,
						Branch      		=> IdEx_Branch,
						MemRead     		=> IdEx_MemRead,
						MemWrite    		=> IdEx_MemWrite,
						MemToReg    		=> IdEx_MemToReg,
						InstrToReg  		=> IdEx_InstrToReg,
						PcToReg     		=> IdEx_PcToReg ,
						RegWrite    		=> IdEx_RegWrite,
						RegDst      		=> IdEx_RegDst,
						InstrRs				=> IdEx_InstrRs,
						InstrRt				=> IdEx_InstrRt,
						InstrRd				=> IdEx_InstrRd,
						ALU_Control 		=> IdEx_ALU_Control,
						InstrLower 			=> IdEx_InstrLower,
						ReadData1_Reg		=> IdEx_ReadData1_Reg,
						ReadData2_Reg		=> IdEx_ReadData2_Reg,
						PcPlus4 		   	=> IdEx_PcPlus4,
						SignExtended  		=> IdEx_SignExtended,
						Out_ALUSrc     	=> IdEx_Out_ALUSrc,
						Out_ZeroToAlu  	=> IdEx_Out_ZeroToAlu,
						Out_Branch     	=> IdEx_Out_Branch,
						Out_MemRead    	=> IdEx_Out_MemRead ,
						Out_MemWrite   	=> IdEx_Out_MemWrite,
						Out_MemToReg   	=> IdEx_Out_MemToReg,
						Out_InstrToReg 	=> IdEx_Out_InstrToReg,
						Out_PcToReg    	=> IdEx_Out_PcToReg ,
						Out_RegWrite   	=> IdEx_Out_RegWrite,
						Out_RegDst     	=> IdEx_Out_RegDst,
						Out_InstrRs			=> IdEx_Out_InstrRs,
						Out_InstrRt			=> IdEx_Out_InstrRt ,
						Out_InstrRd			=> IdEx_Out_InstrRd ,
						Out_ALU_Control	=> IdEx_Out_ALU_Control,
						Out_InstrLower 	=> IdEx_Out_InstrLower ,
						Out_ReadData1_Reg => IdEx_Out_ReadData1_Reg,
						Out_ReadData2_Reg => IdEx_Out_ReadData2_Reg,
						Out_PcPlus4 	   => IdEx_Out_PcPlus4 ,
						Out_SignExtended  => IdEx_Out_SignExtended ,
						CLK 			      => CLK
						);

----------------------------------------------------------------
-- Ex/Mem pipe port map
----------------------------------------------------------------
PipeExMem1		: Pipe_Ex_Mem port map
						(
						Branch      		=>  ExMem_Branch,
						ALUZero				=>  ExMem_ALUZero,
						MemRead     		=>  ExMem_MemRead,
						MemWrite    		=>  ExMem_MemWrite,
						MemToReg    		=>  ExMem_MemToReg,
						PcToReg     		=>  ExMem_PcToReg,
						InstrToReg  		=>  ExMem_InstrToReg,
						RegDst				=>  ExMem_RegDst,
						RegWrite    		=>  ExMem_RegWrite,
						InstrRs 				=>  ExMem_InstrRs,
						InstrRt 				=>  ExMem_InstrRt,
						InstrRd 				=>  ExMem_InstrRd,
						InstrLower 			=>  ExMem_InstrLower,
						PcPlus4 				=>  ExMem_PcPlus4,
						BranchPcTgt 		=>  ExMem_BranchPcTgt,
						Alu_out   			=>  ExMem_Alu_out,
						ReadData2_Reg  	=>  ExMem_ReadData2_Reg,
						Out_Branch      	=>  ExMem_Out_Branch,
						Out_ALUZero			=>  ExMem_Out_ALUZero,
						Out_MemRead     	=>  ExMem_Out_MemRead ,
						Out_MemWrite    	=>  ExMem_Out_MemWrite,
						Out_MemToReg    	=>  ExMem_Out_MemToReg,
						Out_PcToReg     	=>  ExMem_Out_PcToReg,
						Out_InstrToReg  	=>  ExMem_Out_InstrToReg,
						Out_RegDst			=>  ExMem_Out_RegDst,
						Out_RegWrite    	=>  ExMem_Out_RegWrite,
						Out_InstrRs 		=>  ExMem_Out_InstrRs,
						Out_InstrRt 		=>  ExMem_Out_InstrRt,
						Out_InstrRd 		=>  ExMem_Out_InstrRd,
						Out_InstrLower 	=>  ExMem_Out_InstrLower,
						Out_PcPlus4			=>  ExMem_Out_PcPlus4,
						Out_BranchPcTgt	=>  ExMem_Out_BranchPcTgt,
						Out_Alu_out  		=>  ExMem_Out_Alu_out,
						Out_ReadData2_Reg =>  ExMem_Out_ReadData2_Reg,
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
						RegDst				=>  MemWb_RegDst,
						RegWrite    		=>  MemWb_RegWrite,
						InstrRs		 		=>  MemWb_InstrRs,
						InstrRt		 		=>  MemWb_InstrRt,
						InstrRd		 		=>  MemWb_InstrRd,
						InstrLower			=>  MemWb_InstrLower,
						PcPlus4				=>  MemWb_PcPlus4,
						MemReadData 		=>  MemWb_MemReadData,
						Alu_out				=>  MemWb_Alu_out,
						Out_PcToReg 		=>  MemWb_Out_PcToReg,
						Out_MemToReg		=>  MemWb_Out_MemToReg ,
						Out_InstrToReg		=>  MemWb_Out_InstrToReg,
						Out_RegDst			=>  MemWb_Out_RegDst,
						Out_RegWrite		=>  MemWb_Out_RegWrite,
						Out_InstrRs			=>  MemWb_Out_InstrRs,
						Out_InstrRt			=>  MemWb_Out_InstrRt,
						Out_InstrRd			=>  MemWb_Out_InstrRd,
						Out_InstrLower		=>  MemWb_Out_InstrLower,
						Out_PCPlus4 		=>  MemWb_Out_PCPlus4,
						Out_MemReadData 	=>  MemWb_Out_MemReadData,
						Out_Alu_out			=>  MemWb_Out_Alu_out,
						CLK					=>  CLK
						);

----------------------------------------------------------------
----------------------------------------------------------------
-- Processor logic
----------------------------------------------------------------
----------------------------------------------------------------

-- for Reg
ReadAddr1_Reg <= Instr(25 downto 21);
ReadAddr2_Reg <= Instr(20 downto 16);
WriteAddr_Reg <= "11111" when PcToReg = '1' else
					  Instr(15 downto 11) when RegDst = '1' else 
					  Instr(20 downto 16);

-- multiplexer to choose data-in for reg write
WriteData_Reg <=  (PC_out + 4) when PcToReg = '1' else
						Data_In when MemtoReg = '1' else 
						Instr(15 downto 0) & "0000000000000000" when InstrToReg = '1' else
						ALU_Out;

-- for ALU
ALU_InA <= ReadData1_Reg;

-- multiplexer for choice of input 2 into ALU
ALU_InB(15 downto 0) <= (others => '0') when ZeroToAlu = '1' else
								Instr(15 downto 0) when ALUSrc = '1' else 
								ReadData2_Reg(15 downto 0);
								
ALU_InB(31 downto 16) <= (others => '0') when ZeroToAlu = '1' else
								(others => (Instr(15) and SignExtend)) when ALUSrc = '1' else 
								ReadData2_Reg(31 downto 16);

-- for Mem
Addr_Data <= ALU_out;
Data_Out <= ReadData2_Reg;

-- for PC
Addr_Instr <= PC_out;
pc_increment <= PC_out + 4;
pc_temp(17 downto 2) <= Instr(15 downto 0);
pc_temp(31 downto 18) <= (others => (Instr(15) and SignExtend));
pc_temp(1 downto 0) <= "00";

PC_in <= PC_out when ALU_busy = '1' else
			ReadData1_Reg when JumpR = '1' else
			PC_increment(31 downto 28) & Instr(25 downto 0) & "00" when Jump = '1' else
			PC_temp + PC_increment when Branch = '1' and ALU_Zero = '1' else
			PC_increment;

end arch_MIPS;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
