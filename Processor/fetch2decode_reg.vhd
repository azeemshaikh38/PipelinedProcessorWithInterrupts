library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fetch2decode_reg is
port(
  clk, rst : in std_logic;
	noop : in std_logic;
  data_in : in std_logic_vector(15 downto 0);
  data_out : out std_logic_vector(15 downto 0));
end fetch2decode_reg;

architecture mixed of fetch2decode_reg is
begin
process(clk, rst)
begin
	if (rst = '1') then
		data_out <= X"0000";
	elsif rising_edge(clk) then
				if (noop = '1') then
						data_out <= X"0000";
				else
						data_out <= data_in;
end if;
end if;

end process;
end mixed;
