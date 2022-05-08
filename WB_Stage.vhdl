library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_Stage is 
    port(
        CLK, RST: in std_logic;
		LSPC_MM, ALU_C_MM, SE_MM, MEM_O_MM, D1_MM: in STD_LOGIC_VECTOR(15 downto 0);
        A3_MM, RF_D3MUX_MM: in STD_LOGIC_VECTOR(2 downto 0);
        OF_MM, F_MM: in STD_LOGIC_VECTOR(1 downto 0);
        RF_WREN_MM: in STD_LOGIC

		rf_d3: out std_logic_vector(15 downto 0);
		rf_a3: out std_logic_vector(2 downto 0);
		rf_wren: out std_logic
    );
end WB_Stage;

architecture pipeline of WB_Stage is

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
    mux_rfd3: mux_4x1_16bit port map(inp_1 => ALU_C_MM, inp_2 => SE_MM, inp_3 => MEM_O_MM, inp_4 => D1_MM, sel => RF_D3MUX_MM(1 downto 0), outp => rf_d3);
	rf_a3 <= a3_mm;
	rf_wren  <= rf_wren_mm;
end architecture;
