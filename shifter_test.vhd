--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:24:31 09/17/2014
-- Design Name:   
-- Module Name:   C:/Users/a0100124/thyagsh_Lab2/shifter_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shifter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY shifter_test IS
END shifter_test;
 
ARCHITECTURE behavior OF shifter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shifter
    PORT(
         SOURCE : IN  std_logic_vector(31 downto 0);
         SHIFT_AMT : IN  std_logic_vector(4 downto 0);
         DIRECTION : IN  std_logic;
         SHIFT_TYPE : IN  std_logic;
         OUTPUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SOURCE : std_logic_vector(31 downto 0) := (others => '0');
   signal SHIFT_AMT : std_logic_vector(4 downto 0) := (others => '0');
   signal DIRECTION : std_logic := '0';
   signal SHIFT_TYPE : std_logic := '0';

 	--Outputs
   signal OUTPUT : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shifter PORT MAP (
          SOURCE => SOURCE,
          SHIFT_AMT => SHIFT_AMT,
          DIRECTION => DIRECTION,
          SHIFT_TYPE => SHIFT_TYPE,
          OUTPUT => OUTPUT
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		SOURCE <= (12 => '0', 15 => '0', 14 => '0', others => '1');
		SHIFT_AMT <= "00100";
		DIRECTION <= '0';
		SHIFT_TYPE <= '0';
		
		wait for 100 ns;
		
		SHIFT_AMT <= "00011";
		DIRECTION <= '1';
		SHIFT_TYPE <= '0';
		
		wait for 100 ns;
		
		SHIFT_AMT <= "00100";
		DIRECTION <= '1';
		SHIFT_TYPE <= '1';
		
		wait for 100 ns;
		
		SOURCE <= (1 => '1', 2 => '1', 15 => '1', 16 => '1', others => '0');
		SHIFT_AMT <= "00100";
		DIRECTION <= '0';
		SHIFT_TYPE <= '1';
		
		wait for 100 ns;
		
		SHIFT_AMT <= "00110";
		DIRECTION <= '1';
		SHIFT_TYPE <= '0';
		
		wait for 100 ns;
		
		SHIFT_AMT <= "01000";
		DIRECTION <= '1';
		SHIFT_TYPE <= '1';
		
		wait for 100 ns;
		
		SHIFT_AMT <= "00000";
		DIRECTION <= '0'; 
		SHIFT_TYPE <= '1';
		
      wait;
   end process;

END;
