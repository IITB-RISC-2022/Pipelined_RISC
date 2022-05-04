library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_Stage is
  port (
    clk, rst, clr: in std_logic;
    if_in: in std_logic_vector(31 downto 0);
    pc_so: out std_logic_vector(15 downto 0);
    pc_ow: out std_logic;
    id_out: out std_logic_vector(100 downto 0)
  );
end ID_Stage ;

architecture behav of ID_Stage is



begin



end architecture ; -- arch