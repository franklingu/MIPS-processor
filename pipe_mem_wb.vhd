----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:26:23 11/02/2014 
-- Design Name: 
-- Module Name:    pipe_mem_wb - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipe_mem_wb is
	Port (	PcToReg     		: in  STD_LOGIC;
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
				CLK					: in  STD_LOGIC);
end pipe_mem_wb;

architecture Behavioral of pipe_mem_wb is
begin
process(CLK)
begin
	if CLK'event and CLK = '1' then
		Out_PcToReg <= PcToReg;
		Out_MemToReg <= MemToReg;
		Out_InstrToReg <= InstrToReg;
		Out_RegWrite <= RegWrite;
		Out_PCPlus4 <= PCPlus4;
		Out_MemReadData <= MemReadData;
		Out_InstrLower <= InstrLower;
		Out_ALU_out <= ALU_out;
		Out_InstrRd <= InstrRd;
	end if;
end process;
end Behavioral;

