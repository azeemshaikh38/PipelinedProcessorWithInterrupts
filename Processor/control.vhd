library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;


entity hazard_control_block is
	port (
		dest_reg_en : in std_logic;
		dest_reg : in std_logic_vector(3 downto 0);
		src_reg1_en : std_logic;
		src_reg1 : in std_logic_vector(3 downto 0);
		src_reg2_en : in std_logic;
		src_reg2 : in std_logic_vector(3 downto 0);
		handlerPC : in std_logic_vector(7 downto 0);
		nop : inout std_logic;
		interrupt_happened : in std_logic;
		interrupt_handled : in std_logic;
		src_select : out std_logic_vector(1 downto 0);
		
		  PC : inout std_logic_vector(7 downto 0);
    		branch : in std_logic;
    		branch_addr : in std_logic_vector(7 downto 0);
    		operation : in std_logic_vector(4 downto 0);
    		clk, rst : in std_logic;
    		PC2handler : out std_logic_vector(7 downto 0)
    		
	);
end entity;

architecture behav of hazard_control_block is

signal prev_dest_reg_en : std_logic;
signal prev_dest_reg : std_logic_vector(3 downto 0);
signal state : std_logic_vector(1 downto 0);
signal temp_pc : std_logic_vector(7 downto 0);
begin
		process(clk, rst)
	begin
		if (rst = '1') then
		  report "Control Block Reset";
			PC <= X"00";
			nop <= '0';
			prev_dest_reg_en <= '0';
			state <= "00";
		elsif	(rising_edge(clk)) then
		  if (state = "00") then
			   if (branch = '1') then
				     PC <= branch_addr;
			   elsif (nop = '1') then
				      PC <= PC - 1;
			   else 
				
				      PC <= PC + 1;
				  end if;
			else 
			       PC <= X"00";
		               temp_pc <= handlerPC;
			end if;
		  
		elsif falling_edge(clk) then
		  report "prev_dest_reg_en: " & integer'image(conv_integer(prev_dest_reg_en)) & "prev_dest_reg: " & integer'image(conv_integer(prev_dest_reg));
		  report "src_reg1_en: " & integer'image(conv_integer(src_reg1_en)) & "src_reg1: " & integer'image(conv_integer(src_reg1));
		  report "src_reg2_en: " & integer'image(conv_integer(src_reg2_en)) & "src_reg2: " & integer'image(conv_integer(src_reg2)); 
	    if (state = "00") then
	         nop <= '0';
	         src_select <= "00";
		       if ((src_reg1_en = '1') and (prev_dest_reg_en = '1')) then
		          report "Source reg 1 enable & Prev dest reg en";
			     if (src_reg1 = prev_dest_reg) then
			        report "Src reg 1, prev dest reg 1"; 
				      src_select(0) <= '1';
			     end if;
		       end if;

		        if ((src_reg2_en = '1') and (prev_dest_reg_en = '1')) then
		           report "Source reg 2 enable & prev dest reg enable";
			      if (src_reg2 = prev_dest_reg) then
			         report "Source reg 2, prev dest reg 2";
				   		  src_select(1) <= '1';
				    end if;
		        end if;
		  
		        if (dest_reg_en = '1') then
		           report "dest reg enable1";
			         prev_dest_reg_en <= '1';
			         prev_dest_reg <= dest_reg;
		        else 
			         prev_dest_reg_en <= '0';
		        end if;
		      
		        if (branch = '1') then
		           nop <= '1';
		        end if;
		        
		        if (interrupt_happened = '1' and interrupt_handled = '0') then
		           state <= "01";
		           nop <= '1';
		        end if;
		        PC2handler <= PC;
		        
		     
		    else
		          PC <= X"00";
		          nop <= '0';
		          if (interrupt_happened = '0' and interrupt_handled = '1') then
		            PC <= temp_pc;
		            state <= "00";
		          end if;
		    end if;
		    end if;
	end process;
end architecture;
