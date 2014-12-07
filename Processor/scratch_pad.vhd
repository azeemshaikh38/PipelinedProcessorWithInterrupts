library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

entity scratch_pad is
	port (
		data_in1, data_in2 : in std_logic_vector(7 downto 0);
		raddr_write1, raddr_write2 : in std_logic_vector(3 downto 0);
		data_out : out std_logic_vector(7 downto 0);
		raddr_read : in std_logic_vector(3 downto 0);
		re, we, clk : in std_logic
	);
end entity;

architecture behav of scratch_pad is

type mem_array is array(15 downto 0) of std_logic_vector(7 downto 0);
signal mem_data : mem_array;

begin
	process (clk) 
	begin
		if (rising_edge(clk) and (we = '1')) then
			mem_data(conv_integer(raddr_write1)) <= data_in1;
			report "Scratch Pad write addr: " & integer'image(conv_integer(raddr_write1)) & " data: " & integer'image(conv_integer(data_in1));
			mem_data(conv_integer(raddr_write2)) <= data_in2;
			report "Scratch Pad write addr: " & integer'image(conv_integer(raddr_write2)) & " data: " & integer'image(conv_integer(data_in2));
		elsif (falling_edge(clk) and (re = '1')) then
			data_out <= mem_data(conv_integer(raddr_read));
			report "Scratch Pad read addr: " & integer'image(conv_integer(raddr_read)) & " data: " & integer'image(conv_integer(mem_data(conv_integer(raddr_read))));
		end if;
	end process;
end architecture; 
