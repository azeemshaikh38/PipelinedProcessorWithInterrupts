library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity pipe_top is
  port(
    clk, rst : in std_logic;
    interrupt_reg_data : in std_logic_vector(7 downto 0);
    interrupt_reg_we : std_logic
    );
  end pipe_top;
  
  architecture top of pipe_top is
    component fetch_mem is
      port(
          clk, rst : in std_logic;
          read_addr : in std_logic_vector(7 downto 0);
          data_out : out std_logic_vector(15 downto 0));
    end component;
    
    component fetch2decode_reg is
      port(
          clk, rst : in std_logic;
	         noop : in std_logic;
          data_in : in std_logic_vector(15 downto 0);
          data_out : out std_logic_vector(15 downto 0));
    end component;
    
    component decode is
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
    end component;
    
    component decode2alu_reg is
       port(
	        clk, rst: in std_logic;
	        noop : in std_logic;
	        A_in : in std_logic_vector(7 downto 0);
	        B_in : in std_logic_vector(7 downto 0);
	        operation_in : in std_logic_vector(4 downto 0);
	        Raddr1_in : in std_logic_vector(3 downto 0);
	        Raddr2_in : in std_logic_vector(3 downto 0);
          Memaddr_in : in std_logic_vector(7 downto 0);
          src_select: in std_logic_vector(1 downto 0);
          ALU_result: in std_logic_vector(7 downto 0);

	        A_out : out std_logic_vector(7 downto 0);
	        B_out : out std_logic_vector(7 downto 0);
	        operation_out : out std_logic_vector(4 downto 0);
	        Raddr1_out : out std_logic_vector(3 downto 0);
	        Raddr2_out : out std_logic_vector(3 downto 0);
	        Memaddr_out : out std_logic_vector(7 downto 0));
      end component;
      
      component ALU is 
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
          mem_wr_en : out std_logic);
      end component;
      
      component ram is
        port(
            data : in std_logic_vector(7 downto 0);
            write_addr : in std_logic_vector(7 downto 0);
            read_addr : in std_logic_vector(7 downto 0);
            w_enable : in std_logic;
            r_enable : in std_logic;
            clk, rst : in std_logic;
            data_out : out std_logic_vector(7 downto 0));
        end component;
        
        component alu2register_reg is
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
  end component;

        
      component register_bank is
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
        end component;
        
        component hazard_control_block is
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
end component;


          
  component selectresult is
  port(
    mem_result : in std_logic_vector(7 downto 0);
    alu_result : in std_logic_vector(7 downto 0);
    select_op : in std_logic_vector(1 downto 0);
    
    result_out : out std_logic_vector(7 downto 0));
  end component;
  
  component interrupt_handler is
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
end component;

component datamux is
  port(
     alu_memdata:in std_logic_vector(7 downto 0);
     intrhandler_data:in std_logic_vector(7 downto 0);
     sel: in std_logic;
     data_out: out std_logic_vector(7 downto 0));
   end component;
   
  component writemux is
  port(
     dec_wr:in std_logic_vector(3 downto 0);
     intr_wr:in std_logic_vector(3 downto 0);
     sel: in std_logic;
     wr_out: out std_logic_vector(3 downto 0));
   end component;
   
   component readmux is
  port(
     dec_raddr1:in std_logic_vector(3 downto 0);
     dec_raddr2:in std_logic_vector(3 downto 0);
     intr_raddr1:in std_logic_vector(3 downto 0);
     intr_raddr2:in std_logic_vector(3 downto 0);
     sel: in std_logic;
     out_raddr1: out std_logic_vector(3 downto 0);
     out_raddr2: out std_logic_vector(3 downto 0));
   end component;
   
   component enable_mux is
  port (
    processor_en, sel : in std_logic;
    en_out : out std_logic
  );
end component;
          
signal fetch2decodereg_instr : std_logic_vector(15 downto 0);
signal decodereg2decode_instr : std_logic_vector(15 downto 0);
signal decode2regbank_re : std_logic;
signal decode2regbank_raddr1 : std_logic_vector(3 downto 0);
signal decode2regbank_raddr2 : std_logic_vector(3 downto 0);
signal decode2alureg_memaddr : std_logic_vector(7 downto 0);
signal decode2alureg_operation : std_logic_vector(4 downto 0);
signal decode2control_destregen : std_logic;
signal decode2control_destreg : std_logic_vector(3 downto 0);
signal decode2control_srcreg1en : std_logic;
signal decode2control_srcreg1 : std_logic_vector(3 downto 0);
signal decode2control_srcreg2en: std_logic;
signal decode2control_srcreg2: std_logic_vector(3 downto 0);
signal regbank2alureg_ain : std_logic_vector(7 downto 0);
signal regbank2alureg_bin : std_logic_vector(7 downto 0);
signal alureg2alu_aout : std_logic_vector(7 downto 0);
signal alureg2alu_bout : std_logic_vector(7 downto 0);
signal	alureg2alu_operationout : std_logic_vector(4 downto 0);
signal	alureg2alu_raddr1out : std_logic_vector(3 downto 0);
signal	alureg2alu_raddr2out : std_logic_vector(3 downto 0);
signal	alureg2alu_memaddrout : std_logic_vector(7 downto 0);
signal alu2mem_memaddrout : std_logic_vector(7 downto 0);
signal alu2mem_memrden : std_logic;
signal alu2mem_memwren : std_logic;
signal alu2mem_result : std_logic_vector(7 downto 0);
signal alu2reg_result : std_logic_vector(7 downto 0);
signal alu2reg_op : std_logic_vector(1 downto 0);
signal alu2reg_regwren : std_logic;
signal alu2reg_raddr : std_logic_vector(3 downto 0);
signal alu2control_branch : std_logic;
signal alu2control_branchoffset : std_logic_vector(7 downto 0);
signal alu2control_operation : std_logic_vector(4 downto 0);
signal control2fetch_pc : std_logic_vector(7 downto 0);
signal control2decodealu_noop : std_logic;
--signal control2alu_noop : std_logic;
signal decode2alureg_raddr1 : std_logic_vector(3 downto 0);
signal decode2alureg_raddr2 : std_logic_vector(3 downto 0);
signal regreg2register_raddr : std_logic_vector(3 downto 0);
signal regreg2register_wre : std_logic;
signal regreg2register_op : std_logic_vector(1 downto 0);
signal regreg2select_aluresult : std_logic_vector(7 downto 0);
signal mem2select_result : std_logic_vector(7 downto 0);
signal select2regbank_data : std_logic_vector(7 downto 0);
signal control2decodealureg_srcselect : std_logic_vector(1 downto 0);
signal interhandler2readaddrmux_raddr1, interhandler2readaddrmux_raddr2 : std_logic_vector(3 downto 0); 
signal intrhandler2readaddrmux_re, intrhandler2writeaddrmux_we : std_logic;
signal intrhandler2writedatamux_data : std_logic_vector(7 downto 0);
signal control2intrhandler_PC : std_logic_vector(7 downto 0);
signal intrhandler2control_PC : std_logic_vector(7 downto 0);
signal intrhandler2control_happened, intrhandler2control_handled : std_logic;
signal intrmux2regbank_data : std_logic_vector(7 downto 0);
signal intrmux2regbank_writeaddr : std_logic_vector(3 downto 0);
signal intrmux2regbank_raddr1, intrmux2regbank_raddr2 : std_logic_vector(3 downto 0);
signal intrmux2regbank_we, intrmux2regbank_re : std_logic;
signal intrhandler2readraddrmux_re : std_logic;
signal decode2intrhandler_return : std_logic;
signal intrhandler2regbank_writeaddr : std_logic_vector(3 downto 0);
signal fetch2intrhandler_return : std_logic;

begin
  
  fetch2intrhandler_return <= (fetch2decodereg_instr(15) and fetch2decodereg_instr(14) and fetch2decodereg_instr(13) and fetch2decodereg_instr(12));
  
  fetch : fetch_mem port map(
          clk => clk,
          rst => rst,
          read_addr => control2fetch_pc,
          data_out => fetch2decodereg_instr);
          
  decodereg : fetch2decode_reg port map(
              clk => clk,
              rst => rst,
              noop => control2decodealu_noop,
              data_in => fetch2decodereg_instr,
              data_out => decodereg2decode_instr);
              
  decoder : decode port map(
            din => decodereg2decode_instr,
            reg_rd_en => decode2regbank_re,
            Raddr1 => decode2regbank_raddr1,
            Raddr2 => decode2regbank_raddr2,  
            memaddr => decode2alureg_memaddr,
            operation => decode2alureg_operation,
            dest_reg_en => decode2control_destregen,
            dest_reg => decode2control_destreg,
            src_reg1_en => decode2control_srcreg1en,
            src_reg1 => decode2control_srcreg1,
            src_reg2_en => decode2control_srcreg2en,
            src_reg2 => decode2control_srcreg2,
            return_from_interrupt => decode2intrhandler_return);
            
    decode2alureg : decode2alu_reg port map(
                    clk => clk,
                    rst => rst,
                    noop => control2decodealu_noop,
                    A_in => regbank2alureg_ain,
                    B_in => regbank2alureg_bin,
                    operation_in => decode2alureg_operation,
                    Raddr1_in => decode2regbank_raddr1,
                    Raddr2_in => decode2regbank_raddr2,
                    Memaddr_in => decode2alureg_memaddr,
                    src_select => control2decodealureg_srcselect, 
                    ALU_result => select2regbank_data,
                    A_out => alureg2alu_aout,
                    B_out => alureg2alu_bout,
                    operation_out => alureg2alu_operationout,
                    Raddr1_out => alureg2alu_raddr1out,
                    Raddr2_out => alureg2alu_raddr2out,
                    Memaddr_out => alureg2alu_memaddrout);
                    
      control : hazard_control_block port map(
                dest_reg_en => decode2control_destregen,
                dest_reg => decode2control_destreg,
                src_reg1_en => decode2control_srcreg1en,
                src_reg1 => decode2control_srcreg1,
                src_reg2_en => decode2control_srcreg2en,
                src_reg2 => decode2control_srcreg2,
                handlerPC => intrhandler2control_PC,
                nop => control2decodealu_noop,
                interrupt_happened => intrhandler2control_happened,
                interrupt_handled => intrhandler2control_handled,
                src_select => control2decodealureg_srcselect,
                PC => control2fetch_pc,
                branch => alu2control_branch,
                branch_addr => alu2control_branchoffset,
                operation => alu2control_operation,
                clk => clk,
                PC2handler => control2intrhandler_PC,
                rst => rst);
                
      alupart : ALU port map(
            A => alureg2alu_aout,
            B => alureg2alu_bout,
            operation => alureg2alu_operationout,
            Raddr1 => alureg2alu_raddr1out,
            Raddr2 => alureg2alu_raddr2out,
            Memaddr_in => alureg2alu_memaddrout,
            MemAddr_out => alu2mem_memaddrout,
            Raddr => alu2reg_raddr,
            op => alu2reg_op,
            result => alu2reg_result,
            branch => alu2control_branch,
            branch_offset => alu2control_branchoffset,
            mem_rd_en => alu2mem_memrden,
            reg_wr_en => alu2reg_regwren,
            mem_wr_en => alu2mem_memwren);
            
      aluregister : alu2register_reg port map(
                    clk => clk,
                    rst => rst,
                    raddr_in => alu2reg_raddr,
                    op_in => alu2reg_op,
                    result_in => alu2reg_result,
                    reg_wr_en_in => alu2reg_regwren,
                    raddr_out => regreg2register_raddr,
                    op_out => regreg2register_op,
                    result_out => regreg2select_aluresult,
                    reg_wr_en_out => regreg2register_wre);
                    
                        
       ram_init : ram port map(
                  data => alu2reg_result,
                  write_addr => alu2mem_memaddrout,
                  read_addr => alu2mem_memaddrout,
                  w_enable => alu2mem_memwren,
                  r_enable => alu2mem_memrden,
                  clk => clk,
                  rst => rst,
                  data_out => mem2select_result);
                  
        registerbank : register_bank port map(
                       clk => clk,
                       rst => rst,
                       data => intrmux2regbank_data,
                       write_addr => intrmux2regbank_writeaddr,
                       read_addr1 => intrmux2regbank_raddr1,
                       read_addr2 => intrmux2regbank_raddr2,
                       w_enable => intrmux2regbank_we,
                       r_enable => intrmux2regbank_re,
                       data_out1 => regbank2alureg_ain,
                       data_out2 => regbank2alureg_bin);
                       
        interrupt_handler1 : interrupt_handler 
	port map (
		data_in1 => regbank2alureg_ain, 
		data_in2 => regbank2alureg_bin,
		raddr1 => interhandler2readaddrmux_raddr1, 
		raddr2 => interhandler2readaddrmux_raddr2,
		raddr_write => intrhandler2regbank_writeaddr,
		reg_re => intrhandler2readraddrmux_re, 
		reg_we => intrhandler2writeaddrmux_we,
		data_out => intrhandler2writedatamux_data,
		PC_in => control2intrhandler_PC,
		PC_out => intrhandler2control_PC,
		interrupt_reg_data => interrupt_reg_data,
		interrupt_reg_we => interrupt_reg_we,
		interrupt_or_return_happened => intrhandler2control_happened, 
		interrupt_or_return_handled => intrhandler2control_handled,
		return_opcode => fetch2intrhandler_return,
		clk => clk, 
		rst => rst
	);

resultselect : selectresult port map(
                      mem_result => mem2select_result,
                      alu_result => regreg2select_aluresult,
                      select_op => regreg2register_op,
                      result_out => select2regbank_data);
                      
regbank_writedata_mux : datamux 
  port map (
     alu_memdata => select2regbank_data,
     intrhandler_data => intrhandler2writedatamux_data,
     sel => intrhandler2writeaddrmux_we,
     data_out => intrmux2regbank_data);

regbank_writeaddr_mux : writemux 
  port map (
     dec_wr => alu2reg_raddr,
     intr_wr => intrhandler2regbank_writeaddr,
     sel => intrhandler2writeaddrmux_we,
     wr_out => intrmux2regbank_writeaddr);

regbank_readaddr_mux : readmux 
  port map(
     dec_raddr1 => decode2regbank_raddr1,
     dec_raddr2 => decode2regbank_raddr2,
     intr_raddr1 => interhandler2readaddrmux_raddr1,
     intr_raddr2 => interhandler2readaddrmux_raddr2,
     sel => intrhandler2readraddrmux_re,
     out_raddr1 => intrmux2regbank_raddr1,
     out_raddr2 => intrmux2regbank_raddr2);
  
  read_en_mux : enable_mux
    port map (
      processor_en => decode2regbank_re,
      sel => intrhandler2readraddrmux_re,
      en_out => intrmux2regbank_re
    );
  
  write_en_mux : enable_mux
    port map (
      processor_en => alu2reg_regwren,
      sel => intrhandler2writeaddrmux_we,
      en_out => intrmux2regbank_we
    );
    
end top;
                     
                       
            
                    
      


      
