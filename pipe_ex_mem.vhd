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
    Port ( CLK : in  STD_LOGIC;
           Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           PcPlus4 : in  STD_LOGIC(31 downto 0);
           Out_InstrLower : out  STD_LOGIC_VECTOR(15 downto 0);
           Out_PCPlus4: out  STD_LOGIC(31 downto 0);
           -- for MEM stage
           Branch      : in  STD_LOGIC;
           MemRead     : in  STD_LOGIC;
           MemWrite    : in  STD_LOGIC;
           AluOut   : in STD_LOGIC_VECTOR (31 downto 0);
           AluZero  : in STD_LOGIC;
           ReadData2_Reg  : in STD_LOGIC_VECTOR (31 downto 0);
           Out_Branch      : out  STD_LOGIC;
           Out_MemRead     : out  STD_LOGIC;
           Out_MemWrite    : out  STD_LOGIC;
           Out_AluOut  : out STD_LOGIC_VECTOR (31 downto 0);
           Out_AluZero : out STD_LOGIC;
           Out_ReadData2_Reg : out STD_LOGIC_VECTOR (31 downto 0);
           -- for WB stage 
           MemToReg    : in  STD_LOGIC;
           PcToReg     : in  STD_LOGIC;
           RegWrite    : in  STD_LOGIC;
           Out_MemToReg    : out  STD_LOGIC;
           Out_PcToReg     : out  STD_LOGIC;
           Out_RegWrite    : out  STD_LOGIC);  
end pipe_ex_mem;

architecture Behavioral of pipe_ex_mem is
begin
process(CLK)
begin
    if CLK'event and CLK = '1' then
        Out_InstrLower <= Instruction(15 downto 0);
        Out_PcPlus4 <= PcPlus4;
        -- for Mem
        Out_Branch <= Branch;
        Out_MemRead <= MemRead;
        Out_MemWrite <= MemWrite;
        Out_AluOut <= AluOut;
        Out_AluZero <= AluZero;
        Out_ReadData2_Reg <= ReadData2_Reg;
        -- for WB
        Out_MemToReg <= MemToReg;
        Out_PcToReg <= PcToReg;
        Out_RegWrite <= RegWrite;
    end if;
end process;
end Behavioral;
