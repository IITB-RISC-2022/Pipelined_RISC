LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EX_Stage IS
    PORT (
        CLK, RST : IN STD_LOGIC;
        LSPC_RR, SE_RR, D1_RR, D2_RR, LS_RR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        A3_RR, ALU_CS_RR, RF_D3MUX_RR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_FM_RR, CWB_RR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        RF_WREN_RR, ALUY_B_CS_RR, MEM_WREN_RR : IN STD_LOGIC;

        -- forwarding inputs
        aluy_out_fwd: in std_logic_vector(15 downto 0);
        d1_fmux, d2_fmux: in std_logic;

        ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX, LS_EX : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RF_WREN_EX, MEM_WREN_EX: OUT STD_LOGIC;
        A3_EX, RF_D3MUX_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        F_EX, OF_EX: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END EX_Stage;

ARCHITECTURE behav OF EX_Stage IS
    COMPONENT ALU IS
        PORT (
            alu_op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            inp_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            inp_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_c : OUT STD_LOGIC;
            out_z : OUT STD_LOGIC;
            alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;

    COMPONENT mux_2x1_16bit IS
        PORT (
            inp_1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            inp_2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            outp : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            sel : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT FF1 IS
        PORT (
            D : IN STD_LOGIC;
            EN : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            CLK : IN STD_LOGIC;
            Q : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL aluy_b, d1_rr_sig, d2_rr_sig, ALU_C_sig: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL oc_out, oz_out, c_in, c_out, z_in, z_out, c_en, z_en : STD_LOGIC;
BEGIN
    LS_EX <= LS_RR;

    ALUY : ALU PORT MAP(alu_op => ALU_CS_RR, inp_a => D1_RR_sig, inp_b => ALUY_B, out_c => C_IN, out_z => Z_IN, alu_out => ALU_C_sig);

    aluy_b_mux : mux_2x1_16bit PORT MAP(inp_1 => D2_RR_sig, inp_2 => SE_RR, outp => ALUY_B, sel => ALUY_B_CS_RR);

    -- forwarding
    d1_rr_fmux : mux_2x1_16bit PORT MAP(inp_1 => D1_RR, inp_2 => aluy_out_fwd, outp => d1_rr_sig, sel => d1_fmux);
    d2_rr_fmux : mux_2x1_16bit PORT MAP(inp_1 => D2_RR, inp_2 => aluy_out_fwd, outp => d2_rr_sig, sel => d2_fmux);

    fc : FF1 PORT MAP(D => c_in, EN => c_en, RST => rst, CLK => clk, Q => c_out);
    fz : FF1 PORT MAP(D => z_in, EN => z_en, RST => rst, CLK => clk, Q => z_out);
    foc : FF1 PORT MAP(D => c_out, EN => c_en, RST => rst, CLK => clk, Q => oc_out);
    foz : FF1 PORT MAP(D => z_out, EN => z_en, RST => rst, CLK => clk, Q => oz_out);
    F_EX(0) <= c_out;
    F_EX(1) <= z_out;
    OF_EX(0) <= oc_out;
    OF_EX(1) <= oz_out;
    A3_EX <= A3_RR;
    D1_EX <= D1_RR_sig;
    D2_EX <= D2_RR_sig;
    SE_EX <= SE_RR;
    MEM_WREN_EX <= MEM_WREN_RR;
    LSPC_EX <= LSPC_RR;
    RF_D3MUX_EX <= RF_D3MUX_RR;
    -- RF_WREN_EX <= RF_WREN_RR;
    PROCESS (CLK, RST, ALU_FM_RR, cwb_rr, rf_wren_rr, oc_out, oz_out, ALU_CS_RR, ALU_C_sig, LS_RR)
    BEGIN
        if(ALU_CS_RR = "100") then
            ALU_C_EX <= LS_RR;
        else
            ALU_C_EX <= ALU_C_sig;
        end if;
        CASE(ALU_FM_RR) IS
            WHEN "00" =>
            c_en <= '0';
            z_en <= '0';
            WHEN "01" =>
            c_en <= '1';
            z_en <= '0';
            WHEN "10" =>
            c_en <= '0';
            z_en <= '1';
            WHEN "11" =>
            c_en <= '1';
            z_en <= '1';
            WHEN OTHERS =>
            c_en <= '0';
            z_en <= '0';
        END CASE;

        CASE(cwb_rr) IS
            WHEN "01" =>
            RF_WREN_EX <= oc_out and rf_wren_rr;
            WHEN "10" =>
            RF_WREN_EX <= oz_out and rf_wren_rr;
            WHEN others =>
            RF_WREN_EX <= RF_WREN_RR;
        END CASE;
        END PROCESS;
    END ARCHITECTURE;