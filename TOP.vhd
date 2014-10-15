----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	TOP (MIPS Wrapper)
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Top level module - wrapper for MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: See the notes below. The interface (entity) as well as implementation (architecture) can be modified
--
----------------------------------------------------------------------------------


----------------------------------------------------------------
-- NOTE : 
----------------------------------------------------------------

-- Instruction and data memory are WORD addressable (NOT byte addressable). 
-- Each can store 256 WORDs. 
-- Address Range of Instruction Memory is 0x00400000 to 0x004003FC (word addressable - only multiples of 4 are valid). This will cause warnings about 2 unused bits, but that's ok.
-- Address Range of Data Memory is 0x10010000 to 0x100103FC (word addressable - only multiples of 4 are valid).
-- LED <7> downto <0> is mapped to the word address 0x10020000. Only the least significant 8 bits written to this location are used.
-- DIP switches are mapped to the word address 0x10030000. Only the least significant 16 bits read from this location are valid.
-- You can change the above addresses to some other convenient value for simulation, and change it to their original values for synthesis / FPGA testing.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

----------------------------------------------------------------
-- TOP level module interface
----------------------------------------------------------------

entity TOP is
		Port (
			DIP 				: in  STD_LOGIC_VECTOR (15 downto 0);  -- DIP switch inputs. Not debounced.
			LED 				: out  STD_LOGIC_VECTOR (15 downto 0); -- LEDs
			-- <15> showing the divided clock, 
			-- <14> downto <8> showing Addr_Instr(22) & Addr_Instr(7 downto 2), 
			-- <7> downto <0> mapped to the address 0x10020000.
			RESET				: in  STD_LOGIC; 	-- Reset -> BTNC (Centre push button)
			CLK_undiv		: in  STD_LOGIC); -- 100MHz clock. Converted to a lower frequency using CLK_DIV_PROCESS before use.
end TOP;


architecture arch_TOP of TOP is

----------------------------------------------------------------
-- Constants
----------------------------------------------------------------
constant CLK_DIV_BITS	: integer := 25; --25 for a clock of the order of 1Hz
constant N_LEDs			: integer := 8;
constant N_DIPs			: integer := 16;

----------------------------------------------------------------
-- MIPS component declaration
----------------------------------------------------------------
component mips is
    Port ( 	
			Addr_Instr 		: out STD_LOGIC_VECTOR (31 downto 0); 	-- Input to instruction memory (normally comes from the output of PC)
			Instr 			: in STD_LOGIC_VECTOR (31 downto 0);  	-- Output from the instruction memory
			Addr_Data		: out STD_LOGIC_VECTOR (31 downto 0); 	-- Address sent to data memory / memory-mapped peripherals
			Data_In			: in STD_LOGIC_VECTOR (31 downto 0);  	-- Data read from data memory / memory-mapped peripherals
			Data_Out			: out  STD_LOGIC_VECTOR (31 downto 0); -- Data to be written to data memory / memory-mapped peripherals 
			MemRead 			: out STD_LOGIC; 	-- MemRead signal to data memory / memory-mapped peripherals 
			MemWrite 		: out STD_LOGIC; 	-- MemWrite signal to data memory / memory-mapped peripherals 
			RESET				: in STD_LOGIC; 	-- Reset signal for the processor. Should reset ALU and PC. Resetting general purpose registers is not essential (though it could be done).
			CLK				: in STD_LOGIC 	-- Divided (lower frequnency) clock for the processor.
			);
end component mips;

----------------------------------------------------------------
-- MIPS signals
----------------------------------------------------------------
signal Addr_Instr 	: STD_LOGIC_VECTOR (31 downto 0);
signal Instr 			: STD_LOGIC_VECTOR (31 downto 0);
signal Data_In			: STD_LOGIC_VECTOR (31 downto 0);
signal Addr_Data		: STD_LOGIC_VECTOR (31 downto 0);
signal Data_Out		: STD_LOGIC_VECTOR (31 downto 0);
signal MemRead 		: STD_LOGIC; 
signal MemWrite 		: STD_LOGIC; 

----------------------------------------------------------------
-- Others signals
----------------------------------------------------------------
signal dec_DATA_MEM, dec_LED, dec_DIP : std_logic;  -- data memory address decoding
signal DIP_debounced : STD_LOGIC_VECTOR (15 downto 0):=(others=>'0'); -- DIP switch debouncing
signal CLK : std_logic; --divided (low freq) clock

----------------------------------------------------------------
-- Memory type declaration
----------------------------------------------------------------
type MEM_256x32 is array (0 to 255) of std_logic_vector (31 downto 0); -- 256 words

----------------------------------------------------------------
-- Instruction Memory
----------------------------------------------------------------
constant INSTR_MEM : MEM_256x32 := (
			x"3c090000", -- start : lui $t1, 0x0000
			x"35290001", -- 			ori $t1, 0x0001 # constant 1
			x"3c081003", -- 			lui $t0, 0x1003 # DIP pointer, for VHDL
			x"8d0c0000", --			lw  $t4, 0($t0) 
			x"3c081002", --			lui $t0, 0x1002 # LED pointer, for VHDL
			x"3c0a0000", -- loop: 	lui $t2, 0x0000
			x"354a0004", -- 			ori $t2, 0x0004 # delay counter (n). Change according to the clock
			x"01495022", -- delay: 	sub $t2, $t2, $t1 
			x"0149582a", -- 			slt $t3, $t2, $t1
			x"1160fffd", -- 			beq $t3, $zero, delay
			x"ad0c0000", -- 			sw  $t4, 0($t0)	
			x"01806027", --			nor $t4, $t4, $zero
			x"08100005", -- 			j loop # infinite loop; n*3 (delay instructions) + 5 (non-delay instructions).
			others=> x"00000000");

-- The Blinky program reads the DIP switches in the begining. Let the value read be VAL
-- It will then keep alternating between VAL(7 downto 0) , not(VAL(7 downto 0)), 
-- essentially blinking LED(7 downto 0) according to the initial pattern read from the DIP switches 	

----------------------------------------------------------------
-- Data Memory
----------------------------------------------------------------
signal DATA_MEM : MEM_256x32 := (others=> x"00000000");


----------------------------------------------------------------	
----------------------------------------------------------------
-- <Wrapper architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
		
begin

----------------------------------------------------------------
-- MIPS port map
----------------------------------------------------------------
MIPS1 : MIPS port map ( 
			Addr_Instr 		=>  Addr_Instr,
			Instr 			=>  Instr, 		
			Data_In			=>  Data_In,	
			Addr_Data		=>  Addr_Data,		
			Data_Out			=>  Data_Out,	
			MemRead 			=>  MemRead,		
			MemWrite 		=>  MemWrite,
			RESET				=>	 RESET,
			CLK				=>  CLK				
			);

----------------------------------------------------------------
-- Data memory address decoding
----------------------------------------------------------------
dec_DATA_MEM <= '1' 	when Addr_Data>=x"10010000" and Addr_Data<=x"100103FC" else '0'; --assuming 256 word memory
dec_LED 		<= '1'	when Addr_Data=x"10020000" else '0';
dec_DIP 		<= '1' 	when Addr_Data=x"10030000" else '0';

----------------------------------------------------------------
-- Data memory read
----------------------------------------------------------------
Data_In 	<= (N_DIPs-1 downto 0 => '0') & DIP							when MemRead = '1' and dec_DIP = '1' 
				else DATA_MEM(conv_integer(Addr_Data(9 downto 2)))	when MemRead = '1' and dec_DATA_MEM = '1'
				else (others=>'0');
				
----------------------------------------------------------------
-- Instruction memory read
----------------------------------------------------------------
Instr <= INSTR_MEM(conv_integer(Addr_Instr(9 downto 2))) 
			when ( Addr_Instr(31 downto 10) & Addr_Instr(1 downto 0) )=x"004000" -- To check if address is in the valid range. Also helps minimize warnings
			else x"00000000";

----------------------------------------------------------------
-- Debug LEDs
----------------------------------------------------------------			
LED(14 downto 8) <= Addr_Instr(22) & Addr_Instr(7 downto 2); -- debug showing PC
LED(15) <= CLK; -- debug showing clock

----------------------------------------------------------------
-- Data Memory-mapped LED write
----------------------------------------------------------------
write_LED: process (CLK)
begin
	if (CLK'event and CLK = '1') then
		if (MemWrite = '1') and  (dec_LED = '1') then
             LED(N_LEDs-1 downto 0) <= Data_Out(N_LEDs-1 downto 0);
		end if;
	end if;
end process;

----------------------------------------------------------------
-- Data Memory write
----------------------------------------------------------------
write_DATA_MEM: process (CLK)
begin
    if (CLK'event and CLK = '1') then
        if (MemWrite = '1' and dec_DATA_MEM = '1') then
            DATA_MEM(conv_integer(Addr_Data(9 downto 2))) <= Data_Out;
        end if;
    end if;
end process;

----------------------------------------------------------------
-- Clock divider
----------------------------------------------------------------
CLK_DIV_PROCESS : process(CLK_undiv)
variable clk_counter : std_logic_vector(CLK_DIV_BITS downto 0) := (others => '0');
begin
	if CLK_undiv'event and CLK_undiv = '1' then
		clk_counter := clk_counter+1;
		CLK <= clk_counter(CLK_DIV_BITS);
	end if;
end process;

end arch_TOP;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </Wrapper architecture>
----------------------------------------------------------------
----------------------------------------------------------------	



----------------------------------------------------------------
-- Blinky Program
----------------------------------------------------------------
--ori $t1, 0x0001 # constant 1
--#lui $t0, 0x1001 # DIP pointer, for MIPS simulation
--lui $t0, 0x1003 # DIP pointer, for VHDL
--lw  $t4, 0($t0)
--lui $t0, 0x1002 # LED pointer, for VHDL
--loop:
--lui $t2, 0x0000
--ori $t2, 0x0004 # delay counter (n). Change according to the clock
--delay:
--sub $t2, $t2, $t1 
--slt $t3, $t2, $t1
--beq $t3, $zero, delay
--sw  $t4, 0($t0)
--nor $t4, $t4, $zero
--j loop
--# n*3 (delay instructions) + 5 (non-delay instructions).