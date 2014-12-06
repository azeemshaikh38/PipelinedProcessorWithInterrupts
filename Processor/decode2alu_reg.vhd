library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_unsigned.all;

entity decode2alu_reg is
port(
	clk, rst: in std_logic;
	noop : in std_logic;
	A_in : in std_logic_vector(7 downto 0);
	B_in : in std_logic_vector(7 downto 0);
	operation_in : in std_logic_vector(4 downto 0);
	Raddr1_in : in std_logic_vector(3 downto 0);
	Raddr2_in : in std_logic_vector(3 downto 0);
  Memaddr_in : in std_logic_vector(7 downto 0);
  src_select: in std_logic_vector(1 downto 0);
  ALU_result: in std_logic_vector(7 downto 0);

	A_out : out std_logic_vector(7 downto 0);
	B_out : out std_logic_vector(7 downto 0);
	operation_out : out std_logic_vector(4 downto 0);
	Raddr1_out : out std_logic_vector(3 downto 0);
	Raddr2_out : out std_logic_vector(3 downto 0);
	Memaddr_out : out std_logic_vector(7 downto 0)
);
end decode2alu_reg;

architecture mixed of decode2alu_reg is
begin
process(clk,rst)
begin
	if (rst = '1') then
		A_out <= X"00";
		B_out <= X"00";
		operation_out <= "00000";
		Raddr1_out <= X"0";
		Raddr2_out <= X"0";
		Memaddr_out <= X"00";
	elsif rising_edge(clk) then
		if (noop = '1') then
				A_out <= X"00";
				B_out <= X"00";
				operation_out <= "00000";
				Raddr1_out <= X"0";
				Raddr2_out <= X"0";
				Memaddr_out <= X"00";
		else
		    if (src_select(0) = '0') then
				  A_out <= A_in;
				else
				  A_out <= ALU_result;
				end if;
				
				if (src_select(1) = '0') then
				  B_out <= B_in;
				else
				  B_out <= ALU_result;
				end if;
				
				operation_out <= operation_in;
				Raddr1_out <= Raddr1_in;
				Raddr2_out <= Raddr2_in;
				Memaddr_out <= Memaddr_in;
end if;
end if;
end process;
end mixed;
