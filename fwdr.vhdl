library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_fwdr is
  port (
    a3_exmm, a1_rrex, a2_rrex, rf_d3mux_mm: in std_logic_vector(2 downto 0);
    rf_wren_mm: in std_logic;
    d1_fmux, d2_fmux: out std_logic
  );
end rf_fwdr;

architecture arch of rf_fwdr is

begin
  process(a3_exmm, a1_rrex, a2_rrex, rf_wren_mm) 
  variable fwd_en : std_logic;
  begin
    fwd_en := rf_wren_mm;
    if rf_d3mux_mm /= "000" then
        fwd_en := '0';
    end if;
    if a3_exmm = a1_rrex then
      d1_fmux <= fwd_en;
    else 
      d1_fmux <= '0';
    end if;

    if a3_exmm = a2_rrex then
      d2_fmux <= fwd_en;
    else 
      d2_fmux <= '0';
    end if;
  end process;
end architecture; -- arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mm_fwdr is
  port (
    a3_rrex, a1_idrr, a2_idrr, rf_d3mux_rrex: in std_logic_vector(2 downto 0);
    rf_wren_rrex, clk: in std_logic;
    d1_mfmux, d2_mfmux, ifid_en, idrr_en, pc_en, rrex_clr : out std_logic
  );
end mm_fwdr;

architecture arch of mm_fwdr is
signal fwd_temp : std_logic;
begin
  -- process(a3_rrex, a1_idrr, a2_idrr, rf_wren_rrex, rf_d3mux_rrex, clk) 
  
  process(a3_rrex, a1_idrr, a2_idrr, rf_wren_rrex, rf_d3mux_rrex)
  begin
        fwd_temp <= rf_wren_rrex;
        if rf_d3mux_rrex /= "010" then
          fwd_temp <= '0';
        end if;
        if a3_rrex /= a1_idrr and a3_rrex /= a2_idrr then 
          fwd_temp <= '0';
        end if;
  end process;
  process(clk, fwd_temp)
  variable fwd_en : std_logic := '0';
  variable myclk: unsigned(2 downto 0) := "000";
  variable fwd_hold : std_logic := '0';
  begin
      ifid_en <= '1';
      idrr_en <= '1';
      pc_en <= '1';
      rrex_clr <= '0';
      d1_mfmux <= '0';
      d2_mfmux <= '0';
  end process;
end architecture; -- arch