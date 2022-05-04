library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_State is 
    port(
        CLK, RST, CLR : in std_logic;
        C_EN, Z_EN, TZ_EN : in std_logic;
        AR3_WB: in std_logic_vector(2 downto 0);
        FC_WB: in std_logic_vector(2 downto 0);
        CL_WB: in std_logic_vector(7 downto 0);
        WR_WB: in std_logic_vector(1 downto 0);
		r7_select : in std_logic_vector(1 downto 0);
		r7_write : in std_logic;
		BLUT_WB, OP_WB : in std_logic_vector(3 downto 0);
        C_in, Z_in, TZ_in: in std_logic;
		R7_in, LS_PC_WB, SE_WB, ALU_out_WB, mem_out_WB, DO1_WB, PCpp_WB: in std_logic_vector(15 downto 0);   
        TZ_flag: out std_logic;
        C_flag: out std_logic;
        Z_flag: out std_logic;
        D3_data: out std_logic_vector(15 downto 0) 
    );
end WB_State;

architecture pipeline of WB_State is

component mux_8x1_16bit is
port (
     inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
	 inp_3 : in std_logic_vector (15 downto 0);
	 inp_4 : in std_logic_vector (15 downto 0);
	 inp_5 : in std_logic_vector (15 downto 0);
	 inp_6 : in std_logic_vector (15 downto 0);
	 inp_7 : in std_logic_vector (15 downto 0);
	 inp_8 : in std_logic_vector (15 downto 0);
     outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic_vector(2 downto 0)
  );
end component mux_8x1_16bit;

component mux_4x1_16bit is
port (
     inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
	 inp_3 : in std_logic_vector (15 downto 0);
	 inp_4 : in std_logic_vector (15 downto 0);
     outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic_vector(1 downto 0)
  );
end component mux_4x1_16bit;

component mux_2x1_16bit is
port (
     inp_1 : in std_logic_vector (15 downto 0);
	 inp_2 : in std_logic_vector (15 downto 0);
     outp : out std_logic_vector (15 downto 0);
	 sel : in std_logic
  );
end component mux_2x1_16bit;
 
--signal clear_control_MM_WB : std_logic;
--signal R7_write, top_mux_WB_control, hazard_WB_clear : std_logic;
--signal top_mux_WB_data : std_logic_vector(15 downto 0);

begin
    mux_1: mux_8x1_16bit port map(inp_1 => ALU_out_WB, inp_2 => LS_PC_WB, inp_3 => SE_WB, inp_4 => PCpp_WB, inp_5 => mem_out_WB,
        inp_6 => mem_out_WB, inp_7 => mem_out_WB, inp_8 => mem_out_WB, sel => CL_WB, outp => D3_data
    );
	
    mux_2: mux_4x1_16bit port map(inp_1 => DO1_WB, inp_2 => PCpp_WB, inp_3 => LS_PC_WB, inp_4 => LS_PC_WB, sel => r7_select, outp => R7_in);
	
	R7_write <= CL_WB(7) and R7_write_temp;

	-- hazard_WB_instance : hazard_conditional_WB port map(
    --     AR3_MM_WB => AR3_WB, MM_WB_LS_PC => LS_PC_WB, MM_WB_PC_inc => PCpp_WB, MM_WB_valid => CL_WB(6 downto 4),
    --     r7_write => R7_write_temp, r7_select => r7_select, top_WB_mux_control => top_mux_WB_control, clear => hazard_WB_clear,  
    --     top_WB_mux_data => top_mux_WB_data, is_taken => BLUT_WB(0), opcode => OP_WB
    -- ); 
		
	mux_3: mux_2x1_16bit port map (inp_1 => top_mux_MM, inp_2 => top_mux_WB_data, sel => top_mux_WB_control, outp => PC_in);
	
	-- OV_instance: my_reg
	-- 	generic map(1)
	-- 	port map(
	-- 		clk => clk, clr => reset, ena => FC_WB(2),
	-- 		Din => flags_WB(2 downto 2), Dout => flags_user(2 downto 2));
	
	-- C_instance: my_reg
	-- 	generic map(1)
	-- 	port map(
	-- 		clk => clk, clr => reset, ena => FC_WB(1),
	-- 		Din => flags_WB(1 downto 1), Dout => flags_user(1 downto 1));
			
	-- Z_instance: my_reg
	-- 	generic map(1)
	-- 	port map(
	-- 		clk => clk, clr => reset, ena => FC_WB(0),
	-- 		Din => flags_WB(0 downto 0), Dout => flags_user(0 downto 0));
            
    flag_C: FF1 port map(D => C_in, EN => C_EN, RST => RST, CLK => CLK, Q => C_flag);
	flag_Z: FF1 port map(D => Z_in, EN => Z_EN, RST => RST, CLK => CLK, Q => Z_flag);
    flag_TZ: FF1 port map(D => TZ_in, EN => TZ_EN, RST => RST, CLK => CLK, Q => TZ_flag);
end architecture;
