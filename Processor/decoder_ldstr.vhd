library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decode is
  port(
    din: in  std_logic_vector(15 downto 0);
    reg_rd_en : out std_logic;
    Raddr1:out std_logic_vector(3 downto 0);
    Raddr2:out std_logic_vector(3 downto 0);  
    memaddr: out std_logic_vector(7 downto 0);
    operation:out std_logic_vector(4 downto 0);
    dest_reg_en: out std_logic;
    dest_reg: out std_logic_vector(3 downto 0);
    src_reg1_en: out std_logic;
    src_reg1: out std_logic_vector(3 downto 0);
    src_reg2_en: out std_logic;
    src_reg2: out std_logic_vector(3 downto 0);
    return_from_interrupt : out std_logic
    );
  end decode;
  
  
  architecture behav of decode is
   begin
     process(din)
       variable check : std_logic_vector(3 downto 0);
       begin
	 dest_reg_en <= '0';
    	 dest_reg <= "0000";
    	 src_reg1_en <= '0';
    	 src_reg1 <= "0000";
    	 src_reg2_en <= '0';
    	 src_reg2 <= "0000";
	 return_from_interrupt <= '0';
         reg_rd_en <= '1';
         check := din(15 downto 12);
            case check is
-------------------------------- No Operation ------------------------------------------

              when "0000" =>   					                          -- no op
                Raddr1 <= "0000";
                Raddr2 <= "0000";
                memaddr<= "00000000";
                operation <= "00000";
		dest_reg_en <= '0';
		src_reg1_en <= '0';
		src_reg2_en <= '0';
		reg_rd_en <= '0';

---------------------------------- Add/Subtract Operations ------------------------------

             when "0001" =>   					                                 -- add immediate
               Raddr1<= din(11 downto 8);
               Raddr2<= "0000";
               memaddr<= din(7 downto 0);
	       operation<= "00001";
	       dest_reg_en <= '1';
		dest_reg <= din(11 downto 8);
		src_reg1_en <= '1';
		src_reg1 <= din(11 downto 8);
		src_reg2_en <= '0';
 
      	     when "0010" =>   					                                  -- add/sub
		          Raddr1<= din(7 downto 4);
		          Raddr2<= din(3 downto 0);
	            memaddr<= "00000000";
	             if (din(11 downto 8) = "0000") then
     		           operation<= "00010";                              --add
   	           else
     		           operation<= "00011";                              --sub
 	             end if;
			dest_reg_en <= '1';
			dest_reg <= din(7 downto 4);
			src_reg1_en <= '1';
			src_reg1 <= din(7 downto 4);
			src_reg2_en <= '1';
			src_reg2 <= din(3 downto 0);
 	             
--------------------------------------- Increment/Decrement ---------------------------------

      	     when "0011" =>   					                                  -- increment/decrement
		          Raddr1<= din(11 downto 8);
		          Raddr2<= "0000";
	            memaddr<= "00000000";
	             if (din(11 downto 8) = "0000") then
     		           operation<= "00100";                        --inc
   	           else
     		           operation<= "00101";                        --dec
 	             end if;

			dest_reg_en <= '1';
			dest_reg <= din(11 downto 8);
			src_reg1_en <= '1';
			src_reg1 <= din(11 downto 8);
			src_reg2_en <= '0';

------------------------------------------ Shift Operations -----------------------------------

	         when "0100" =>   					                                   -- shift left/right
		          Raddr1<= din(11 downto 8);
		          Raddr2<= "0000";
	            memaddr<= "00000000";
	             if (din(11 downto 8) = "0000") then
     		           operation<= "00110";                              --shift left
   	           else
     		           operation<= "00111";                              --shift right
 	             end if;
			
			dest_reg_en <= '1';
			dest_reg <= din(11 downto 8);
			src_reg1_en <= '1';
			src_reg1 <= din(11 downto 8);
			src_reg2_en <= '0';

-------------------------------------------- Logical Operations ---------------------------------

	         when "0101" =>                                         --- logical operator

		dest_reg_en <= '1';
		dest_reg <= din(7 downto 4);
		src_reg1_en <= '1';
		src_reg1 <= din(7 downto 4);
		src_reg2_en <= '1';
		src_reg2 <= din(3 downto 0);

  		if(din(11 downto 8) = "0000") then                        -- not
			operation<= "01000";
			Raddr1<= din(11 downto 8);
			Raddr2<= "0000";
			memaddr<= "00000000";
			dest_reg <= din(11 downto 8);
			src_reg1 <= din(11 downto 8);
			src_reg2_en <= '0';
		end if;

		if(din(11 downto 8) = "0001") then                        -- nor
			operation<= "01001";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
		end if;
		
		if(din(11 downto 8) = "0010") then                        -- nand
			operation<= "01010";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
		end if;

		if(din(11 downto 8) = "0011") then                        -- xor
			operation<= "01011";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
		end if;

		if(din(11 downto 8) = "0100") then                        -- and
			operation<= "01100";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
		end if;
		
		if(din(11 downto 8) = "0101") then                        -- nor
			operation<= "01101";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
		end if;
		
------------------------------------- Set/Clear Operations -------------------------

		if(din(11 downto 8) = "0110") then                          -- clear
			operation<= "01110";
			Raddr1<= din(7 downto 4);
			Raddr2<= "0000";
			memaddr<= "00000000";
			dest_reg <= din(7 downto 4);
			src_reg1 <= din(7 downto 4);
			src_reg2_en <= '0';
		end if;

		if(din(11 downto 8) = "0111" ) then                       -- set
			operation<= "01111";
			Raddr1<= din(7 downto 4);
			Raddr2<= "0000";
			memaddr<= "00000000";
			dest_reg <= din(7 downto 4);
			src_reg1 <= din(7 downto 4);
			src_reg2_en <= '0';
		end if;

		if(din(11 downto 8) = "1111") then                       -- set if less than
			operation<= "10000";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
			dest_reg <= din(7 downto 4);
			src_reg1 <= din(7 downto 4);
			src_reg2 <= din(3 downto 0);
		end if;
		
-------------------------------------- Move Operations -------------------------------------

		if(din(11 downto 8) = "1000") then                       -- move
			operation<= "10001";
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
			dest_reg <= din(7 downto 4);
			src_reg1 <= din(3 downto 0);
			src_reg2_en <= '0';
		end if;
			
------------------------------------- Enable Interrupt -------------------------------------
		when "0111" =>                                          --enable interrupts
			operation<= "10010";
			Raddr1<= "0000";
			Raddr2<= "0000";
			memaddr<= "00000000";
			dest_reg_en <= '0';
			src_reg1_en <= '0';
			src_reg2_en <= '0';
			reg_rd_en <= '0';
			
----------------------------------- Load/Store Operations ----------------------------------

		when "1000" =>                                         --load indirect
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
			operation<= "10011";
			dest_reg_en <= '1';
			dest_reg <= din(7 downto 4);
			src_reg1_en <= '0';
			src_reg2_en <= '1';
			src_reg2 <= din(3 downto 0);

		when "1001" =>                                         --store indirect
			Raddr1<= din(7 downto 4);
			Raddr2<= din(3 downto 0);
			memaddr<= "00000000";
			operation <= "10100";
			dest_reg_en <= '0';
			src_reg1_en <= '1';
			src_reg1 <= din(7 downto 4);
			src_reg2_en <= '1';
			src_reg2 <= din(3 downto 0);
			--reg_rd_en <= '1';
	
		when "1010"=>                                           -- load register
			Raddr1 <= din(11 downto 8);
			Raddr2 <= "0000";
			memaddr <= din(7 downto 0);
			operation <= "10101";
			dest_reg_en <= '1';
			dest_reg <= din(11 downto 8);
			src_reg1_en <= '0';
			src_reg2_en <= '0';
			reg_rd_en <= '0';
			
		when "1011"=>                                             -- store  register
			Raddr1 <= din(11 downto 8);
			Raddr2 <= "0000";
			memaddr <= din(7 downto 0);
			operation <= "10110";
			dest_reg_en <= '0';
			src_reg1_en <= '1';
			src_reg1 <= din(11 downto 8);
			src_reg2_en <= '0';
			--reg_rd_en <= '1';
			
------------------------------------------- Branch Intructions -----------------------------------

		when "1100" =>                                          -- Jump
		  Raddr1 <= X"0";
		  Raddr2 <= X"0";
		  memaddr <= din(7 downto 0);
		  operation <= "10111";
		  dest_reg_en <= '0';
		  src_reg1_en <= '0';
		  src_reg2_en <= '0';
		  reg_rd_en <= '0';
		  
		when "1101" =>                                          -- Branch if Zero
		  Raddr1 <= din(11 downto 8);
		  Raddr2 <= X"0";
		  memaddr <= din(7 downto 0);
		  operation <= "11000";
		  dest_reg_en <= '0';
		  src_reg1_en <= '1';
		  src_reg1 <= din(11 downto 8);
		  src_reg2_en <= '0';
		  --reg_rd_en <= '0';
		  
		when "1110" =>                                          -- Branch if not Zero
		  Raddr1 <= din(11 downto 8);
		  Raddr2 <= X"0";
		  memaddr <= din(7 downto 0);
		  operation <= "11001";
		  dest_reg_en <= '0';
		  src_reg1_en <= '1';
		  src_reg1 <= din(11 downto 8);
		  src_reg2_en <= '0';
		  --reg_rd_en <= '0';
		  
------------------------------------------ Return from Interrupt -----------------------------------
		  
		when "1111" =>                                          -- Return from Interrupt
		  Raddr1 <= "0000";
 		  Raddr2 <= "0000";
      		  memaddr<= "00000000";
	          operation <= "00000";
		  dest_reg_en <= '0';
		  src_reg1_en <= '0';
		  src_reg2_en <= '0';
		  reg_rd_en <= '0';
		  return_from_interrupt <= '1';
		  
---------------------------------------------- Default/Nop ------------------------------------------
		when others =>
		  Raddr1 <= "0000";
      		  Raddr2 <= "0000";
	      	  memaddr<= "00000000";
      		  operation <= "00000";
		  dest_reg_en <= '0';
		  src_reg1_en <= '0';
		  src_reg2_en <= '0';
      		  reg_rd_en <= '0';
      
	  end case;
	end process;
end architecture;


