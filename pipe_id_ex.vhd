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
    Port ( Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           Pcplus4 : in  STD_LOGIC(31 downto 0);
           Instr_out : out  STD_LOGIC_VECTOR(31 downto 0);
           Pc_out : out  STD_LOGIC(31 downto 0);
           CLK : in  STD_LOGIC;
           -- for EX stage
           ReadData1_Reg_in   : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData2_Reg_in   : in STD_LOGIC_VECTOR (31 downto 0);   
           ReadData1_Reg_out  : out STD_LOGIC_VECTOR (31 downto 0);
           ReadData2_Reg_out  : out STD_LOGIC_VECTOR (31 downto 0);           
           ALU_Control : out  STD_LOGIC_VECTOR (7 downto 0):= "00000000";
           ALUSrc      : out  STD_LOGIC;
           RegDst      : out  STD_LOGIC;
           ZeroToAlu   : out  STD_LOGIC; -- 0 for Rt, 1 for Rd
           -- for MEM stage
           Branch      : out  STD_LOGIC;
           Jump        : out  STD_LOGIC;
           MemRead     : out  STD_LOGIC;
           MemWrite    : out  STD_LOGIC;
           -- for WB stage     
           JumpR       : out  STD_LOGIC;  
           MemtoReg    : out  STD_LOGIC;
           InstrtoReg  : out  STD_LOGIC;
           PcToReg     : out  STD_LOGIC;
           RegWrite    : out  STD_LOGIC;
           -- other
           SignExtend  : out  STD_LOGIC);  
end pipe_id_ex;

architecture Behavioral of pipe_id_ex is
----------------------------------------------------------------
-- Control Unit
----------------------------------------------------------------
component ControlUnit is
    Port (
            Instr       : in   STD_LOGIC_VECTOR (31 downto 0);
            ALU_Control : out  STD_LOGIC_VECTOR (7 downto 0);
            Branch      : out  STD_LOGIC;       
            Jump        : out  STD_LOGIC;   
            JumpR       : out  STD_LOGIC;   
            MemRead     : out  STD_LOGIC;   
            MemtoReg    : out  STD_LOGIC;   
            InstrtoReg  : out  STD_LOGIC;
            PcToReg     : out  STD_LOGIC;
            MemWrite    : out  STD_LOGIC;   
            ALUSrc      : out  STD_LOGIC;   
            SignExtend  : out  STD_LOGIC;
            RegWrite    : out  STD_LOGIC;   
            RegDst      : out  STD_LOGIC;
            ZeroToAlu   : out    STD_LOGIC);
end component;
begin
----------------------------------------------------------------
-- ControlUnit port map
----------------------------------------------------------------
ControlUnit1 : ControlUnit port map
(
    Instr       => Instruction, 
    ALU_Control => ALU_Control,
    Branch      => Branch, 
    Jump        => Jump, 
    JumpR       => JumpR, 
    MemRead     => MemRead, 
    MemtoReg    => MemtoReg, 
    InstrtoReg  => InstrtoReg, 
    PcToReg     => PcToReg,
    MemWrite    => MemWrite, 
    ALUSrc      => ALUSrc, 
    SignExtend  => SignExtend, 
    RegWrite    => RegWrite, 
    RegDst      => RegDst,
    ZeroToAlu   => ZeroToAlu
);
process(CLK)
begin
    if CLK'event and CLK = '1' then
        Instr_out <= Instruction;
        Pc_out <= Pcplus4;
        ReadData1_Reg_out <= ReadData1_Reg_in;
        ReadData2_Reg_out <= ReadData2_Reg_in;
    end if;
end process;
end Behavioral;

