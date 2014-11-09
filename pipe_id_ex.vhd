----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:44 11/02/2014 
-- Design Name: 
-- Module Name:    pipe_id_ex - Behavioral 
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

entity pipe_id_ex is
    Port ( ALUSrc      			: in  STD_LOGIC;
			  ZeroToAlu   			: in  STD_LOGIC;
			  MemRead     			: in  STD_LOGIC;
			  MemWrite    			: in  STD_LOGIC;
			  MemToReg    			: in  STD_LOGIC;
			  InstrToReg  			: in  STD_LOGIC;
			  PcToReg     			: in  STD_LOGIC;
			  RegWrite    			: in  STD_LOGIC;
			  Shift					: in  STD_LOGIC;
			  ShiftAmtV				: in  STD_LOGIC;
			  InstrRs				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRt				: in  STD_LOGIC_VECTOR(4 downto 0);
			  InstrRd				: in  STD_LOGIC_VECTOR(4 downto 0);
			  ALU_Control 			: in  STD_LOGIC_VECTOR(7 downto 0);
			  InstrLower 			: in  STD_LOGIC_VECTOR(15 downto 0);
			  ReadData1_Reg		: in  STD_LOGIC_VECTOR(31 downto 0);
           ReadData2_Reg	   : in  STD_LOGIC_VECTOR(31 downto 0);
			  PcPlus4 				: in  STD_LOGIC_VECTOR(31 downto 0);
			  SignExtended  		: in  STD_LOGIC_VECTOR(31 downto 0);
			  
           Out_ALUSrc      	: out STD_LOGIC := '0';
           Out_ZeroToAlu   	: out STD_LOGIC := '0';
           Out_MemRead     	: out STD_LOGIC := '0';
           Out_MemWrite    	: out STD_LOGIC := '0';
           Out_MemToReg    	: out STD_LOGIC := '0';
           Out_InstrToReg  	: out STD_LOGIC := '0';
           Out_PcToReg     	: out STD_LOGIC := '0';
           Out_RegWrite    	: out STD_LOGIC := '0';
			  Out_Shift				: out STD_LOGIC := '0';
			  Out_ShiftAmtV		: out STD_LOGIC := '0';
			  Out_InstrRs			: out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
			  Out_InstrRt			: out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
			  Out_InstrRd			: out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
			  Out_ALU_Control 	: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
			  Out_InstrLower 		: out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
			  Out_ReadData1_Reg  : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
           Out_ReadData2_Reg  : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			  Out_PcPlus4 			: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			  Out_SignExtended  	: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			  Stall					: in  STD_LOGIC := '0';
			  CLK 					: in  STD_LOGIC);  
end pipe_id_ex;

architecture Behavioral of pipe_id_ex is
begin
process(CLK)
begin
	if CLK'event and CLK = '1' then
		if Stall = '0' then
			Out_ALUSrc <= ALUSrc;
			Out_ZeroToAlu <= ZeroToAlu;
			Out_MemRead <= MemRead;
			Out_MemWrite <= MemWrite;
			Out_MemToReg <= MemtoReg;
			Out_InstrToReg <= InstrtoReg;
			Out_PcToReg <= PCToReg;
			Out_RegWrite <= RegWrite;
			Out_Shift <= Shift;
			Out_ShiftAmtV <= ShiftAmtV;
			Out_InstrRs <= InstrRs;
			Out_InstrRt <= InstrRt;
			Out_InstrRd <= InstrRd;
			Out_ALU_Control <= ALU_Control;
			Out_ReadData1_Reg <= ReadData1_Reg;
			Out_ReadData2_Reg <= ReadData2_Reg;
			Out_PcPlus4 <= PcPlus4;
			Out_SignExtended <= SignExtended;
			Out_InstrLower <= InstrLower;
		end if;
	end if;
end process;
end Behavioral;

