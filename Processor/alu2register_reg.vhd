library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu2register_reg is
  port(
    clk, rst : in std_logic;
    raddr_in : in std_logic_vector(3 downto 0);
    op_in : in std_logic_vector(1 downto 0);
    result_in : in std_logic_vector(7 downto 0);
    reg_wr_en_in : in std_logic;
       
    raddr_out : out std_logic_vector(3 downto 0);
    op_out : out std_logic_vector(1 downto 0);
    result_out : out std_logic_vector(7 downto 0);
    reg_wr_en_out : out std_logic    
    );
  end alu2register_reg;
  
  architecture mixed of alu2register_reg is
    begin
      process(clk, rst)
        begin
          if (rst = '1') then
            raddr_out <= "0000";
            op_out <= "00";
            result_out <= X"00";
            reg_wr_en_out <= '0';
          elsif falling_edge(clk) then
                         
            raddr_out <= raddr_in;
            op_out <= op_in;
            result_out <= result_in;
            reg_wr_en_out <= reg_wr_en_in;
          end if;
       
      end process;
    end mixed;
    
