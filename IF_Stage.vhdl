library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_Stage is
    port(
        CLK, RST: in std_logic;
        PC_WREN: in std_logic;
        PC_IN: in std_logic_vector(15 downto 0);
        PC_IF, OP_IF, PC_NEXT: out std_logic_vector(15 downto 0)
    );
end entity;


architecture behav of IF_Stage is
    component IM is
        port(
            CLK: in std_logic;
            ADDR: in std_logic_vector(15 downto 0);
            OUTP: out std_logic_vector(15 downto 0)
        );
    end component;

    component FF16 is
        port(D: in std_logic_vector(15 downto 0);
              EN: in std_logic;
              RST: in std_logic;
              CLK: in std_logic;
              Q: out std_logic_vector(15 downto 0));
    end component;
    signal pc_out, mem_out: std_logic_vector(15 downto 0);
begin
    PC: FF16 port map(d => PC_IN, en => pc_wren, rst => rst, clk => clk, q => PC_out);
    IM1: IM port map(clk => clk, addr => pc_out, outp => mem_out);
    OP_IF <= mem_out;
    pc_next <= std_logic_vector(unsigned(pc_out) + 1);
    pc_if <= pc_out;
    -- PC_IF <= pc_in;
end;