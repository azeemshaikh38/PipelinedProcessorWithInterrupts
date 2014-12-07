library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

entity ram is
port(
  data : in std_logic_vector(7 downto 0);
  write_addr : in std_logic_vector(7 downto 0);
  read_addr : in std_logic_vector(7 downto 0);
  w_enable : in std_logic;
  r_enable : in std_logic;
  clk, rst : in std_logic;
  data_out : out std_logic_vector(7 downto 0));
end ram;

architecture mixed of ram is
  type mem_type is array(255 downto 0) of std_logic_vector(7 downto 0);
  
  signal mem_data : mem_type;
  
  begin
    process(clk, rst)
      begin
        if(rst = '1') then
          mem_data(0) <= X"0A";
          mem_data(1) <= X"02";
          mem_data(2) <= X"31";
          mem_data(3) <= X"0E";
          mem_data(4) <= X"E3";
          mem_data(5) <= X"B4";
          mem_data(6) <= X"25";
          mem_data(7) <= X"86";
          mem_data(8) <= X"77";
          mem_data(9) <= X"98";
          mem_data(10) <= X"29";
          mem_data(11) <= X"10";
          mem_data(12) <= X"1F";
          report "RAM data set." ;
        end if;
        
        if (falling_edge(clk)) then
          if (w_enable = '1') then
            mem_data(conv_integer(write_addr)) <= data;
            report "Memory write addr: " & integer'image(conv_integer(write_addr)) & " data: " & integer'image(conv_integer(data));
          end if;       
          if (r_enable = '1') then
            data_out <= mem_data(conv_integer(read_addr));
            report "Memory read addr: " & integer'image(conv_integer(read_addr)) & " data: " & integer'image(conv_integer(mem_data(conv_integer(read_addr))));
          end if;
        end if;
            
        end process;
      end mixed;
          
