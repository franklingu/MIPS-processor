--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:42:49 09/10/2014
-- Design Name:   
-- Module Name:   C:/Users/thyagesh93/Documents/NUS/IVLEDrive/CG3207 Computer Architecture/CG3207 Resources/Assignments/Lab2/slln_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: slln
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
 
ENTITY slln_test IS
END slln_test;
 
ARCHITECTURE behavior OF slln_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT slln
	 GENERIC (N : integer);
    PORT(
         SOURCE : IN  std_logic_vector(31 downto 0);
         OUTPUT : OUT  std_logic_vector(31 downto 0);
         ENABLE : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SOURCE : std_logic_vector(31 downto 0) := (others => '0');
   signal ENABLE : std_logic := '0';

 	--Outputs
   signal OUTPUT : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: slln 
		  GENERIC MAP (N => 4)
		  PORT MAP (
          SOURCE => SOURCE,
          OUTPUT => OUTPUT,
          ENABLE => ENABLE
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		ENABLE <= '1';
		SOURCE <= (others => '1');
		
		wait for 100 ns;	
		
		ENABLE <= '1';
		SOURCE <= (10 => '0', others => '1');
		
		wait for 100 ns;	
		
		ENABLE <= '1';
		SOURCE <= (11 => '0', others => '1');
		
		wait for 100 ns;	
		
		ENABLE <= '1';
		SOURCE <= (12 => '0', others => '1');
		
		wait for 100 ns;	
		
		ENABLE <= '1';
		SOURCE <= (13 => '0', others => '1');
		
      wait;
   end process;

END;
