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
			RESET				: in  STD_LOGIC; 	-- Reset -> BTNC (Centre push button)
			CLK_undiv		: in  STD_LOGIC); -- 100MHz clock. Converted to a lower frequency using CLK_DIV_PROCESS before use.
end TOP;


architecture arch_TOP of TOP is

----------------------------------------------------------------
-- Constants
----------------------------------------------------------------
constant CLK_DIV_BITS	: integer := 23; --25 for a clock of the order of 1Hz
constant N_LEDs			: integer := 12;
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
			x"3c101002",  -- start:  lui $s0, 0x1002  # address to LED
			x"3c111003",  --         lui $s1, 0x1003  # address of DIP switch
			x"3c140000",  --         lui $s4, 0x0000
			x"36940001",  --         ori $s4, 0x0001  # s4 is 1
			x"3c080000",  --         lui $t0, 0x0000
			x"8e290000",  -- loop:   lw  $t1, 0($s1)  # read the value of DIP switch
			x"ae080000",  --         sw  $t0, 0($s0)
			x"3c080000",  --         lui $t0, 0x0000
			x"3c0a0000",  --         lui $t2, 0x0000
			x"3c130000",  --         lui $s3, 0x0000
			x"3673000f",  --         ori $s3, 0x000f  # s3 is 15
			x"01345024",  -- count:  and $t2, $t1, $s4
			x"00094842",  --         srl $t1, $t1, 0x0001
			x"01484020",  --         add $t0, $t2, $t0
			x"02749822",  --         sub $s3, $s3, $s4
			x"0661fffb",  --         bgez $s3, count
			x"08100005",  --         j   loop
			others=> x"00000000");	

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
LED(14 downto 12) <= Addr_Instr(22) & Addr_Instr(3 downto 2); -- debug showing PC
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
-- programs for testing, all simulation passed. only the first
-- one is loaded on board
----------------------------------------------------------------

-- fib.hex --
--x"3c081001",  -- start:     lui $t0, 0x1001
--x"35080000",  --    ori $t0, 0x0000     #address for data memory
--x"3c090000",  --    lui $t1, 0x0000
--x"35290001",  --    ori $t1, 0x0001     # t1 = 1
--x"ad090000",  --    sw  $t1, 0($t0)
--x"31290000",  --    andi $t1, 0x0000    # forwarding to ex stage, not from mem stage
--x"8d0a0000",  --    lw  $t2, 0($t0)     # t2 = 1
--x"ad0a0000",  --    sw  $t2, 0($t0)
--x"8d0b0000",  --    lw  $t3, 0($t0)     # t3 = 1
--x"016a5822",  --    sub $t3, $t3, $t2   # t3 = 0, load use hazard
--x"3c0c0000",  --    lui $t4, 0x0000
--x"3c0d0000",  --    lui $t5, 0x0000
--x"35ad01ff",  --    ori $t5, 0x01ff     # at most "111111111"
--x"3c0e0000",  --    lui $t6, 0x0000
--x"21ce0003",  --    addi $t6, $t6, 0x0003  # t6 = 3
--x"3c110000",  --    lui $s1, 0x0000
--x"36310001",  --    ori $s1, 0x0001
--x"3c081002",  --    lui $t0, 0x1002
--x"0511000f",  --    bgezal $t0, return
--x"0c10001d",  -- loop:  jal fib
--x"218c0001",  --    addi $t4, $t4, 0x0001
--x"018e0018",  --    mult $t4, $t6
--x"00006012",  --    mflo $t4
--x"01916022",  -- delay: sub $t4, $t4, $s1
--x"0581fffe",  --    bgez $t4, delay    # control stall, control hazard
--x"218c0001",  --    addi $t4, $t4, 0x0001
--x"01a9782a",  --    slt $t7, $t5, $t1
--x"11e0fff7",  --    beq $t7, $zero, loop
--x"08100000",  --    j start
--x"ad090000",  -- fib:   sw  $t1, 0($t0)
--x"01405820",  --    add $t3, $t2, $zero
--x"01495020",  --    add $t2, $t2, $t1
--x"01604820",  --    add $t1, $t3, $zero
--x"03e00008",  --        jr $31
--x"03e00008",  -- return: jr $31
-- end of fib.asm--

-- fib with sll --
--x"3c081001",  -- start:     lui $t0, 0x1001
--x"35080000",  --    ori $t0, 0x0000     #address for data memory
--x"3c090000",  --    lui $t1, 0x0000
--x"35290001",  --    ori $t1, 0x0001     # t1 = 1
--x"00094940",  --    sll $t1, $t1, 5
--x"00094942",  --    srl $t1, $t1, 5
--x"ad090000",  --    sw  $t1, 0($t0)
--x"31290000",  --    andi $t1, 0x0000    # forwarding to ex stage, not from mem stage
--x"8d0a0000",  --    lw  $t2, 0($t0)     # t2 = 1
--x"ad0a0000",  --    sw  $t2, 0($t0)
--x"8d0b0000",  --    lw  $t3, 0($t0)     # t3 = 1
--x"016a5822",  --    sub $t3, $t3, $t2   # t3 = 0, load use hazard
--x"3c0c0000",  --    lui $t4, 0x0000
--x"3c0d0000",  --    lui $t5, 0x0000
--x"35ad01ff",  --    ori $t5, 0x01ff     # at most "111111111"
--x"3c0e0000",  --    lui $t6, 0x0000
--x"21ce0003",  --    addi $t6, $t6, 0x0003  # t6 = 3
--x"3c110000",  --    lui $s1, 0x0000
--x"36310001",  --    ori $s1, 0x0001
--x"3c081002",  --    lui $t0, 0x1002
--x"0511000f",  --    bgezal $t0, return
--x"0c10001f",  -- loop:  jal fib
--x"218c0001",  --    addi $t4, $t4, 0x0001
--x"018e0018",  --    mult $t4, $t6
--x"00006012",  --    mflo $t4
--x"01916022",  -- delay: sub $t4, $t4, $s1
--x"0581fffe",  --    bgez $t4, delay    # control stall, control hazard
--x"218c0001",  --    addi $t4, $t4, 0x0001
--x"01a9782a",  --    slt $t7, $t5, $t1
--x"11e0fff7",  --    beq $t7, $zero, loop
--x"08100000",  --    j start
--x"ad090000",  -- fib:   sw  $t1, 0($t0)
--x"01405820",  --    add $t3, $t2, $zero
--x"01495020",  --    add $t2, $t2, $t1
--x"01604820",  --    add $t1, $t3, $zero
--x"03e00008",  --        jr $31
--x"03e00008",  -- return: jr $31
-- end of fib_with_sll_.asm

-- test jr --
--x"0c100001",  -- start: jal ra1
--x"0c100002",  -- ra1:   jal ra2 
--x"0c100003",  -- ra2:   jal ra3
--x"0c100004",  -- ra3:   jal ra4
--x"0c100005",  -- ra4:   jal ra5
--x"0c100006",  -- ra5:   jal mod
--x"35290001",  -- mod:   ori $t1, 0x0001
--x"354a0004",  --    ori $t2, 0x0004
--x"012a0018",  --    mult $t1, $t2
--x"00005012",  --    mflo $t2
--x"03eaf822",  --    sub $31, $31, $t2
--x"03eaf822",  --    sub $31, $31, $t2
--x"03eaf822",  --    sub $31, $31, $t2
--x"23ff0004",  --    addi $31, $31, 0x0004
--x"03e00008",  --    jr $31
-- end of test jr --

-- r and sw, lw --
--x"00000000",  -- start:  nop
--x"3c081001",  --    lui $t0, 0x1001
--x"35080000",  --         ori $t0, 0x0000  # t0 = 0x10010000
--x"210e0001",  --         addi $t6, $t0, 0x0001  # t6 = 0x10010001
--x"ad0e0000",  --         sw  $t6, 0($t0)
--x"8d090000",  --         lw  $t1, 0($t0)
--x"3c090000",  --         lui $t1, 0x0000
--x"35290001",  --         ori $t1, 0x0001  # t1 = 1
--x"21290001",  --         addi $t1, $t1, 0x0001
--x"3c0a0000",  --         lui $t2, 0x0000
--x"354a0002",  --         ori $t2, 0x0002  # t2 = 2
--x"3c0b0000",  --         lui $t3, 0x0000
--x"356b0003",  --         ori $t3, 0x0003  # t3 = 3
--x"012a6020",  --         add $t4, $t1, $t2  # t4 = 4
--x"018a6822",  --         sub $t5, $t4, $t2  # t5 = 2
--x"014b0018",  --         mult $t2, $t3
--x"00005010",  --         mfhi $t2
--x"00005812",  --         mflo $t3
--x"354a0004",  --         ori $t2, 0x0004
--x"016a001a",  --         div $t3, $t2
--x"00005010",  --         mfhi $t2
--x"00005812",  --         mflo $t3
--x"8d0e0000",  --         lw  $t6, 0($t0)
--x"ad0e0004",  --         sw  $t6, 4($t0)
--x"8d0f0004",  --         lw  $t7, 4($t0)
--x"01eb8022",  --         sub $s0, $t7, $t3
--x"00000000",  --         nop
--x"00000000",  --         nop
--x"00000000",  --         nop
--x"00000000",  --         nop
--x"00000000",  --         nop
-- end of r sw lw --

-- rtype only --
--x"3c081002",  --start:  lui $t0, 0x1002
--x"35080000",  --        ori $t0, 0x0000  
--x"210e0001",  --        add $t6, $t0, 0x0
--x"3c090000",  --        lui $t1, 0x0000
--x"35290001",  --        ori $t1, 0x0001  
--x"3c0a0000",  --        lui $t2, 0x0000
--x"354a0002",  --        ori $t2, 0x0002  
--x"3c0b0000",  --        lui $t3, 0x0000
--x"356b0001",  --        ori $t3, 0x0001  
--x"012a6020",  --        add $t4, $t1, $t2
--x"018a6822",  --        sub $t5, $t4, $t2
--x"3c0e0000",  --        lui $t6, 0x0000  
--x"3c0e0000",  --        lui $t6, 0x0000
--x"3c0e0000",  --        lui $t6, 0x0000
--x"3c0e0000",  --        lui $t6, 0x0000
--x"3c0e0000",  --        lui $t6, 0x0000
--x"3c0e0000",  --        lui $t6, 0x0000
--x"3c0e0000",  --        lui $t6, 0x0000
-- end of rtype only

-- br and lw --
--x"3c091001",  -- start:  lui $t1, 0x1001
--x"ad290004",  --    sw  $t1, 4($t1)
--x"8d2a0004",  --    lw  $t2, 4($t1)
--x"112afffc",  --    beq $t1, $t2, start
-- end of rtype

-- parity checking --
--x"3c101002",  -- start:  lui $s0, 0x1002  # address to LED
--x"3c111003",  --         lui $s1, 0x1003  # address of DIP switch
--x"3c140000",  --         lui $s4, 0x0000
--x"36940001",  --         ori $s4, 0x0001  # s4 is 1
--x"3c080000",  --         lui $t0, 0x0000
--x"8e290000",  -- loop:   lw  $t1, 0($s1)  # read the value of DIP switch
--x"ae080000",  --         sw  $t0, 0($s0)
--x"3c080000",  --         lui $t0, 0x0000
--x"3c0a0000",  --         lui $t2, 0x0000
--x"3c130000",  --         lui $s3, 0x0000
--x"3673000f",  --         ori $s3, 0x000f  # s3 is 15
--x"01345024",  -- count:  and $t2, $t1, $s4
--x"00094842",  --         srl $t1, $t1, 0x0001
--x"01484020",  --         add $t0, $t2, $t0
--x"02749822",  --         sub $s3, $s3, $s4
--x"0661fffb",  --         bgez $s3, count
--x"08100005",  --         j   loop
-- end of parity checking --
