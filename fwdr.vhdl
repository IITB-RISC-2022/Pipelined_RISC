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

entity mm_fwdr is
  port (
    a3_rrex, a1_idrr, a2_idrr, rf_d3mux_rrex: in std_logic_vector(2 downto 0);
    rf_wren_rrex: in std_logic;
    d1_mfmux, d2_mfmux, ifid_en, idrr_en, pc_en, rrex_clr : out std_logic
  );
end mm_fwdr;

architecture arch of mm_fwdr is

begin
  process(a3_exmm, a1_rrex, a2_rrex, rf_wren_mm) 
  variable fwd_en : std_logic;
  begin
    fwd_en := rf_wren_mm;
    if rf_d3mux_mm /= "010" then
        fwd_en := '0';
    end if;
    if a3_exmm /= a1_rrex and a3_exmm /= a2_rrex then 
      fwd_en := '0';
    end if;

    if a3_exmm = a1_rrex then
      d1_mfmux <= fwd_en;
    else 
      d1_mfmux <= '0';
    end if;

    if a3_exmm = a2_rrex then
      d2_mfmux <= fwd_en;
    else 
      d2_mfmux <= '0';
    end if;

    if fwd_en then
      ifid_en <= '0';
      idrr_en <= '0';
      pc_en <= '0';
      rrex_clr <= '1';
    else
      ifid_en <= '1';
      idrr_en <= '1';
      pc_en <= '1';
      rrex_clr <= '0';
    end if;
  end process;
end architecture; -- arch