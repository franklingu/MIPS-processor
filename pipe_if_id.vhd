----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:44 11/02/2014 
-- Design Name: 
-- Module Name:    pipe_if_id - Behavioral 
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

entity pipe_if_id is
    Port ( Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           Pcplus4 : in  STD_LOGIC(31 downto 0);
           Instr_out : out  STD_LOGIC(31 downto 0);
           Pc_out : out  STD_LOGIC(31 downto 0);
           CLK : in  STD_LOGIC);
end pipe_if_id;

architecture Behavioral of pipe_if_id is

begin
process(CLK)
begin
	if CLK'event and CLK = '1' then
		Instr_out <= Instruction;
		Pc_out <= Pcplus4;
	end if;
end process;
end Behavioral;

