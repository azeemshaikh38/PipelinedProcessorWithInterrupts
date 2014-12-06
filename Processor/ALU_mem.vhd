library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU_ram is
  port(
    clk,rst : in std_logic;
    reg_addr : in std_logic_vector(3 downto 0);
    mem_addr : in std_logic_vector(7 downto 0);
    result : in std_logic_vector(7 downto 0);
    operand : in std_logic_vector(1 downto 0);
    reg_addr_out : out std_logic_vector(3 downto 0);
    reg_data_out : out std_logic_vector(7 downto 0);
    reg_write_enable : out std_logic;
    mem_re, mem_we : out std_logic;
    mem_read_out : out std_logic_vector(7 downto 0)
    );
  end ALU_ram;
  
  architecture mixed of ALU_ram is
    component ram is
       generic(
   data_width : natural := 8;
   addr_width : natural := 8);
port(
  clk,rst : in std_logic;
  data : in std_logic_vector(data_width-1 downto 0);
  write_addr : in std_logic_vector(addr_width-1 downto 0);
  read_addr : in std_logic_vector(addr_width-1 downto 0);
  w_enable : inout std_logic;
  r_enable : inout std_logic;
  data_out : out std_logic_vector(data_width-1 downto 0));
end component;

signal mem_write_addr : std_logic_vector(7 downto 0);
signal mem_read_addr : std_logic_vector(7 downto 0);
signal mem_result : std_logic_vector(7 downto 0);
signal mem_write_enable : std_logic;
signal mem_read_enable : std_logic;
signal mem_data_out : std_logic_vector(7 downto 0);


begin
c0:  ram port map(clk, rst, mem_result, mem_write_addr, mem_read_addr, mem_write_enable, mem_read_enable, mem_data_out);
  
  --For Debug
  mem_re <= mem_read_enable;
  mem_we <= mem_write_enable;
  mem_read_out <= mem_data_out;
  process(reg_addr, mem_addr, result, operand)
    begin
      case operand is
    when "00" =>    --no op
      mem_write_addr <= "00000000";
      mem_read_addr <= "00000000";
      mem_result <= "00000000";
      mem_write_enable <= '0';
      mem_read_enable <= '0';
      mem_data_out <= "00000000"; 
      reg_addr_out <= "0000";
      reg_data_out <= "00000000";
      reg_write_enable <= '0';
      
    when "01" =>    --R <= ALU
      mem_write_enable <= '0';
      mem_read_enable <= '0';
      reg_addr_out <= reg_addr;
      reg_data_out <= result;
      reg_write_enable <= '1';
      
    when "10" =>    --R <= Mem
      mem_read_addr <= mem_addr;
      mem_read_enable <= '1';
      mem_write_enable <= '0';
      reg_addr_out <= reg_addr;
      reg_write_enable <= '1';
      reg_data_out <= mem_data_out;
      
    when "11" =>    --Mem <= R
      mem_write_addr <= mem_addr;
      mem_write_enable <= '1';
      mem_read_enable <= '0';
      reg_write_enable <= '0';
      mem_result <= result;
      
    when others =>
      mem_write_addr <= "00000000";
      mem_read_addr <= "00000000";
      mem_result <= "00000000";
      mem_write_enable <= '0';
      mem_read_enable <= '0';
      mem_data_out <= "00000000"; 
      reg_addr_out <= "0000";
      reg_data_out <= "00000000";
      reg_write_enable <= '0';
    end case;
  end process;
end mixed;
      
      
      
      
        

