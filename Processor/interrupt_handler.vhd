library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

entity interrupt_handler is
	port (
		data_in1, data_in2 : in std_logic_vector(7 downto 0);
		raddr1, raddr2 : inout std_logic_vector(3 downto 0);
		raddr_write : out std_logic_vector(3 downto 0);
		reg_re, reg_we : out std_logic;
		data_out : out std_logic_vector(7 downto 0);
		PC_in : in std_logic_vector(7 downto 0);
		PC_out : out std_logic_vector(7 downto 0);
		interrupt_reg_data : in std_logic_vector(7 downto 0);
		interrupt_reg_we : in std_logic;
		interrupt_or_return_happened, interrupt_or_return_handled : out std_logic;
		return_opcode : in std_logic;
		clk, rst : in std_logic
	);
end entity;

architecture behav of interrupt_handler is

signal interrupt_reg : std_logic_vector(7 downto 0);
signal count : integer range 0 to 20;
signal scratch_PC : std_logic_vector(7 downto 0);
signal scratch_interrupt_reg : std_logic_vector(7 downto 0);
signal raddr1_out, raddr2_out, raddr_read : std_logic_vector(3 downto 0);
signal re, we, rise_we : std_logic;
signal interrupt_happened, interrupt_handled, return_happened, return_handled : std_logic;

component scratch_pad is
	port (
		data_in1, data_in2 : in std_logic_vector(7 downto 0);
		raddr_write1, raddr_write2 : in std_logic_vector(3 downto 0);
		data_out : out std_logic_vector(7 downto 0);
		raddr_read : in std_logic_vector(3 downto 0);
		re, we, clk : in std_logic	
	);
end component;


begin

scratch_pad1 : scratch_pad 
		port map (
			data_in1 => data_in1,
			data_in2 => data_in2,
			raddr_write1 => raddr1_out,
			raddr_write2 => raddr2_out,
			data_out => data_out,
			raddr_read => raddr_read,
			re => re,
			we => we,
			clk => clk
		);

	process (clk, rst) is
	variable verify : std_logic_vector(3 downto 0);
	variable tmp_sr: std_logic_vector(7 downto 0);
	variable tmp_scratch_interrupt_reg : std_logic_vector(7 downto 0);
	begin
	if (rst = '1') then
		interrupt_reg <= X"00";
		interrupt_happened <= '0';
		interrupt_handled <= '0';
		return_happened <= '0';
		return_handled <= '0';
	elsif (rising_edge(clk)) then
		verify := interrupt_reg(7 downto 4) and interrupt_reg(3 downto 0);
		if (interrupt_happened = '0') then
			if (verify /= "0000") then
				interrupt_happened <= '1';
				interrupt_handled <= '0';
				return_happened <= '0';
				return_handled <= '0';
				count <= 0;
				scratch_PC <= PC_in;

				if (verify(3) = '1') then
					PC_out <= "00010100";
					scratch_interrupt_reg <= (interrupt_reg and "01111111" );
					interrupt_reg <= ("00000000" );
				elsif (verify(2) = '1') then
					PC_out <= "00100000";
					scratch_interrupt_reg <= (interrupt_reg and "10111111" );
					interrupt_reg <= ("00000000");
				elsif (verify(1) = '1') then
					PC_out <= "01000000";
					scratch_interrupt_reg <= (interrupt_reg and "11011111" );
					interrupt_reg <= ( "00000000" );
				elsif (verify(0) = '1') then
					PC_out <= "10000000";
					scratch_interrupt_reg <= (interrupt_reg and "11101111" );
					interrupt_reg <= ("00000000");
				end if;
			end if;
		elsif (interrupt_handled = '0') then
			if (count = 0) then
				count <= count + 1;
			elsif (count = 1) then
				count <= count + 1;
				raddr1 <= X"0";
				raddr2 <= X"1";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 2) then
				count <= count + 1;
				raddr1 <= X"2";
				raddr2 <= X"3";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 3) then
				count <= count + 1;
				raddr1 <= X"4";
				raddr2 <= X"5";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 4) then
				count <= count + 1;
				raddr1 <= X"6";
				raddr2 <= X"7";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 5) then
				count <= count + 1;
				raddr1 <= X"8";
				raddr2 <= X"9";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 6) then
				count <= count + 1;
				raddr1 <= X"A";
				raddr2 <= X"B";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 7) then
				count <= count + 1;
				raddr1 <= X"C";
				raddr2 <= X"D";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 8) then
				count <= 9;
				raddr1 <= X"E";
				raddr2 <= X"F";
				reg_re <= '1';
				rise_we <= '1';
			elsif (count = 9) then
				interrupt_handled <= '1';
				interrupt_happened <= '0';
				reg_re <= '0';
				reg_we <= '0';
				we <= '0';				
				re <= '0';
				rise_we <= '0';
			end if;
		end if;
--------------------------------------------------------------------------- checking for next interrupt
		if (return_opcode = '1') then
			return_happened <= '1';
			return_handled <= '0';
			interrupt_happened <= '0';
			interrupt_handled <= '0'; 
			count <= 0;
		elsif (return_happened = '1') then
		  	report "Return from interrupt";
			tmp_sr := interrupt_reg or scratch_interrupt_reg;
			verify := tmp_sr(7 downto 4) and tmp_sr(3 downto 0);
			if (verify /= "0000") then
			  if (count = 0) then
			    	  if (verify(3) = '1') then
					   PC_out <= "00010100";
					   tmp_scratch_interrupt_reg := (tmp_sr and "01111111" );
					   --interrupt_reg <= ("00000000" );
				  elsif (verify(2) = '1') then
					   PC_out <= "00100000";
					   tmp_scratch_interrupt_reg := (tmp_sr and "10111111" );
				  	  --interrupt_reg <= ("00000000");
				  elsif (verify(1) = '1') then
					   PC_out <= "01000000";
					   tmp_scratch_interrupt_reg := (tmp_sr and "11011111" );
					   --interrupt_reg <= ( "00000000" );
				  elsif (verify(0) = '1') then
					   PC_out <= "10000000";
					   tmp_scratch_interrupt_reg := (tmp_sr and "11101111" );
					   --interrupt_reg <= ("00000000");
				  end if;
			    	  count <= count + 1;
			  elsif (count = 1) then
			    	  count  <= count + 1;
			  elsif (count = 2) then
				  return_happened <= '0';
				  return_handled <= '1';
				  count <= 0;
				  interrupt_reg <= X"00";
				  scratch_interrupt_reg <= tmp_scratch_interrupt_reg;
			  end if;
			else
			  report "No interrupt. Return to normal";
				if (count = 0) then
					count <= count + 1;
					PC_out <= scratch_PC;
					interrupt_reg <= interrupt_reg or scratch_interrupt_reg;
					report "count = 0";
				elsif (count = 1) then
					count <= count + 1;
					raddr_read <= X"0";
					rise_we <= '1';
					re <= '1';
				elsif (count = 2) then
					count <= count + 1;
					raddr_read <= X"1";
					rise_we <= '1';
					re <= '1';
				elsif (count = 3) then
					count <= count + 1;
					raddr_read <= X"2";
					rise_we <= '1';
					re <= '1';
				elsif (count = 4) then
					count <= count + 1;
					raddr_read <= X"3";
					rise_we <= '1';
					re <= '1';
				elsif (count = 5) then
					count <= count + 1;
					raddr_read <= X"4";
					rise_we <= '1';
					re <= '1';
				elsif (count = 6) then
					count <= count + 1;
					raddr_read <= X"5";
					rise_we <= '1';
					re <= '1';
				elsif (count = 7) then
					count <= count + 1;
					raddr_read <= X"6";
					rise_we <= '1';
					re <= '1';
				elsif (count = 8) then
					count <= count + 1;
					raddr_read <= X"7";
					rise_we <= '1';
					re <= '1';
				elsif (count = 9) then
					count <= count + 1;
					raddr_read <= X"8";
					rise_we <= '1';
					re <= '1';
				elsif (count = 10) then
					count <= count + 1;
					raddr_read <= X"9";
					rise_we <= '1';
					re <= '1';
				elsif (count = 11) then
					count <= count + 1;
					raddr_read <= X"A";
					rise_we <= '1';
					re <= '1';
				elsif (count = 12) then
					count <= count + 1;
					raddr_read <= X"B";
					rise_we <= '1';
					re <= '1';
				elsif (count = 13) then
					count <= count + 1;
					raddr_read <= X"C";
					rise_we <= '1';
					re <= '1';
				elsif (count = 14) then
					count <= count + 1;
					raddr_read <= X"D";
					rise_we <= '1';
					re <= '1';
				elsif (count = 15) then
					count <= count + 1;
					raddr_read <= X"E";
					rise_we <= '1';
					re <= '1';
				elsif (count = 16) then
					count <= count + 1;
					raddr_read <= X"F";
					rise_we <= '1';
					re <= '1';
				elsif (count = 17) then
					count <= 0;
					return_happened <= '0';
					return_handled <= '1';
					reg_we <= '0';
					reg_re <= '0';
					re <= '0';
					we <= '0';
					rise_we <= '0';
				end if;
			end if;
		end if;
	elsif (falling_edge(clk)) then
		if (interrupt_reg_we = '1') then
				interrupt_reg <= interrupt_reg or interrupt_reg_data;
		end if;
		
		if ((interrupt_happened = '1') and (interrupt_handled = '0')) then
			raddr1_out <= raddr1;
			raddr2_out <= raddr2;
			we <= rise_we;
		end if;

		if ((return_happened = '1') and (return_handled = '0')) then
			raddr_write <= raddr_read;
			reg_we <= rise_we;
		end if;
	end if;	
	end process;

	process (interrupt_happened, interrupt_handled, return_happened, return_handled)
	begin
		interrupt_or_return_happened <= interrupt_happened or return_happened;
		interrupt_or_return_handled <= interrupt_handled or return_handled;
	end process;
end architecture;
