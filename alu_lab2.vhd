----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   10:39:18 13/09/2014
-- Design Name: 	ALU
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: ALU template for MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------


------------------------------------------------------------------
-- ALU Entity
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_lab2 is
generic (width 	: integer := 32);
Port (Clk			: in	STD_LOGIC;
		Control		: in	STD_LOGIC_VECTOR (5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Status		: out	STD_LOGIC_VECTOR (2 downto 0); -- busy (multicycle only), overflow (add and sub), zero (sub)
		Debug			: out	STD_LOGIC_VECTOR (width-1 downto 0));		
end alu_lab2;


------------------------------------------------------------------
-- ALU Architecture
------------------------------------------------------------------

architecture arch_alu_lab2 of alu_lab2 is

type states is (COMBINATIONAL, MULTI_CYCLE);
signal state, n_state 	: states := COMBINATIONAL;

----------------------------------------------------------------------------
-- Shifter instantiation
----------------------------------------------------------------------------

component shifter is
    Port ( SOURCE : in  STD_LOGIC_VECTOR (31 downto 0);
           SHIFT_AMT : in  STD_LOGIC_VECTOR (4 downto 0);
			  DIRECTION : in STD_LOGIC; -- left is '0'
			  SHIFT_TYPE : in STD_LOGIC; -- logical shift is '0'
           SHIFTER_RESULT : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

----------------------------------------------------------------------------
-- Shifter signals
----------------------------------------------------------------------------

signal SHIFTER_RESULT : STD_LOGIC_VECTOR(31 downto 0);

----------------------------------------------------------------------------
-- Adder instantiation
----------------------------------------------------------------------------
component addsub is
generic (width : integer);
    Port ( A : in  STD_LOGIC_VECTOR(31 downto 0);
           B : in  STD_LOGIC_VECTOR(31 downto 0);
           B_INV : in  STD_LOGIC;
           SUM : out  STD_LOGIC_VECTOR(31 downto 0);
           CARRY_OUT : out  STD_LOGIC);
end component;

----------------------------------------------------------------------------
-- AddSub signals
----------------------------------------------------------------------------

signal SUM : STD_LOGIC_VECTOR (31 DOWNTO 0) := (others => '0');
signal CARRY_OUT : STD_LOGIC := '0';
signal CARRY_OUT_MULTI : STD_LOGIC := '0';

----------------------------------------------------------------------------
-- Signals for MULTI_CYCLE_PROCESS
----------------------------------------------------------------------------
signal Result1_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0'); 
signal Result2_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0');
signal Debug_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0');
signal multi_sum			: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0');
signal Divisor				: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0');
signal temp_sum : std_logic_vector(2*width-1 downto 0) := (others => '0');
signal sign_quotient    : STD_LOGIC := '0';
signal sign_remainder   : STD_LOGIC := '0';
signal done		 			: STD_LOGIC := '0';

begin

-- <port maps>
addsuber1 : addsub generic map(width => width) port map ( A=>Operand1, 
                                                          B=>Operand2, 
																			 B_INV=>CONTROL(2), 
																			 SUM=>SUM, 
																			 CARRY_OUT=>CARRY_OUT );
addsubermulti : addsub generic map(width => width) port map ( A=>Result2_multi, 
                                                              B=>Divisor, 
																			     B_INV=>CONTROL(1), 
																			     SUM=>MULTI_SUM, 
																			     CARRY_OUT=>CARRY_OUT_MULTI );
shifter1 : shifter port map(OPERAND1, 
									 SHIFT_AMT=>OPERAND2 (4 downto 0), 
									 DIRECTION=>CONTROL(3), 
									 SHIFT_TYPE=>CONTROL(2),
									 SHIFTER_RESULT=>SHIFTER_RESULT);
-- </port maps>


----------------------------------------------------------------------------
-- COMBINATIONAL PROCESS
----------------------------------------------------------------------------
COMBINATIONAL_PROCESS : process (
											Control, Operand1, Operand2, state, -- external inputs
											SUM, SHIFTER_RESULT, CARRY_OUT, -- external results
											Result1_multi, Result2_multi, Debug_multi, done -- from multi-cycle process(es)
											)
begin

-- <default outputs>
Status(2 downto 0) <= "000"; -- both statuses '0' by default 
Result1 <= (others=>'0');
Result2 <= (others=>'0');
Debug <= (others=>'0');

n_state <= state;
-- </default outputs>

--reset
if Control(5) = '1' then
	n_state <= COMBINATIONAL;
else

case state is
	when COMBINATIONAL =>
		case Control(4 downto 0) is
			--and
			when "00000" => 
				Result1 <= Operand1 and Operand2;
			--or
			when "00001" =>
				Result1 <= Operand1 or Operand2;
			-- xor
			when "00100" =>
				Result1 <= Operand1 xor Operand2;
			--nor
			when "01100" => 
				Result1 <= Operand1 nor Operand2;
			--add
			when "00010" =>
				Result1 <= SUM;
				-- overflow
				Status(1) <= ( Operand1(width-1) xnor  Operand2(width-1) )  and ( Operand2(width-1) xor SUM(width-1) );
			-- sub
			when "00110" =>
				Result1 <= SUM;
				-- overflow
				Status(1) <= ( Operand1(width-1) xor  Operand2(width-1) )  and ( Operand2(width-1) xnor SUM(width-1) );
				--zero
				if SUM = x"00000000" then 
					Status(0) <= '1'; 
				else
					Status(0) <= '0';
				end if;
			-- slt
			when "00111" =>
				if (Operand1(31) xor Operand2(31)) = '1' then
					Result1 <= (0 => Operand1(31), others => '0');
				else
					Result1 <= (0 => SUM(31), others => '0');
				end if;
				Result2 <= (others => 'X');
				Status (1 downto 0) <= "XX";
			-- sltu
			when "01110" =>
				Result1 <= (0 => not(CARRY_OUT), others => '0');
				Result2 <= (others => 'X');
				Status (1 downto 0) <= "XX";
			-- shifter (sll, srl, sra)
			when "00101" | "01101" | "01001" =>
				Result1 <= SHIFTER_RESULT;
				Result2 <= (others => 'X');
			-- multi-cycle operations
			when "10000" | "10001" | "10010" | "10011" | "11110" => 
				n_state <= MULTI_CYCLE;
				Status(2) <= '1';				
			-- default cases (already covered)
			when others=> null;
		end case;
	when MULTI_CYCLE => 
		if done = '1' then
			Result1 <= Result1_multi;
			Result2 <= Result2_multi;
			Debug <= Debug_multi;
			n_state <= COMBINATIONAL;
			Status(2) <= '0';
		else
			Status(2) <= '1';
			n_state <= MULTI_CYCLE;
		end if;
	end case;
end if;	
end process;


----------------------------------------------------------------------------
-- STATE UPDATE PROCESS
----------------------------------------------------------------------------

STATE_UPDATE_PROCESS : process (Clk) -- state updating
begin  
   if (Clk'event and Clk = '1') then
		state <= n_state;
   end if;
end process;

----------------------------------------------------------------------------
-- MULTI CYCLE PROCESS
----------------------------------------------------------------------------

MULTI_CYCLE_PROCESS : process (Clk) -- multi-cycle operations done here
-- assume that Operand1 and Operand 2 do not change while multi-cycle operations are being performed
variable count : std_logic_vector(7 downto 0) := (others => '0');
variable temp_sum_helper : std_logic_vector(2*width-1 downto 0) := (others => '0');
variable sum_for_11				: std_logic_vector(2*width-1 downto 0) := (others => '0');
variable operand1_val : std_logic_vector(2*width-1 downto 0) := (others => '0');
variable operand2_val : std_logic_vector(width-1 downto 0) := (others => '0');
variable extended_result1sign : std_logic_vector(width-1 downto 0) := (others => '0');
variable extended_result2sign : std_logic_vector(width-1 downto 0) := (others => '0');
variable abs_result1 : std_logic_vector(width-1 downto 0) := (others => '0');
variable abs_result2 : std_logic_vector(width-1 downto 0) := (others => '0');
begin  
   if (Clk'event and Clk = '1') then 
		if Control(5)= '1' then
			count := (others=> '0');
			Result1_multi <= (others => '0');
			Result2_multi <= (others => '0');
		end if;
		done <= '0';
		if n_state = MULTI_CYCLE then
			case Control(4 downto 0) is
			-- mult, multu
			when "10000" | "10001" =>  -- takes 19 cycles to execute, returns Operand1*Operand2
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					-- init mult result & count
					temp_sum <= (others => '0');
					count := (others => '0');
					
					-- init op1, op2, & their signs var
					extended_result1sign := (others => (Operand1(width-1) and (not(Control(0)))));
					operand1_val(width-1 downto 0) := (Operand1 xor extended_result1sign) + (Operand1(width-1) and (not(Control(0))));
					operand1_val(2*width-1 downto width) := (others => '0');
					extended_result2sign := (others => (Operand2(width-1) and (not(Control(0)))));
					operand2_val := (Operand2 xor extended_result2sign) + (Operand2(width-1) and (not(Control(0))));
					sign_quotient <= (Operand1(width-1) xor Operand2(width-1)) and (not(Control(0)));
					
					-- init temporary sum for case 11 of op2 (one add required)
					sum_for_11 := operand1_val + (operand1_val(2*width-2 downto 0) & '0');
				else
					count := count + 1;
					
					if count = x"11" then -- when count = 18 (dec), assign it to result
						temp_sum_helper := (others => sign_quotient);
						temp_sum_helper := (temp_sum xor temp_sum_helper) + sign_quotient;
						RESULT1_MULTI <= temp_sum_helper(width-1 downto 0);
						RESULT2_MULTI <= temp_sum_helper(2*width-1 downto width);
						DONE <= '1';
					--elsif count = x"11" then -- when count = 17 (dec), convert it to signed number
					--	temp_sum_helper := (others => sign_quotient);
					--	temp_sum <= (temp_sum xor temp_sum_helper) + sign_quotient;
					else
						if operand2_val(1) = '0' and operand2_val(0) = '1' then
							-- for 01 case of op2, directly add op1
							temp_sum <= temp_sum + operand1_val;
						elsif operand2_val(1) = '1' and operand2_val(0) = '0' then
							-- for 10 case, shift op1 and then add it to sum
							temp_sum <= temp_sum + (operand1_val(2*width-2 downto 0) & '0');
						elsif operand2_val(1) = '1' and operand2_val(0) = '1' then
							-- for 11 case, add sum_fo_11 to sum
							temp_sum <= temp_sum + sum_for_11;
						-- case 00 no need any action
						end if;
						operand1_val := operand1_val(2*width-3 downto 0) & "00"; -- sll 2 for op1
						sum_for_11 := sum_for_11(2*width-3 downto 0) & "00"; -- sll 2 for sum_for_11
						operand2_val := "00" & operand2_val(width-1 downto 2); -- srl 2 for op2
					end if;
				end if;
			-- div, divu
			when "10010" | "10011" =>  -- takes 34 cycles to execute, returns Operand1/Operand2
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					-- handle div by zero
					if Operand2 = x"00000000" then  -- divisor is 0
						Result1_multi <= (others => 'X');
						Result2_multi <= (others => 'X');
						done <= '1';
					else
						count := (others => '0');
						sign_quotient <= (Operand1(31) xor Operand2(31)) and (not(Control(0)));
						sign_remainder <= Operand1(31) and (not(Control(0)));
						
						-- get abs value of the operands
						extended_result1sign := (others => (Operand1(31) and (not(Control(0)))));
						extended_result2sign := (others => (Operand2(31) and (not(Control(0)))));
						abs_result1 := (Operand1 xor extended_result1sign) + (Operand1(31) and (not(Control(0))));
						abs_result2 := (Operand2 xor extended_result2sign) + (Operand2(31) and (not(Control(0))));
						
						-- pass them to the unsigned div hardware
						Result1_multi <= abs_result1(width-2 downto 0) & '0';
						Result2_multi <= (0 => abs_result1(width - 1), others => '0');
						Divisor <= abs_result2;
					end if;
				else
					count := count + 1;
					if count=x"20" then
						if CARRY_OUT_MULTI = '1' then  -- Result2_multi is not less than the divisor
							extended_result2sign := (others => sign_remainder);
							Result2_multi <= (MULTI_SUM xor extended_result2sign);
						else
						   extended_result2sign := (others => sign_remainder);
							Result2_multi <= (Result2_multi xor extended_result2sign);
						end if;
						extended_result1sign := (others => sign_quotient);
						Result1_multi <= ((Result1_multi(31 downto 1) & CARRY_OUT_MULTI) xor extended_result1sign);
					elsif count=x"21" then
						done <= '1';
						Result2_multi <= Result2_multi + sign_remainder;
						Result1_multi <= Result1_multi + sign_quotient;
					else
						if CARRY_OUT_MULTI = '1' then  -- Result2_multi is not less than the divisor
							Result2_multi <= MULTI_SUM(30 downto 0) & Result1_multi(31);
						else
							Result2_multi <= Result2_multi(30 downto 0) & Result1_multi(31);
						end if;
						Result1_multi <= Result1_multi(30 downto 1) & CARRY_OUT_MULTI & '0';
					end if;
				end if;
			when "11110" => -- takes 2 cycles to execute, just returns the operands
				if state = COMBINATIONAL then
					Result1_multi <= Operand1;
					Result2_multi <= Operand2;
					Debug_multi <= Operand1(width-1 downto width/2) & Operand2(width-1 downto width/2);
					done <= '1';
				end if;	
			when others=> null;
			end case;
		end if;
	end if;
end process;


end arch_alu_lab2;