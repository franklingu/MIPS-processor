----------------------------------------------------------------------------------
-- Company: 	NUS
-- Engineer: 	Thyagesh Manikandan
-- 
-- Create Date:    15:59:41 11/02/2014 
-- Design Name: 
-- Module Name:    ExpectionUnit - exception_arch 
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

entity ExpectionUnit is
    Port ( Overflow : in  STD_LOGIC;
           DecodeExc : in  STD_LOGIC;
           Exception : out  STD_LOGIC);
end ExpectionUnit;

architecture exception_arch of ExpectionUnit is
begin

Exception <= Overflow or DecodeExc;

end exception_arch;

