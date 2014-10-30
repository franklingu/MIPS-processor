--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:16:47 09/24/2014
-- Design Name:   
-- Module Name:   C:/Users/thyagesh93/Documents/NUS/IVLEDrive/CG3207 Computer Architecture/CG3207 Resources/Assignments/Lab2/alu_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         Clk : IN  std_logic;
         Control : IN  std_logic_vector(5 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0);
         Status : OUT  std_logic_vector(2 downto 0);
         Debug : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Control : std_logic_vector(5 downto 0) := (others => '0');
   signal Operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Result1 : std_logic_vector(31 downto 0);
   signal Result2 : std_logic_vector(31 downto 0);
   signal Status : std_logic_vector(2 downto 0);
   signal Debug : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          Clk => Clk,
          Control => Control,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Result1 => Result1,
          Result2 => Result2,
          Status => Status,
          Debug => Debug
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		-- testing of sltu
		CONTROL <= "001110";
		Operand1 <= (others => '0');
		Operand2 <= (others => '0');
		-- result1 = 0

      wait for CLK_period*2;
		
		Operand1 <= (others => '1');
		Operand2 <= (others => '1');
		-- result1 = 0

      wait for CLK_period*2;
		
		Operand1 <= (30 => '1', 25 => '1', 26 => '1', others => '0');
		Operand2 <= (29 => '1', 25 => '1', 26 => '1', others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		Operand1 <= (31 => '1', 30 => '1', 28 => '1', others => '0');
		Operand2 <= (31 => '1', 30 => '1', 29 => '1', others => '0');
		-- result = 1

      wait for CLK_period*2;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (30 => '1', others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (31 => '1', others => '0');
		-- result = 1

      wait for CLK_period*2;
		
		-- testing of slt
		CONTROL <= "000111";
		Operand1 <= (others => '0');
		Operand2 <= (others => '0');
		-- result1 = 0

      wait for CLK_period*2;
		
		Operand1 <= (others => '1');
		Operand2 <= (others => '1');
		-- result1 = 0

      wait for CLK_period*2;
		
		Operand1 <= (30 => '1', 25 => '1', 26 => '1', others => '0');
		Operand2 <= (29 => '1', 25 => '1', 26 => '1', others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		Operand1 <= (29 => '1', 25 => '1', 26 => '1', others => '0');
		Operand2 <= (30 => '1', 25 => '1', 26 => '1', others => '0');
		-- result = 1

      wait for CLK_period*2;
		
		Operand1 <= (31 => '1', 30 => '1', 28 => '1', others => '0');
		Operand2 <= (31 => '1', 30 => '1', 29 => '1', others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (2 => '1', 5 => '1', 6 => '1', others => '0');
		-- result = 1

      wait for CLK_period*2;
		
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (31 => '1', others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		--sll
		Control <= "000101";
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (others => '0');
		-- result = 0

      wait for CLK_period*2;
		
		Operand1 <= (28 downto 20 => '1', others => '0');
		Operand2 <= (2 => '1', others => '0');
		-- result = 0
		
		wait for CLK_period*2;
		
		--srl
		Control <= "001101";
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (others => '0');
		-- result = Operand1

      wait for CLK_period*2;
		
		Operand1 <= (28 downto 20 => '1', others => '0');
		Operand2 <= (2 => '1', others => '0');
		-- result = 24 downto 16 is '1'
		
		wait for CLK_period*2;
		
		--sra
		Control <= "001001";
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (others => '0');
		-- result = Operand1

      wait for CLK_period*2;
		
		Operand1 <= (28 downto 20 => '1', others => '0');
		Operand2 <= (2 => '1', others => '0');
		-- result = 31 downto 28 and 24 downto 16 is '1'
		
		wait for CLK_period*2;
		
		Operand1 <= (31 downto 29 => '1', others => '0');
		Operand2 <= (2 => '1', others => '0');
		-- result = 31 downto 28 and 24 downto 16 is '1'


      wait for CLK_period*2;
		
		-- divu
		CONTROL <= "010011";
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (others => '0');

      wait for CLK_period*35;
		
		Operand1 <= (30 => '1', others => '0');
		Operand2 <= (31 => '1', others => '0');

      wait for CLK_period*35;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (31 => '1', others => '0');
	
      wait for CLK_period*35;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (30 => '1', others => '0');
		
		wait for CLK_period*35;
		
		Operand1 <= (31 downto 20 => '1', others => '0');
		Operand2 <= (20 => '1', 22 => '1', others => '0');
		
		wait for CLK_period*35;
		
		Operand1 <= (31 => '1', 25 => '1', 16 => '1', others => '0');
		Operand2 <= (0 => '1', others => '0');
		
		wait for CLK_period*35;
		
		Operand1 <= (others => '0');
		Operand2 <= (27 => '1', others => '0');
      
		wait for CLK_period*35;
		
		-- div
		Control <= "010010";
		-- 8/6 = 1, 2
		Operand1 <= (3 => '1', others => '0');
		Operand2 <= (2 => '1', 1 => '1', others => '0');
		
		wait for CLK_period*35;
		
		-- -8/6 = -1, -2
		Operand1 <= (2 downto 0 => '0', others => '1');
		Operand2 <= (2 => '1', 1 => '1', others => '0');
		
		wait for CLK_period*35;
		
		-- 8/-6 = -1, 2
		Operand1 <= (3 => '1', others => '0');
		Operand2 <= (0 => '0', 2 => '0', others => '1');
		
		wait for CLK_period*35;
		
		-- -8/-6 = 1, -2
		Operand1 <= (2 downto 0 => '0', others => '1');
		Operand2 <= (0 => '0', 2 => '0', others => '1');
		
		wait for CLK_period*35;
		
		-- mult
		Control <= "010000";
		Operand1 <= (1 => '1', others => '0');
		Operand2 <= (2 => '1', 1 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (1 => '1', others => '0');
		Operand2 <= (2 => '1', 0 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (31 => '0', others => '1');
		Operand2 <= (2 => '1', 1 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (1 => '0', 0 => '0', others => '1');
		Operand2 <= (0 => '0', others => '1');
		
		wait for CLK_period*19;
		
		Operand1 <= (2 => '1', others => '0');
		Operand2 <= (0 => '0', others => '1');
		
		wait for CLK_period*19;
		
		-- multu
		Control <= "010001";
		Operand1 <= (1 => '0', 0 => '0', others => '1');
		Operand2 <= (0 => '0', others => '1');
		
		wait for CLK_period*19;
		
		Operand1 <= (1 => '1', 0 => '1', others => '0');
		Operand2 <= (2 => '1', 1 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (1 => '1', 0 => '1', others => '0');
		Operand2 <= (2 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (31 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Operand1 <= (31 => '1', others => '0');
		Operand2 <= (31 => '1', 29 => '1', others => '0');
		
		wait for CLK_period*19;
		
		Control <= "100000";
		wait;
   end process;

END;
