library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_fwdr is
  port (
    a3_exmm, a1_rrex, a2_rrex: in std_logic_vector(2 downto 0);
    d1_fmux, d2_fmux: out std_logic
  );
end rf_fwdr;

architecture arch of rf_fwdr is

begin
  process(a3_exmm, a1_rrex, a2_rrex) 
  begin
    if a3_exmm = a1_rrex then
      d1_fmux <= '1';
    else 
      d1_fmux <= '0';
    end if;

    if a3_exmm = a2_rrex then
      d2_fmux <= '1';
    else 
      d2_fmux <= '0';
    end if;
  end process;
end architecture; -- arch