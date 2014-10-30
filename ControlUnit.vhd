----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	ControlUnit
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Control Unit for the basic MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: The interface (entity) as well as implementation (architecture) can be modified
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ControlUnit is
    Port ( 	instr 		: in   STD_LOGIC_VECTOR (31 downto 0);
				ALU_Control : out  STD_LOGIC_VECTOR (7 downto 0):= "00000000";
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
				ZeroToAlu	: out	 STD_LOGIC);  -- 0 for Rt, 1 for Rd
end ControlUnit;


architecture arch_ControlUnit of ControlUnit is
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal funct : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal opcode : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal branchCode : STD_LOGIC_VECTOR (4 downto 0) := "00000";
begin

opcode <= instr(31 downto 26);
funct <= instr(5 downto 0);
branchCode <= instr(20 downto 16);
ALU_Control <= ALUOp & funct when ALUOp = "10" else
					ALUOp & opcode;

process(opcode, branchCode, funct)
begin
	ALUOp <= "00";
	Branch <= '0';
	Jump <= '0';
	JumpR <= '0';
	MemRead <= '0';
	MemWrite <= '0';
	MemtoReg <= '0';
	InstrtoReg <= '0';
	PcToReg <= '0';
	ALUSrc <= '0';
	SignExtend <= '0';
	RegWrite <= '0';
	RegDst <= '0';
	ZeroToAlu <= '0';
	
	case opcode is
	when "101011" => -- sw
		ALUOp <= "00";
		MemWrite <= '1';
		ALUSrc <= '1';
		SignExtend <= '1';
	when "100011" => -- lw
		ALUOp <= "00";
		MemRead <= '1';
		MemtoReg <= '1';
		ALUSrc <= '1';
		SignExtend <= '1';
		RegWrite <= '1';
	when "001101" => -- ori
		ALUOp <= "11";
		ALUSrc <= '1';
		RegWrite <= '1';
	when "001111" => --lui
		ALUOp <= "00";
		InstrtoReg <= '1';
		ALUSrc <= '1';
		RegWrite <= '1';
	when "000000" => -- add, sub, and, or ,nor, xor, slt, jr and etc.
		if funct = "001000" then -- jr
			ALUOp <= "00";
			JumpR <= '1';
		else -- r-type
			ALUOp <= "10";
			RegWrite <= '1';
			RegDst <= '1';
		end if;
	when "001000" => -- addi
		ALUOp <= "11";
		ALUSrc <= '1';
		SignExtend <= '1';
		RegWrite <= '1';
	when "000001" => -- bgez, bgezal
		if branchCode = "00001" then -- bgez		
			ALUOp <= "01";
			Branch <= '1';
			ZeroToAlu <= '1';
		elsif branchCode = "10001" then -- bgezal
			ALUOp <= "01";
			Branch <= '1';
			ZeroToAlu <= '1';
			RegWrite <= '1';
			PcToReg <= '1';
		end if;
	when "000100" => -- beq
		ALUOp <= "01";
		Branch <= '1';
		SignExtend <= '1';
	when "000010" => -- jump
		ALUOp <= "00";
		Jump <= '1';
	when "000011" => -- jal
		ALUOp <= "00";
		Jump <= '1';
		PcToReg <= '1';		
	when others =>
		ALUOp <= "00";
	end case;
end process;
end arch_ControlUnit;

