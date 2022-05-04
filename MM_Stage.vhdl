library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MM_State is 
    port(
        CLK, RST, CLR : in std_logic;
        DO1_MM : in std_logic_vector(15 downto 0);
        DO2_MM : in std_logic_vector(15 downto 0);
        ALU_out_MM: in std_logic_vector(15 downto 0);
        WR_MM: in std_logic_vector(1 downto 0)
    );
end MM_State;

architecture pipeline of MM_State is
    component mux_2x1_16bit is
    port (
        inp_1 : in std_logic_vector (15 downto 0);
        inp_2 : in std_logic_vector (15 downto 0);
        outp : out std_logic_vector (15 downto 0);
        sel : in std_logic
    );
    end component mux_2x1_16bit;

    component MEMORY is
	port(
        CLK, WR_Enable, RW_Enable: in std_logic;
        ADDR: in std_logic_vector(15 downto 0);
        DATA: in std_logic_vector(15 downto 0);
        OUTP: out std_logic_vector(15 downto 0)
	);
    end component MEMORY;
    signal mem_address: std_logic_vector(15 downto 0);
    signal mem_data: std_logic_vector(15 downto 0);

begin
    mux_1: mux_2x1_16bit port map(inp_1 => ALU_out_MM, inp_2 => DO1_MM, sel => CL_MM(7), outp => mem_address);
	mux_2: mux_2x1_16bit port map(inp_1 => DO2_MM, inp_2 => mem_out_WB, sel => forward_mux_control_MM, outp => mem_data);
	--mux_3: mux_2x1_16bit port map(inp_1 => top_mux_EX, inp_2 => mem_out, sel => top_mux_MM_control);
    
	data_mem: MEMORY port map(
        DATA => mem_data, OUTP => mem_out, ADDR => mem_address, CLK => CLK,
        WR_Enable => WR_MM(0), RW_Enable => '1'
    );
	-- -- Hazard MM block
	-- hazard_MM_instance : hazard_MM
	-- 	port map(
	-- 		EX_MM_AR3 => AR3_MM, EX_MM_valid => CL_MM(6 downto 4), EX_MM_mux_control => CL_MM(3 downto 1),
	-- 		EX_MM_flags => flags_MM, m_out => mem_out, MM_flags_out => flags_MM_hazard, top_MM_mux => top_mux_MM_control,
	-- 		clear => hazard_MM_clear);
	
	-- -- Memory forwarding block
	-- memory_forwarding_instance : mm_forwarding
	-- 	port map(
	-- 		EX_MM_AR2 => AR2_MM, MM_WB_AR3 => AR3_WB, op_MM_WB => OP_WB, op_EX_MM => OP_MM,
	-- 		EX_MM_AR2_valid => CL_MM(5), MM_WB_AR3_valid => CL_WB(4), mem_forward_mux => forward_mux_control_MM,
	-- 		clk => clk);
end architecture;