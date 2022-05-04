library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_Stage is
    port(
        clk, rst, clr: in std_logic;
        pc_wren: in std_logic;
        pc_in: in std_logic_vector(15 downto 0);
        pc_so: out std_logic_vector(15 downto 0);
        if_out: out std_logic_vector(31 downto 0)
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
    PC: FF16 port map(d => pc_in, en => pc_wren, rst => rst, clk => clk, q => pc_out);
    IM1: IM port map(clk => clk, addr => pc_out, outp => mem_out);
    if_out(31 downto 16) <= mem_out;

    main : process(clk, rst, clr)
    begin
        if(falling_edge(clk)) then
            if_out(15 downto 0) <= pc_out;
        end if;

        if(rst = '1' or clr = '1') then
            if_out <= (others => '0');    
        end if;
    end process; -- main

end architecture ;