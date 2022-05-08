library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_datapath is
	port(
	CLK, RST: in std_logic
    );
end entity pipe_datapath;

architecture behav of pipe_datapath is
    component IF_Stage is
        port(
            CLK, RST: in std_logic;
            PC_WREN: in std_logic;
            PC_IN: in std_logic_vector(15 downto 0);
            PC_IF, OP_IF, PC_NEXT: out std_logic_vector(15 downto 0)
        );
    end component;

    component ID_Stage is
    PORT(
        CLK, RST : IN STD_LOGIC;
        PC_IF : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP_IF : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        SEPC_ID, SE_ID : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_FM_ID, CWB_ID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID, MEM_WREN_ID : OUT STD_LOGIC
    );
    end component;

    component RR_Stage is
	PORT(
		CLK, RST : IN STD_LOGIC;

	    SEPC_ID, SE_ID : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALU_FM_ID, CWB_ID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID, MEM_WREN_ID : IN STD_LOGIC

		RF_WREN: IN STD_LOGIC;
		RF_A3: IN std_logic_vector(2 downto 0);
		RF_D3: IN std_logic_vector(15 downto 0);
		
		LSPC_RR, SE_RR, D1_RR, D2_RR: out std_logic_vector(15 downto 0);
		A3_RR, ALU_CS_RR, RF_D3MUX_RR: out std_logic_vector(2 downto 0);
		ALU_FM_RR, CWB_RR: out std_logic_vector(1 downto 0);
		RF_WREN_RR, ALUY_B_CS_RR, MEM_WREN_RR: out std_logic
	);
    end component;

    component EX_Stage is
    PORT (
        CLK, RST : IN STD_LOGIC;
        LSPC_RR, SE_RR, D1_RR, D2_RR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        A3_RR, ALU_CS_RR, RF_D3MUX_RR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_FM_RR, CWB_RR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        RF_WREN_RR, ALUY_B_CS_RR, MEM_WREN_RR : IN STD_LOGIC;

        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX : OUT STD_LOGIC;
        A3_EX, RF_D3MUX_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX, MEM_WREN_EX: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
    end component;

    component MM_Stage is 
    port(
        CLK, RST, CLR : in std_logic;
        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX : IN STD_LOGIC;
        A3_EX, RF_D3MUX_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX, MEM_WREN_EX: IN STD_LOGIC_VECTOR(1 DOWNTO 0)

        LSPC_MM, SE_MM, ALU_C_MM, MEM_O_MM, D1_MM: OUT STD_LOGIC_VECTOR(15 downto 0);
        A3_MM, RF_D3MUX_MM: OUT STD_LOGIC_VECTOR(2 downto 0);
        OF_MM, F_MM: OUT STD_LOGIC_VECTOR(1 downto 0);
        RF_WREN_MM: OUT STD_LOGIC;
    );
    end component;

    
    component WB_State is 
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
    end component;
    
    signal PC_NEXT_SIG, PC_IF_SIG, OP_IF_SIG: std_logic_vector(15 downto 0);
    begin
    ifstage: IF_Stage port map(CLK => CLK, RST => RST, PC_WREN => '1', PC_IN => (others => '0'), PC_IF => PC_IF_SIG, OP_IF =>OP_IF_SIG, PC_NEXT => PC_NEXT_SIG);
    idstage: ID_Stage port map(CLK => CLK, RST => RST)

end architecture;