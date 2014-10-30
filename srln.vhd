----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:31:27 09/11/2014 
-- Design Name: 
-- Module Name:    srln - Behavioral 
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

entity srln is
	 Generic (N : integer);
    Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
           ENABLE : in  STD_LOGIC;
           OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0));
end srln;

architecture arch_srln of srln is
signal temp_output : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
begin

process(SOURCE)
begin

	for i in 0 to (31-N) loop
		temp_output(i) <= source(i+N);
	end loop;
	temp_output(31 downto 31-N+1) <= (others => '0');
	
end process;

OUTPUT <= temp_output when ENABLE = '1' else
			 SOURCE;
end arch_srln;

