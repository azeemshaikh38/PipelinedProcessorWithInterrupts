library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity ALU is 
  port (
    A : in std_logic_vector(7 downto 0);
    B : in std_logic_vector(7 downto 0);
    operation : in std_logic_vector(4 downto 0);
    Raddr1 : in std_logic_vector(3 downto 0);
    Raddr2 : in std_logic_vector(3 downto 0);
    Memaddr_in : in std_logic_vector(7 downto 0);
    
    MemAddr_out : out std_logic_vector(7 downto 0);
    Raddr : out std_logic_vector(3 downto 0);
    op : out std_logic_vector(1 downto 0);
    result : out std_logic_vector(7 downto 0);
    branch : out std_logic;
    branch_offset : out std_logic_vector(7 downto 0);
    mem_rd_en : out std_logic;
    reg_wr_en : out std_logic;
    mem_wr_en : out std_logic
  );
end entity;

architecture struct of ALU is
begin
        
process(A, B, operation, Raddr1, Raddr2, Memaddr_in)
  begin
	case operation is
      		when conv_std_logic_vector(0, 5) =>              --nop         
        		MemAddr_out <= X"00";
        		Raddr <= X"0";
        		op <= "00";
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		mem_wr_en <= '0';
        		mem_rd_en <= '0';
        		reg_wr_en <= '0';
        		
      		when conv_std_logic_vector(1, 5) =>              --Add immediate
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A + MemAddr_in;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(2, 5) =>              --Add
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A + B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(3, 5) =>              --Sub
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A - B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(4, 5) =>              --Incr
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A + 1;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(5, 5) =>              --Decr
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A - 1;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(6, 5) =>              --Shift left
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		--result <= shl((unsigned(A); 1);
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(7, 5) =>              --Shift right
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		--result <= conv_std_logic_vector((unsigned(A) srl 1), 8);
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(8, 5) =>              --Not
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= not(A);
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(9, 5) =>              --Nor
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A nor B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(10, 5) =>             --Nand
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A nand B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(11, 5) =>             --Xor
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A xor B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(12, 5) =>             --And
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A and B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(13, 5) =>             --Or
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= A or B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(14, 5) =>             --Clear
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(15, 5) =>             --Set
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= X"FF";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(16, 5) =>             --Set if less than
      		  if (A < B) then
        		  MemAddr_out <= X"00";
        		  Raddr <= Raddr1;
        		  op <= "01";
        		  result <= X"FF";
        		  reg_wr_en <= '1';
      		  else
      		    MemAddr_out <= X"00";
      		    Raddr <= Raddr1;
      		    op <= "01";
      		    result <= A;
      		    reg_wr_en <= '0';
      		  end if;
      		  branch <= '0';
        		branch_offset <= X"00";
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(17, 5) =>             --Move
        		MemAddr_out <= X"00";
        		Raddr <= Raddr1;
        		op <= "01";
        		result <= B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(18, 5) =>             --Enable Interrupt
        		MemAddr_out <= X"00";
        		Raddr <= X"0";
        		op <= "01";
        		result <= A xor B;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(19, 5) =>             --Load Indirect
        		MemAddr_out <= B;
        		Raddr <= Raddr1;
        		op <= "10";
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '1';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(20, 5) =>             --Store Indirect
        		MemAddr_out <= B;
        		Raddr <= Raddr1;
        		op <= "11";
        		result <= A;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '1';
        		
      		when conv_std_logic_vector(21, 5) =>             --Load Register
      		  report "ALU Load Register " & integer'image(conv_integer(MemAddr_in)) & " " & integer'image(conv_integer(Raddr1));
        		MemAddr_out <= MemAddr_in;
        		Raddr <= Raddr1;
        		op <= "10";
        		result <= X"00";
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '1';
        		mem_rd_en <= '1';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(22, 5) =>             --Store Register
        		MemAddr_out <= MemAddr_in;
        		Raddr <= Raddr1;
        		op <= "11";
        		result <= A;
        		branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '1';
        		
      		when conv_std_logic_vector(23, 5) =>             --Jump
        		MemAddr_out <= X"00";
        		Raddr <= X"0";
        		op <= "00";
        		result <= X"00";
        		branch <= '1';
        		branch_offset <= MemAddr_in;
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(24, 5) =>             --Branch if Zero
      		  if (A = X"00") then
        		  MemAddr_out <= X"00";
        		  Raddr <= X"0";
        		  op <= "00";
        		  result <= X"00";
        		  branch <= '1';
        		  branch_offset <= MemAddr_in;
      		  else
		        MemAddr_out <= X"00";
        		  Raddr <= X"0";
        		  op <= "00";
        		  result <= X"00";
        		  branch <= '0';
        		  branch_offset <= X"00";
      		  end if;
      		  reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(25, 5) =>             --Branch if not Zero
    		    if (A /= X"00") then
        		  MemAddr_out <= X"00";
      		    Raddr <= X"0";
        		  op <= "00";
        		  result <= X"00";
        		  branch <= '1';
        		  branch_offset <= MemAddr_in;
      		  else
      		    MemAddr_out <= X"00";
      		    Raddr <= X"0";
        		  op <= "00";
        		  result <= X"00";
        		  branch <= '0';
        		  branch_offset <= X"00";
      		  end if;
      		  reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when conv_std_logic_vector(26, 5) =>             --Return from interrupt
        		MemAddr_out <= X"00";
        		Raddr <= X"0";
        		op <= "00";
        		result <= X"00";    
        		branch <= '1';
        		branch_offset <= X"00";
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
        		
      		when others =>                                   --Default
      		  MemAddr_out <= X"00";
      		  Raddr <= X"0";
      		  op <= "00";
      		  result <= X"00";
      		  branch <= '0';
        		branch_offset <= X"00";
        		reg_wr_en <= '0';
        		mem_rd_en <= '0';
        		mem_wr_en <= '0';
      	end case;
    	end process;
end architecture;
