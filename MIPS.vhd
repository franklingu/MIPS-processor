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
-- Program Counter
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
-- PC Signals
----------------------------------------------------------------
	signal	PC_in 		:  STD_LOGIC_VECTOR 	(31 downto 0);
	signal	PC_out 		:  STD_LOGIC_VECTOR 	(31 downto 0);
	signal 	PC_increment: 	STD_LOGIC_VECTOR	(31 downto 0) := x"00000000";
	signal   PC_temp		: 	STD_LOGIC_VECTOR	(31 downto 0) := x"00000000";

----------------------------------------------------------------
-- ALU Signals
----------------------------------------------------------------
	signal	ALU_InA 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_InB 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Out 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Control	:  STD_LOGIC_VECTOR (7 downto 0);
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
 	signal	ReadAddr1_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadAddr2_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadData1_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData2_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	WriteAddr_Reg	:  STD_LOGIC_VECTOR (4 downto 0); 
	signal	WriteData_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);

----------------------------------------------------------------
-- Other Signals
----------------------------------------------------------------
	--<any other signals used goes here>
 

----------------------------------------------------------------	
----------------------------------------------------------------
-- <MIPS architecture>
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
-- Processor logic
----------------------------------------------------------------

-- for Reg
ReadAddr1_Reg <= Instr(25 downto 21);
ReadAddr2_Reg <= Instr(20 downto 16);
WriteAddr_Reg <= Instr(15 downto 11) when RegDst = '1' else Instr(20 downto 16);

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
