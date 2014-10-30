--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:31:56 09/11/2014
-- Design Name:   
-- Module Name:   D:/projects/VHDL/ALU/AddSubTest.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AddSub
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
 
ENTITY AddSubTest IS
END AddSubTest;
 
ARCHITECTURE behavior OF AddSubTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AddSub
	 generic (width : integer);
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         B_INV : IN  std_logic;
         SUM : OUT  std_logic_vector(31 downto 0);
         CARRY_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal B_INV : std_logic := '0';

 	--Outputs
   signal SUM : std_logic_vector(31 downto 0);
   signal CARRY_OUT : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AddSub generic map (width =>  32) PORT MAP (
          A => A,
          B => B,
          B_INV => B_INV,
          SUM => SUM,
          CARRY_OUT => CARRY_OUT
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		-- test add
      A <= X"00000004";
		B <= X"00000004";
		wait for 20 ns;
		
		A <= X"0000000C";
		B <= X"00000004";
		wait for 20 ns;
		
		A <= X"0000000C";
		B <= X"0000000C";
		wait for 20 ns;
		
		A <= X"0000001C";
		B <= X"0000000C";
		wait for 20 ns;
		
		A <= X"0000000C";
		B <= X"0000100C";
		wait for 20 ns;
		
		A <= X"A000100C";
		B <= X"A000F00C";
		wait for 20 ns;
		
		-- test sub
		B_INV <= '1';
		A <= X"0000000C";
		B <= X"0000000C";
		wait for 20 ns;
		
		B_INV <= '1';
		A <= X"01111108";
		B <= X"0011111C";
		wait for 20 ns;
		
		B_INV <= '1';
		A <= X"0000000C";
		B <= X"00000008";
		wait for 20 ns;
		
      wait;
   end process;

END;
