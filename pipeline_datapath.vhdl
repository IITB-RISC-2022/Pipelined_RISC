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

        SEPC_ID, SE_ID, LS_ID: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_FM_ID, CWB_ID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID, MEM_WREN_ID : OUT STD_LOGIC
    );
    end component;

    component RR_Stage is
	PORT(
		CLK, RST : IN STD_LOGIC;

	    SEPC_ID, SE_ID, LS_ID: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALU_FM_ID, CWB_ID : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID, MEM_WREN_ID : IN STD_LOGIC;

		RF_WREN: IN STD_LOGIC;
		RF_A3: IN std_logic_vector(2 downto 0);
		RF_D3: IN std_logic_vector(15 downto 0);

		LSPC_RR, SE_RR, D1_RR, D2_RR, LS_RR: out std_logic_vector(15 downto 0);
		A3_RR, ALU_CS_RR, RF_D3MUX_RR, A1_RR, A2_RR: out std_logic_vector(2 downto 0);
		ALU_FM_RR, CWB_RR: out std_logic_vector(1 downto 0);
		RF_WREN_RR, ALUY_B_CS_RR, MEM_WREN_RR: out std_logic
	);
    end component;

    component EX_Stage is
    PORT (
        CLK, RST : IN STD_LOGIC;
        LSPC_RR, SE_RR, D1_RR, D2_RR, LS_RR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        A3_RR, ALU_CS_RR, RF_D3MUX_RR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_FM_RR, CWB_RR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        RF_WREN_RR, ALUY_B_CS_RR, MEM_WREN_RR : IN STD_LOGIC;

        -- forwarding inputs
        aluy_out_fwd: in std_logic_vector(15 downto 0);
        d1_fmux, d2_fmux: in std_logic;

        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX, LS_EX: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX,  MEM_WREN_EX: OUT STD_LOGIC;
        A3_EX, RF_D3MUX_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
    end component;

    component MM_Stage is 
    port(
        CLK, RST: in std_logic;
        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX, LS_EX: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX, MEM_WREN_EX: IN STD_LOGIC;
        A3_EX, RF_D3MUX_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX: IN STD_LOGIC_VECTOR(1 DOWNTO 0);

        LSPC_MM, SE_MM, ALU_C_MM, MEM_O_MM, D1_MM, LS_MM: OUT STD_LOGIC_VECTOR(15 downto 0);
        A3_MM, RF_D3MUX_MM: OUT STD_LOGIC_VECTOR(2 downto 0);
        OF_MM, F_MM: OUT STD_LOGIC_VECTOR(1 downto 0);
        RF_WREN_MM: OUT STD_LOGIC
    );
    end component;

    
    component WB_Stage is 
    port(
        CLK, RST: in std_logic;
		LSPC_MM, ALU_C_MM, SE_MM, MEM_O_MM, D1_MM, LS_MM: in STD_LOGIC_VECTOR(15 downto 0);
        A3_MM, RF_D3MUX_MM: in STD_LOGIC_VECTOR(2 downto 0);
        OF_MM, F_MM: in STD_LOGIC_VECTOR(1 downto 0);
        RF_WREN_MM: in STD_LOGIC;

		rf_d3: out std_logic_vector(15 downto 0);
		rf_a3: out std_logic_vector(2 downto 0);
		rf_wren: out std_logic
    );
    end component;

    component FFX is
        generic(N: integer);
        port(D: in std_logic_vector(N-1 downto 0);
              EN: in std_logic;
              RST: in std_logic;
              CLK: in std_logic;
              Q: out std_logic_vector(N-1 downto 0));
    end component;

    component rf_fwdr is
        port (
          a3_exmm, a1_rrex, a2_rrex: in std_logic_vector(2 downto 0);
          d1_fmux, d2_fmux: out std_logic
        );
    end component;

    signal PC_NEXT_SIG, PC_IF_SIG, OP_IF_SIG: std_logic_vector(15 downto 0);
    signal IFID_D, IFID_Q: std_logic_vector(31 downto 0);
    signal IDRR_D, IDRR_Q: std_logic_vector(70 downto 0);
    signal RREX_D, RREX_Q: std_logic_vector(101 downto 0);
    signal EXMM_D, EXMM_Q: std_logic_vector(108 downto 0); -- length should be reduced by 1, rightmost bit is not used
    signal MMWB_D, MMWB_Q: std_logic_vector(106 downto 0);
    signal rf_d3_sig: std_logic_vector(15 downto 0);
    signal rf_a3_sig: std_logic_vector(2 downto 0);
    signal rf_wren_sig: std_logic;
    signal d1_fmux_sig, d2_fmux_sig: std_logic;
    
    begin

    ifid_reg: FFX
            generic map(N => 32)
            port map(D => IFID_D,
                  EN => '1',
                  RST => RST, 
                  CLK => CLK,
                  Q => IFID_Q
                );
    
    idrr_reg: FFX
            generic map(N => 71)
            port map(D => IDRR_D,
                  EN => '1',
                  RST => RST, 
                  CLK => CLK,
                  Q => IDRR_Q
                );
   
    rrex_reg: FFX
            generic map(N => 102)
            port map(D => RREX_D,
                  EN => '1',
                  RST => RST, 
                  CLK => CLK,
                  Q => RREX_Q
                );
    exmm_reg: FFX
                generic map(N => 109)
                port map(D => EXMM_D,
                      EN => '1',
                      RST => RST, 
                      CLK => CLK,
                      Q => EXMM_Q
                    );
    mmwb_reg: FFX
                generic map(N => 107)
                port map(D => MMWB_D,
                        EN => '1',
                        RST => RST, 
                        CLK => CLK,
                        Q => MMWB_Q
                    );

    rf_fwdr1: rf_fwdr port map (
        a3_exmm => EXMM_Q(11 downto 9), a1_rrex => RREX_Q(82 downto 80), a2_rrex => RREX_Q(85 downto 83),
        d1_fmux => d1_fmux_sig, d2_fmux => d2_fmux_sig 
    );
            
    -- ifstage: IF_Stage port map(CLK => CLK, RST => RST, PC_WREN => '1', PC_IN => PC_NEXT_SIG, PC_IF => IFID_D(31 downto 16), OP_IF => IFID_D(15 downto 0), PC_NEXT => PC_NEXT_SIG);
    ifstage: IF_Stage port map(CLK => CLK, RST => RST, PC_WREN => '1', PC_IN => PC_NEXT_SIG, PC_IF => IFID_D(31 downto 16), OP_IF => IFID_D(15 downto 0), PC_NEXT => PC_NEXT_SIG);
    idstage: ID_Stage port map(
            CLK => CLK, RST => RST,
            PC_IF => IFID_Q(31 downto 16),
            OP_IF => IFID_Q(15 downto 0),

            LS_ID => IDRR_D(70 downto 55) ,SEPC_ID => IDRR_D(54 downto 39), SE_ID => IDRR_D(38 downto 23),
            A1_ID => IDRR_D(22 downto 20), A2_ID => IDRR_D(19 downto 17), A3_ID => IDRR_D(16 downto 14), ALU_CS_ID => IDRR_D(13 downto 11), RF_D3MUX_ID => IDRR_D(10 downto 8),
            ALU_FM_ID => IDRR_D(7 downto 6), CWB_ID => IDRR_D(5 downto 4),
            RF_WREN_ID => IDRR_D(3), SEPC_CS_ID  => IDRR_D(2), ALUY_B_CS_ID  => IDRR_D(1), MEM_WREN_ID  => IDRR_D(0)
        );

    rrstage: RR_Stage port map(
                CLK => CLK, RST => RST,
        
                LS_ID => IDRR_Q(70 downto 55), SEPC_ID => IDRR_Q(54 downto 39), SE_ID => IDRR_Q(38 downto 23),
                A1_ID => IDRR_Q(22 downto 20), A2_ID => IDRR_Q(19 downto 17), A3_ID => IDRR_Q(16 downto 14), ALU_CS_ID => IDRR_Q(13 downto 11), RF_D3MUX_ID => IDRR_Q(10 downto 8),
                ALU_FM_ID => IDRR_Q(7 downto 6), CWB_ID => IDRR_Q(5 downto 4),
                RF_WREN_ID => IDRR_Q(3), SEPC_CS_ID  => IDRR_Q(2), ALUY_B_CS_ID  => IDRR_Q(1), MEM_WREN_ID  => IDRR_Q(0),
        
                RF_WREN => rf_wren_sig,
                RF_A3 => rf_a3_sig,
                RF_D3 => rf_d3_sig,
                
                LS_RR => RREX_D(95 downto 80), LSPC_RR => RREX_D(79 downto 64), SE_RR => RREX_D(63 downto 48), D1_RR => RREX_D(47 downto 32), D2_RR => RREX_D(31 downto 16),
                A3_RR => RREX_D(15 downto 13), ALU_CS_RR => RREX_D(12 downto 10), RF_D3MUX_RR => RREX_D(9 downto 7),
                A1_RR => RREX_D(82 downto 80), A2_RR => RREX_D(85 downto 83),
                ALU_FM_RR => RREX_D(6 downto 5), CWB_RR => RREX_D(4 downto 3),
                RF_WREN_RR => RREX_D(2), ALUY_B_CS_RR => RREX_D(1), MEM_WREN_RR => RREX_D(0)
            );
    exstage: EX_Stage port map(
                CLK => CLK, RST => RST,
                LS_RR => RREX_Q(95 downto 80), LSPC_RR => RREX_Q(79 downto 64), SE_RR => RREX_Q(63 downto 48), D1_RR => RREX_Q(47 downto 32), D2_RR => RREX_Q(31 downto 16),
                A3_RR => RREX_Q(15 downto 13), ALU_CS_RR => RREX_Q(12 downto 10), RF_D3MUX_RR => RREX_Q(9 downto 7), 
                ALU_FM_RR => RREX_Q(6 downto 5), CWB_RR => RREX_Q(4 downto 3),
                RF_WREN_RR => RREX_Q(2), ALUY_B_CS_RR => RREX_Q(1), MEM_WREN_RR => RREX_Q(0),

                -- forwarding inputs
                aluy_out_fwd => EXMM_Q(92 downto 77),
                d1_fmux => d1_fmux_sig, d2_fmux => d2_fmux_sig,
            
                LS_EX => EXMM_D(108 downto 93), ALU_C_EX => EXMM_D(92 downto 77), D1_EX => EXMM_D(76 downto 61), D2_EX => EXMM_D(60 downto 45), LSPC_EX => EXMM_D(44 downto 29), SE_EX => EXMM_D(28 downto 13),
                RF_WREN_EX => EXMM_D(12), 
                A3_EX => EXMM_D(11 downto 9), RF_D3MUX_EX  => EXMM_D(8 downto 6), 
                F_EX  => EXMM_D(5 downto 4), OF_EX => EXMM_D(3 downto 2), MEM_WREN_EX => EXMM_D(1)
            );
    mmstage: MM_Stage port map(
            CLK => CLK, RST => RST,
            LS_EX => EXMM_Q(108 downto 93), ALU_C_EX => EXMM_Q(92 downto 77), D1_EX => EXMM_Q(76 downto 61), D2_EX => EXMM_Q(60 downto 45), LSPC_EX => EXMM_Q(44 downto 29), SE_EX => EXMM_Q(28 downto 13),
            RF_WREN_EX => EXMM_Q(12), 
            A3_EX => EXMM_Q(11 downto 9), RF_D3MUX_EX  => EXMM_Q(8 downto 6), 
            F_EX  => EXMM_Q(5 downto 4), OF_EX => EXMM_Q(3 downto 2), MEM_WREN_EX => EXMM_Q(1),
    
            LS_MM => MMWB_D(106 downto 91), LSPC_MM => MMWB_D(90 downto 75), SE_MM  => MMWB_D(74 downto 59), ALU_C_MM  => MMWB_D(58 downto 43), MEM_O_MM  => MMWB_D(42 downto 27), D1_MM => MMWB_D(26 downto 11),
            A3_MM  => MMWB_D(10 downto 8), RF_D3MUX_MM  => MMWB_D(7 downto 5),
            OF_MM  => MMWB_D(4 downto 3), F_MM => MMWB_D(2 downto 1),
            RF_WREN_MM => MMWB_D(0)
        );
    wbstage: WB_Stage port map(
        CLK => CLK, RST => RST,
		LS_MM => MMWB_Q(106 downto 91), LSPC_MM => MMWB_Q(90 downto 75), SE_MM  => MMWB_Q(74 downto 59), ALU_C_MM  => MMWB_Q(58 downto 43), MEM_O_MM  => MMWB_Q(42 downto 27), D1_MM => MMWB_Q(26 downto 11),
        A3_MM  => MMWB_Q(10 downto 8), RF_D3MUX_MM  => MMWB_Q(7 downto 5),
        OF_MM  => MMWB_Q(4 downto 3), F_MM => MMWB_Q(2 downto 1),
        RF_WREN_MM => MMWB_Q(0),

		rf_d3 => rf_d3_sig,
		rf_a3  => rf_a3_sig,
		rf_wren  => rf_wren_sig
    );

end architecture;