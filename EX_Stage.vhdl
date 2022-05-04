library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_Stage is
  port (
    CLK, RST: in std_logic;
    LSPC_RR, SE_RR, D1_RR, D2_RR: in std_logic_vector(15 downto 0);
    A3_RR, ALU_CS_RR, RF_D3MUX_RR: in std_logic_vector(2 downto 0);
    ALU_FM_RR, CWB_RR: in std_logic_vector(1 downto 0);
    RF_WREN_RR, ALUY_B_CS: in std_logic;

    ALU_C_EX, D1_EX, D2_EX, LSPC_EX, SE_EX: out std_logic_vector(15 downto 0);
    RF_WREN_EX: out std_logic;
    A3_EX, RF_D3MUX_EX: out std_logic_vector(2 downto 0);
    F_EX, OF_EX: out std_logic_vector(1 downto 0)
  );
end EX_Stage ;

architecture behav of EX_Stage is
    component ALU is
        port(alu_op: in std_logic_vector(2 downto 0);
            inp_a: in std_logic_vector(15 downto 0);
            inp_b: in std_logic_vector(15 downto 0);
            out_c: out std_logic;
            out_z: out std_logic;
            alu_out: out std_logic_vector(15 downto 0));
    end component;

    component mux_2x1_16bit is
        port (
            inp_1 : in std_logic_vector (15 downto 0);
             inp_2 : in std_logic_vector (15 downto 0);
            outp : out std_logic_vector (15 downto 0);
             sel : in std_logic
          );
    end component;

    component FF1 is
		port(D: in std_logic;
			  EN: in std_logic;
			  RST: in std_logic;
			  CLK: in std_logic;
			  Q: out std_logic);
	end component;
        
    signal aluy_b: std_logic_vector(15 downto 0);
    signal c_in, c_oc, z_in, z_oz, c_en, z_en: std_logic;
begin
    ALUY: ALU port map(alu_op => ALU_CS_RR, inp_a => D1_RR, inp_b => ALUY_B, out_c => C_IN, out_z => Z_IN, alu_out => ALU_C_EX);
    aluy_b_mux: mux_2x1_16bit port map(inp_1 => D2_RR, inp_2 => SE_RR, outp => ALUY_B, sel => ALUY_B_CS);
    fc: FF1 port map(D => c_in, EN=> c_en, RST=>rst, CLK=>clk, Q=>c_oc);
	fz: FF1 port map(D => z_in, EN=>z_en, RST=>rst, CLK=>clk, Q=>z_oz);
    foc: FF1 port map(D => oc_in, EN=> c_en, RST=>rst, CLK=>clk, Q=>OF_EX(0));
	foz: FF1 port map(D => oz_in, EN=>z_en, RST=>rst, CLK=>clk, Q=>OF_EX(1));
    F_EX(0) <= c_oc;
    F_EX(1) <= z_oz;
    A3_EX <= A3_RR;
    D1_EX <= D1_RR;
    D2_EX <= D2_RR;
    SE_EX <= SE_RR;
    RF_D3MUX_EX <= RF_D3MUX_RR;
    RF_WREN_EX <= RF_WREN_RR;
    process(CLK, RST, ALU_FM_RR)
    begin
        case(ALU_FM_RR) is
            when "00" => 
                c_en <= '0';
                z_en <= '0';
            when "01" => 
                c_en <= '1';
                z_en <= '0';
            when "10" => 
                c_en <= '0';
                z_en <= '1';
            when "11" => 
                c_en <= '1';
                z_en <= '1';
            when others =>
                c_en <= '0';
                z_en <= '0';
        end case;
    end process ;
end architecture ;