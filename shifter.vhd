----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:40:49 09/11/2014 
-- Design Name: 
-- Module Name:    shifter - Behavioral 
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

entity shifter is
    Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
           SHIFT_AMT : in  STD_LOGIC_VECTOR (4 downto 0);
			  DIRECTION : in STD_LOGIC; -- left is '0'
			  SHIFT_TYPE : in STD_LOGIC; -- logical shift is '1'
           SHIFTER_RESULT : out  STD_LOGIC_VECTOR (31 downto 0));
end shifter;

architecture arch_shifter of shifter is
component slln is
	Generic(N : integer);
	Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
			 ENABLE : in  STD_LOGIC;
          OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component srln is
	Generic (N : integer);
   Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
          ENABLE : in  STD_LOGIC;
          OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component sran is
	Generic (N : integer);
    Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
           ENABLE : in  STD_LOGIC;
           OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal output_sll_1 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sll_2 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sll_4 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sll_8 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sll : STD_LOGIC_VECTOR (31 downto 0);

signal output_srl_1 : STD_LOGIC_VECTOR (31 downto 0);
signal output_srl_2 : STD_LOGIC_VECTOR (31 downto 0);
signal output_srl_4 : STD_LOGIC_VECTOR (31 downto 0);
signal output_srl_8 : STD_LOGIC_VECTOR (31 downto 0);
signal output_srl : STD_LOGIC_VECTOR (31 downto 0);

signal output_sra_1 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sra_2 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sra_4 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sra_8 : STD_LOGIC_VECTOR (31 downto 0);
signal output_sra : STD_LOGIC_VECTOR (31 downto 0);

begin

sll_1 :  slln generic map(N => 1) port map(SOURCE, SHIFT_AMT(0), output_sll_1);
sll_2 :  slln generic map(N => 2) port map(output_sll_1, SHIFT_AMT(1), output_sll_2);
sll_4 :  slln generic map(N => 4) port map(output_sll_2, SHIFT_AMT(2), output_sll_4);
sll_8 :  slln generic map(N => 8) port map(output_sll_4, SHIFT_AMT(3), output_sll_8);
sll_16 : slln generic map(N => 16) port map(output_sll_8, SHIFT_AMT(4), output_sll);

srl_1 :  srln generic map(N => 1) port map(SOURCE, SHIFT_AMT(0), output_srl_1);
srl_2 :  srln generic map(N => 2) port map(output_srl_1, SHIFT_AMT(1), output_srl_2);
srl_4 :  srln generic map(N => 4) port map(output_srl_2, SHIFT_AMT(2), output_srl_4);
srl_8 :  srln generic map(N => 8) port map(output_srl_4, SHIFT_AMT(3), output_srl_8);
srl_16 : srln generic map(N => 16) port map(output_srl_8, SHIFT_AMT(4), output_srl);

sra_1 :  sran generic map(N => 1) port map(SOURCE, SHIFT_AMT(0), output_sra_1);
sra_2 :  sran generic map(N => 2) port map(output_sra_1, SHIFT_AMT(1), output_sra_2);
sra_4 :  sran generic map(N => 4) port map(output_sra_2, SHIFT_AMT(2), output_sra_4);
sra_8 :  sran generic map(N => 8) port map(output_sra_4, SHIFT_AMT(3), output_sra_8);
sra_16 : sran generic map(N => 16) port map(output_sra_8, SHIFT_AMT(4), output_sra);

SHIFTER_RESULT <= output_sll when DIRECTION = '0' else
						output_srl when SHIFT_TYPE = '1' else
						output_sra;

end arch_shifter;

