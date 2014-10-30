----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	ALU
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Simple ALU for the basic MIPS processor
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

entity ALU is
    Port ( 	CLK			: in  STD_LOGIC;
				ALU_InA 		: in  STD_LOGIC_VECTOR (31 downto 0);				
				ALU_InB 		: in  STD_LOGIC_VECTOR (31 downto 0);
				ALU_Out 		: out STD_LOGIC_VECTOR (31 downto 0);
				ALU_Control	: in  STD_LOGIC_VECTOR (7 downto 0);
				ALU_zero		: out STD_LOGIC;
				ALU_overflow: out STD_LOGIC;
				ALU_busy		: out STD_LOGIC);
end ALU;


architecture arch_ALU of ALU is

-------------------------------------------------------------
-- ALU designed in lab 2
-------------------------------------------------------------
component ALU_lab2 is
generic (width : integer);
	Port(
		Clk			: in	STD_LOGIC;
		Control		: in	STD_LOGIC_VECTOR (5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Status		: out	STD_LOGIC_VECTOR (2 downto 0) -- busy (multicycle only), overflow (add and sub), zero (sub)
	);
end component;

-------------------------------------------------------------
-- ALU designed in lab 2
-------------------------------------------------------------
signal ALU_lab2_control : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal ALU_lab2_result1 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal ALU_lab2_result2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal ALU_lab2_status : STD_LOGIC_VECTOR (2 downto 0) := "000";

begin
-------------------------------------------------------------
-- port map
-------------------------------------------------------------
ALU_lab2_mapping : ALU_lab2 generic map (width => 32) port map (Clk => CLK,
																					 Control => ALU_lab2_control,
																					 Operand1 => ALU_InA,
																					 Operand2 => ALU_InB,
																					 Result1 => ALU_lab2_result1,
																					 Result2 => ALU_lab2_result2,
																					 Status => ALU_lab2_status);
process(ALU_Control,ALU_InA,ALU_InB)
variable AplusB 	: STD_LOGIC_VECTOR (31 downto 0);
variable AminusB 	: STD_LOGIC_VECTOR (31 downto 0);
variable suboverflow: STD_LOGIC;
variable AorB 		: STD_LOGIC_VECTOR (31 downto 0);
begin

AplusB := ALU_InA + ALU_InB;
AminusB := ALU_InA - ALU_InB;
suboverflow := ( ALU_InA(31) xor  ALU_InB(31) )  and ( ALU_InB(31) xnor AminusB(31) );
AorB := ALU_InA or ALU_InB;

ALU_Out <= (others=>'0'); -- default output
ALU_zero <= '0'; -- default. changed only by BEQ

case ALU_Control(7 downto 6) is
when "00" => -- lw, sw
	ALU_Out <= AplusB;
when "01" => -- beq
	case ALU_Control(5 downto 0) is
	when "000001" => -- bgez
	-- when "000001" => -- bgezal
	when "000100" => -- beq
		if AminusB = x"00000000" then
			ALU_zero <= '1';
		end if;
	when others =>
		null;
	end case;
when "10" =>
	case ALU_Control(5 downto 0) is
	when "100000" => --add
		ALU_Out <= AplusB;
	when "001000" => --addi
		null;
	when "100010" => --sub
		ALU_Out <= AminusB;
	when "100100" => --and
		ALU_Out <= ALU_InA and ALU_InB;
	when "100101" => --or
		ALU_Out <= AorB;
	when "100111" => --nor
		ALU_Out <= not(AorB);
	when "101010" => --slt
		ALU_Out(0) <= AminusB(31) xor suboverflow;
	when "101011" => --sltu
		-- to be done
	when "011000" => -- mult
	when "011001" => -- multu
	when "010000" => -- mfhi
	when "010010" => -- mflo
	when "000000" => -- sll
	when "000100" => -- sllv
	when "000011" => -- sra
	when "000010" => -- srl
	when others =>	
		null;
	end case;
when "11" => -- ori
	ALU_Out <= AorB;
when others => null;
end case;
end process;
end arch_ALU;

