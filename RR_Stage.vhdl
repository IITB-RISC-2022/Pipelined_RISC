library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_Stage is
  port (
    CLK, RST: in std_logic;
    id_in: in std_logic_vector(31 downto 0);
    pc_so: out std_logic_vector(15 downto 0);
    pc_ow: out std_logic;
    rr_out: out std_logic_vector(100 downto 0)
  );
end ID_Stage;

architecture behav of ID_Stage is
  component REG_FILE is
		port(CLK, RST : in std_logic;
			  WR_EN : in std_logic;
			  RF_A1 : in std_logic_vector(2 downto 0);
			  RF_A2 : in std_logic_vector(2 downto 0);
			  RF_A3 : in std_logic_vector(2 downto 0);
			  RF_D3 : in std_logic_vector(15 downto 0);
			  RF_D1 : out std_logic_vector(15 downto 0);
			  RF_D2 : out std_logic_vector(15 downto 0);
			  PC_D : in std_logic_vector(15 downto 0); 
			  PC_EN : in std_logic;
			  PC_Q : out std_logic_vector(15 downto 0)
		);
  end component;


begin



end architecture ; -- arch