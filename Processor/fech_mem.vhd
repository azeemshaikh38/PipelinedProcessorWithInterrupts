library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fetch_mem is
port(
  clk, rst : in std_logic;
  read_addr : in std_logic_vector(7 downto 0);
  data_out : out std_logic_vector(15 downto 0));
end fetch_mem;

architecture mixed of fetch_mem is
  type mem_type is array(255 downto 0) of std_logic_vector(15 downto 0);
  
  signal mem_data : mem_type;
  
  begin
    process(clk, rst)
      begin
	if (rst =  '1') then
		--mem_data(0) <= X"0000"; 
  		--mem_data(1) <= X"A000";                         --load R0 <= Mem(0)         //R0 = 0x0A
  		--mem_data(2) <= X"A101";                         --load R1 <= Mem(1)         //R0 = 0x02
  		--mem_data(3) <= X"2001";                         -- add R0 <= R0 + R1
  		--mem_data(4) <= X"A202";                         --load R2
  		--mem_data(5) <= X"0000";                         --nop
  		--mem_data(6) <= X"2001";                         --add R0 <= R0 + R1         //R0 = 0x0C
  		--mem_data(7) <= X"0000";
  		--mem_data(8) <= X"B000";                         --store Mem(0) <= R0      
  		--mem_data(9) <= X"8021";  
  		
  		--mem_data(4) <= X"A101";                         --load R1 <= Mem(1)         //R1 = 0x02
  		--mem_data(5) <= X"0000";                         --nop 
  		--mem_data(6) <= X"B101";                         --store Mem(1) <= R1  
  		
  		--mem_data(4) <= X"A202";                         --load R2 <= Mem(2)         //R2 = 0x31
  		--mem_data(5) <= X"2001";                         --add R0 <= R0 + R1         //R0 = 0x0C
  		--mem_data(6) <= X"B001";                         --store Mem(1) <= R0        //Mem(1) = 0x0C  		
  		
  		--mem_data(6) <= X"2101";                         --sub R0 <= R0 - R1         //R0 = 0x0B        
  		--mem_data(7) <= X"B001";                         --store Mem(1) <= R0        //Mem(1) = 0x0B
  		--mem_data(8) <= X"9011";                         --store Mem(R1) <= R1       //Mem(49) = 0x31
		--mem_data(9) <= X"A201";                         --load R2 <= Mem(1)         //R2 = 0x0B
		--mem_data(10) <= X"8031";			                     --load R3 <= Mem(R1)        //R3 = 0x31
	  --mem_data(11) <= X"5600";                        --clear R0                  //R0 = 0
	  --mem_data(12) <= X"5710";                        --set R1                    //R1 = 1
	  --mem_data(13) <= X"5F10";                        --if (R1<R0) set R1=1        
	  --mem_data(14) <= X"5F01";                        --if (R0<R1) set R0=1       //R0 = 1
		--mem_data(15) <= X"C000";                        --jump 
		
		mem_data(0) <= X"0000";
  		mem_data(1) <= X"A000";                         --load R0 <= Mem(0)         //R0 = 0x0A
  		mem_data(2) <= X"A101";                         --load R1 <= Mem(1)         //R1 = 0x02
  		mem_data(3) <= X"8011";                         --load R1 <= Mem(R1)        //R1 = 0x31
  		mem_data(4) <= X"1001";                         --add R0 <= R0 + X"01"      //R0 = 0x0B
  		mem_data(5) <= X"2001";                         --add R0 <= R0 + R1         //R0 = 0x3C
  		mem_data(6) <= X"2101";                         --sub R0 <= R0 - R1         //R0 = 0x0B        
  		mem_data(7) <= X"B001";                         --store Mem(1) <= R0        //Mem(1) = 0x0B
  		mem_data(8) <= X"9011";                         --store Mem(R1) <= R1       //Mem(49) = 0x31
		mem_data(9) <= X"A201";                         --load R2 <= Mem(1)         //R2 = 0x0B
		mem_data(10) <= X"8031";			                     --load R3 <= Mem(R1)        //R3 = 0x31
		mem_data(11) <= X"D00F";                        --branch if R0 is zero
	  mem_data(12) <= X"5600";                        --clear R0                  //R0 = 0
	  mem_data(13) <= X"5710";                        --set R1                    //R1 = 1
	  mem_data(14) <= X"E110";                        --branch if R1 is not zero
	  mem_data(15) <= X"5F10";                        --if (R1<R0) set R1=1        
	  mem_data(16) <= X"5F01";                        --if (R0<R1) set R0=1       //R0 = 1
	  mem_data(17) <= X"5831";                        --mv R3, R1                 //R3 = 1                       
		mem_data(18) <= X"C028";                        --jump                      // PC = 40
		mem_data(19) <= X"B300";                         --store Mem(0) <= R3        //Mem(0) = 0x31
		
		mem_data(20) <= X"1001";                         --add R0 <= R0 + X"01"      //R0 = 0x0B
		mem_data(21) <= X"B001";                         --store Mem(1) <= R0        //Mem(1) = 0x0B
		mem_data(22) <= X"F000";                         --Return from interrupt
		
		
		mem_data(32) <= X"2101";                         --sub R0 <= R0 - R1         //R0 = 0x0B  
		mem_data(33) <= X"9011";                         --store Mem(R1) <= R1       //Mem(49) = 0x31 
		mem_data(34) <= X"F000";                         --Return from interrupt
		
 
    mem_data(40) <= X"5403";                         --and R0, R3               //R0 = 1
	end if;

        if falling_edge(clk) then
            data_out <= mem_data(conv_integer(read_addr));
        end if;
      
    end process;
end mixed;
          
