----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:44 11/02/2014 
-- Design Name: 
-- Module Name:    pipe_ex_mem - Behavioral 
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

entity pipe_ex_mem is
    Port ( Branch      			: in  STD_LOGIC;
			  ALUZero				: in  STD_LOGIC;
           MemRead     			: in  STD_LOGIC;
           MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
           PcToReg     			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
			  RegDst					: in  STD_LOGIC;
           RegWrite    			: in  STD_LOGIC;
			  InstrRs 				: in  STD_LOGIC_VECTOR(4 downto 0); -- does not seem to be useful either
			  InstrRt 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRd 				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrLower 			: in  STD_LOGIC_VECTOR(15 downto 0);
           PcPlus4 				: in  STD_LOGIC_VECTOR(31 downto 0);
			  BranchPcTgt 			: in  STD_LOGIC_VECTOR(31 downto 0);
           Alu_out   			: in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData2_Reg  		: in  STD_LOGIC_VECTOR(31 downto 0);
			  
           Out_Branch      	: out STD_LOGIC;
			  Out_ALUZero			: out STD_LOGIC;
           Out_MemRead     	: out STD_LOGIC;
           Out_MemWrite    	: out STD_LOGIC;
			  Out_MemToReg    	: out STD_LOGIC;
           Out_PcToReg     	: out STD_LOGIC;
			  Out_InstrToReg  	: out STD_LOGIC;
			  Out_RegDst			: out STD_LOGIC;
			  Out_RegWrite    	: out STD_LOGIC;
			  Out_InstrRs 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRt 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrRd 			: out STD_LOGIC_VECTOR(4 downto 0);
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0);
           Out_PcPlus4			: out STD_LOGIC_VECTOR(31 downto 0);
			  Out_BranchPcTgt		: out STD_LOGIC_VECTOR(31 downto 0);
           Out_Alu_out  		: out STD_LOGIC_VECTOR(31 downto 0);
           Out_ReadData2_Reg 	: out STD_LOGIC_VECTOR(31 downto 0);
			  CLK 					: in  STD_LOGIC);  
end pipe_ex_mem;

architecture Behavioral of pipe_ex_mem is
begin
process(CLK)
begin
    if CLK'event and CLK = '1' then
        Out_Branch <= Branch;
		Out_ALUZero <= ALUZero;
        Out_MemRead <= MemRead;
        Out_MemWrite <= MemWrite;
        Out_MemToReg <= MemToReg;
        Out_PcToReg <= PcToReg;
        Out_InstrToReg <= InstrToReg;
        Out_RegDst <= RegDst;
        Out_RegWrite <= RegWrite;
        Out_InstrRs <= InstrRs;
        Out_InstrRt <= InstrRt;
        Out_InstrRd <= InstrRd;
        Out_InstrLower <= InstrLower;
        Out_PcPlus4 <= PcPlus4;
        Out_BranchPcTgt <= BranchPcTgt;
        Out_Alu_out <= Alu_out;	
        Out_ReadData2_Reg <= ReadData2_Reg;
    end if;
end process;
end Behavioral;
