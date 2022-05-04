library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MM_Stage is 
    port(
        CLK, RST, CLR : in std_logic;
        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX : IN STD_LOGIC;
        A3_EX, RF_D3MUX_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0)

        LSPC_MM, SE_MM, ALU_C_MM, MEM_O_MM, D1_MM: OUT STD_LOGIC_VECTOR(15 downto 0);
        A3_MM, RF_D3MUX_MM: OUT STD_LOGIC_VECTOR(2 downto 0);
        OF_MM, F_MM: OUT STD_LOGIC_VECTOR(1 downto 0);
        RF_WREN_MM: OUT STD_LOGIC;
    );
end MM_Stage;

architecture pipeline of MM_Stage is
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

begin
    RF_WREN_MM <= RF_WREN_EX;
    F_MM <= F_EX; 
    OF_MM <= OF_EX; 
    RF_D3MUX_MM <= RF_D3MUX_EX;
    A3_MM <= A3_EX;
    D1_MM <= D1_EX;
    ALU_C_MM <= ALU_C_EX;
    SE_MM <= SE_EX;
    LSPC_MM <= LSPC_EX;
    
	data_mem: MEMORY port map(
        DATA => D2_EX, OUTP => mem_out, ADDR => ALU_C_EX, CLK => CLK,
        WR_Enable => RF_WREN, RW_Enable => '1'
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