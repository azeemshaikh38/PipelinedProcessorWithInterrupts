library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;


entity selectresult is
  port(
    mem_result : in std_logic_vector(7 downto 0);
    alu_result : in std_logic_vector(7 downto 0);
    select_op : in std_logic_vector(1 downto 0);
    
    result_out : out std_logic_vector(7 downto 0));
  end selectresult;
  
  architecture mixed of selectresult is
    begin
      process(select_op, mem_result, alu_result)
        begin
          case select_op is
          when "10" =>
            result_out <= mem_result;
            
          when others =>
            result_out <= alu_result;
            
          end case;
        end process;
      end mixed;
-------------------------------------------------------------------      
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;



entity datamux is
  port(
     alu_memdata:in std_logic_vector(7 downto 0);
     intrhandler_data:in std_logic_vector(7 downto 0);
     sel: in std_logic;
     data_out: out std_logic_vector(7 downto 0));
   end datamux;
     
     architecture mixed of datamux is
       begin
         process(alu_memdata, sel, intrhandler_data)
           begin
             case sel is
             when '1' =>
               data_out <= intrhandler_data;
             when others =>
               data_out <= alu_memdata;
             end case;
           end process;
         end mixed;
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;



entity writemux is
  port(
     dec_wr:in std_logic_vector(3 downto 0);
     intr_wr:in std_logic_vector(3 downto 0);
     sel: in std_logic;
     wr_out: out std_logic_vector(3 downto 0));
   end writemux;
     
     architecture mixed of writemux is
       begin
         process(dec_wr, intr_wr, sel)
           begin
             case sel is
             when '1' =>
               wr_out <= intr_wr;
             when others =>
               wr_out <= dec_wr;
             end case;
           end process;
         end mixed;
         
---------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;



entity readmux is
  port(
     dec_raddr1:in std_logic_vector(3 downto 0);
     dec_raddr2:in std_logic_vector(3 downto 0);
     intr_raddr1:in std_logic_vector(3 downto 0);
     intr_raddr2:in std_logic_vector(3 downto 0);
     sel: in std_logic;
     out_raddr1: out std_logic_vector(3 downto 0);
     out_raddr2: out std_logic_vector(3 downto 0));
   end readmux;
     
     architecture mixed of readmux is
       begin
         process(dec_raddr1, dec_raddr2, intr_raddr1, intr_raddr2, sel)
           begin
             case sel is
             when '1' =>
              out_raddr1 <= intr_raddr1;
              out_raddr2 <= intr_raddr2;
             when others =>
              out_raddr1 <= dec_raddr1;
              out_raddr2 <= dec_raddr2;
             end case;
           end process;
         end mixed;


-------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity enable_mux is
  port (
    processor_en, sel : in std_logic;
    en_out : out std_logic
  );
end entity;

architecture behav of enable_mux is
begin
  process(processor_en, sel)
    begin
      case sel is
      when '1' =>
        en_out <= '1';
      when others =>
        en_out <= processor_en;
      end case;
    end process;
end architecture;

