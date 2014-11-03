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

entity ExceptionUnit is
    Port ( CLK				: in STD_LOGIC;
			  ExcCauseRead : in STD_LOGIC;
			  ExcPcRead    : in STD_LOGIC;
			  Overflow		: in  STD_LOGIC;
           DecodeExc 	: in  STD_LOGIC;
			  MemAddrExc	: in  STD_LOGIC;
           Exception 	: out  STD_LOGIC;
			  Cause 			: out STD_LOGIC_VECTOR(2 downto 0);
			  ExcPcIn		: in STD_LOGIC_VECTOR(31 downto 0);
			  ExcPcOut		: out STD_LOGIC_VECTOR(31 downto 0));
end ExceptionUnit;

architecture exception_arch of ExceptionUnit is
signal PrevCause : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal PrevPC : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
begin

process(ExcCauseRead, ExcPcRead, PrevCause, PrevPC)
begin
	if ExcCauseRead = '1' then
		Cause <= PrevCause when 
	else
		Cause <= "000";
	end if;
	
	if ExcPcRead = '1' then
		ExcPcOut <= PrevPC;
	else
		ExcPcOut <= (others => '0');
	end if;
end process;

process(CLK)
begin
	if CLK'event and CLK = '1' then
		if (Overflow = '1' or DecodeExc = '1' or MemAddrExc = '1') then
			PrevCause <= Overflow & DecodeExc & MemAddrExc;
		end if;
		if (Overflow = '1' or DecodeExc = '1' or MemAddrExc = '1') then
			PrevPC <= ExcPcIn;
		end if;
	end if;
end process;
			 
Exception <= Overflow or DecodeExc or MemAddrExc;

end exception_arch;

