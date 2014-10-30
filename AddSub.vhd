----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:02:23 09/11/2014 
-- Design Name: 
-- Module Name:    AddSub - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AddSub is
generic (width : integer := 32);
    Port ( A : in  STD_LOGIC_VECTOR(width-1 downto 0);
           B : in  STD_LOGIC_VECTOR(width-1 downto 0);
           B_INV : in  STD_LOGIC;
           SUM : out  STD_LOGIC_VECTOR(width-1 downto 0);
           CARRY_OUT : out  STD_LOGIC);
end AddSub;

architecture AddSubArch of AddSub is
signal S_wider : std_logic_vector(width downto 0);
signal INV_VEC : std_logic_vector(width-1 downto 0);
begin
   INV_VEC <= (others => B_INV);
	S_wider <= ('0' & A) + ('0' & (B xor INV_VEC)) + B_INV;
	SUM <= S_wider(width-1 downto 0);
	CARRY_OUT <= S_wider(width);
end AddSubArch;

