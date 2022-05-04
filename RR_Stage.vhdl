LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RR_Stage IS
	PORT (
		CLK, RST : IN STD_LOGIC;

	    SEPC_ID, SE_ID : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALU_FM_ID, CWB_ID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID : IN STD_LOGIC

		RF_WREN: IN STD_LOGIC;
		RF_A3: IN std_logic_vector(2 downto 0);
		RF_D3: IN std_logic_vector(15 downto 0);
		
		LSPC_RR, SE_RR, D1_RR, D2_RR: out std_logic_vector(15 downto 0);
		A3_RR, ALU_CS_RR, RF_D3MUX_RR: out std_logic_vector(2 downto 0);
		ALU_FM_RR, CWB_RR: out std_logic_vector(1 downto 0);
		RF_WREN_RR, ALUY_B_CS_RR: out std_logic
	);
END RR_Stage;

ARCHITECTURE behav OF RR_Stage IS
	COMPONENT REG_FILE IS
		PORT (
			CLK, RST : IN STD_LOGIC;
			WR_EN : IN STD_LOGIC;
			RF_A1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RF_A2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RF_A3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RF_D3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			RF_D1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			RF_D2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			R7_D : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			R7_EN : IN STD_LOGIC;
			R7_Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
BEGIN
	A3_RR <= A3_ID;
	ALU_CS_RR <= ALU_CS_ID;
	RF_D3MUX_RR <= RF_D3_MUX_ID;
	SE_RR <= SE_ID;
	ALU_FM_RR <= ALU_FM_ID;
	CWB_RR <= CWB_ID;
	RF_WREN_RR <= RF_WREN_ID;
	ALUY_B_CS_RR <= ALUY_B_CS_ID;

	-- LSPC_RR <= 
	RF: REG_FILE port map (clk => CLK, rst => rst, wr_en => RF_WREN, rf_a1 => A1_ID, rf_a2 => a2_id, rf_a3 => rf_a3, rf_d3 => rf_d3, rf_d1 => D1_RR, rf_d2 => D2_RR);

END ARCHITECTURE; -- arch