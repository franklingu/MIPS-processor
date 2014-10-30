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

-------------------------------------------------------------
-- store MUL results
-------------------------------------------------------------
signal high_result : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal low_result : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";

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

-------------------------------------------------------------
-- mapping to lab2 ALU
-------------------------------------------------------------
ALU_zero <= ALU_lab2_status(0);
ALU_overflow <= ALU_lab2_status(1);
ALU_busy <= ALU_lab2_status(2);

process(CLK)
begin
	if CLK'event and CLK = '1' then
		if (ALU_Control(5 downto 0) = "011000" or ALU_Control(5 downto 0) = "011001") and ALU_lab2_status(2) = '0' then
			high_result <= ALU_lab2_result2;
			low_result <= ALU_lab2_result1;
		end if;
	end if;
end process;

process(ALU_Control,ALU_InA,ALU_InB,ALU_lab2_result1,high_result,low_result)
begin
case ALU_Control(7 downto 6) is
when "00" => -- lw, sw
	ALU_lab2_control <= "000010"; -- add
	ALU_Out <= ALU_lab2_result1;
when "01" => -- beq
	case ALU_Control(5 downto 0) is
	when "000001" => -- bgez, bgezal
		ALU_lab2_control <= "000111";
		ALU_Out <= (0 => (not ALU_lab2_result1(0)), others => '0');
	when "000100" => -- beq
		ALU_lab2_control <= "000110";
		ALU_Out <= ALU_lab2_result1;
	when others =>
		ALU_lab2_control <= "100000";
		ALU_Out <= (others => '0');
	end case;
when "10" =>
	case ALU_Control(5 downto 0) is
	when "100100" => --and
		ALU_lab2_control <= "000000";
		ALU_Out <= ALU_lab2_result1;
	when "100101" => --or
		ALU_lab2_control <= "000001";
		ALU_Out <= ALU_lab2_result1;
	when "100111" => --nor
		ALU_lab2_control <= "001100";
		ALU_Out <= ALU_lab2_result1;
	when "100000" => --add
		ALU_lab2_control <= "000010";
		ALU_Out <= ALU_lab2_result1;
	when "100010" => --sub
		ALU_lab2_control <= "000110";
		ALU_Out <= ALU_lab2_result1;
	when "101010" => --slt
		ALU_lab2_control <= "000111";
		ALU_Out <= ALU_lab2_result1;
	when "101011" => --sltu
		ALU_lab2_control <= "001110";
		ALU_Out <= ALU_lab2_result1;
	when "000000" => -- sll
		ALU_lab2_control <= "001001";
		ALU_Out <= ALU_lab2_result1;
	when "000011" => -- sra
		ALU_lab2_control <= "001101";
		ALU_Out <= ALU_lab2_result1;
	when "000010" => -- srl
		ALU_lab2_control <= "001101";
		ALU_Out <= ALU_lab2_result1;
	when "000100" => -- sllv
		ALU_lab2_control <= "001001";
		ALU_Out <= ALU_lab2_result1;
	when "011000" => -- mult
		ALU_lab2_control <= "010000";
		ALU_Out <= ALU_lab2_result1;
	when "011001" => -- multu
		ALU_lab2_control <= "010001";
		ALU_Out <= ALU_lab2_result1;
	when "010000" => -- mfhi
		ALU_lab2_control <= "100000";
		ALU_Out <= high_result;
	when "010010" => -- mflo
		ALU_lab2_control <= "100000";
		ALU_Out <= low_result;
	when others =>	
		ALU_lab2_control <= "100000";
		ALU_Out <= (others => '0');
	end case;
when "11" => -- immediate
	case ALU_Control(5 downto 0) is
		when "001000" => -- addi
			ALU_lab2_control <= "000010";
			ALU_Out <= ALU_lab2_result1;
		when "001101" => -- ori
			ALU_lab2_control <= "000001";
			ALU_Out <= ALU_lab2_result1;
		when others =>
			ALU_lab2_control <= "100000";
			ALU_Out <= (others => '0');
	end case;
when others => 
	ALU_lab2_control <= "100000";
	ALU_Out <= (others => '0');
end case;
end process;
end arch_ALU;

