----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:25:30 09/10/2014 
-- Design Name: 
-- Module Name:    sll2 - Behavioral 
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

entity slln is
	 generic(N: integer);
    Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
			  ENABLE : in  STD_LOGIC;
           OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0));
end slln;

architecture arch_slln of slln is
signal temp_output: std_logic_vector(31 downto 0):= (others => '0');
begin

process(SOURCE)
begin

	for i in 31 downto N loop
		temp_output(i) <= source(i-N);
	end loop;
	temp_output(N-1 downto 0) <= (others => '0');
end process;

OUTPUT <= temp_output when ENABLE = '1' else
			 SOURCE;
end arch_slln;

