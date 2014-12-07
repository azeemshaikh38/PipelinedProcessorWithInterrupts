library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

entity register_bank is
port(
  clk,rst : in std_logic;
  data : in std_logic_vector(7 downto 0);
  write_addr : in std_logic_vector(3 downto 0);
  read_addr1 : in std_logic_vector(3 downto 0);
  read_addr2 : in std_logic_vector(3 downto 0);
  w_enable : in std_logic;
  r_enable : in std_logic;
  data_out1 : out std_logic_vector(7 downto 0);
  data_out2 : out std_logic_vector(7 downto 0));
end register_bank;

architecture mixed of register_bank is
  type mem_type is array(15 downto 0) of std_logic_vector(7 downto 0);
  
  signal mem_data : mem_type;
  
  begin
    process(clk, rst)
      begin
	--if (rst = '1') then
	--	mem_data(0) <= X"30";
	--	mem_data(1) <= X"40";
	--	mem_data(2) <= X"50";
	--	mem_data(3) <= X"60";
	--	mem_data(4) <= X"70";
	--end if;

        if (rising_edge(clk) and (w_enable = '1')) then
            mem_data(conv_integer(write_addr)) <= data;
            report "Registerbank write addr: " & integer'image(conv_integer(write_addr)) & " data: " & integer'image(conv_integer(data));
        end if;
        
	if (falling_edge(clk) and (r_enable = '1')) then
            data_out1 <= mem_data(conv_integer(read_addr1));
            report "Registerbank read addr1: " & integer'image(conv_integer(read_addr1)) & " data: " & integer'image(conv_integer(mem_data(conv_integer(read_addr1))));
            data_out2 <= mem_data(conv_integer(read_addr2));
            report "Registerbank read addr2: " & integer'image(conv_integer(read_addr2)) & " data: " & integer'image(conv_integer(mem_data(conv_integer(read_addr2))));
        end if;
      
        end process;
   end mixed;
          
