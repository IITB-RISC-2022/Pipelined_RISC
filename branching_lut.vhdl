library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity branching_lut is
	port(
        --inputs
		clk, rst, toggle: in std_logic;
		new_PC_inp, PC_inp, BA_inp: in std_logic_vector(15 downto 0);
		in_addr: in std_logic_vector(2 downto 0);
        beq_check: in std_logic;
        --outputs
        BA_outp: out std_logic_vector(15 downto 0);
		taken_sig: out std_logic;
        out_addr: out std_logic_vector(2 downto 0);
        );
end entity;

architecture behav of branching_lut is
    --components
    component FF16 is
        port(D: in std_logic_vector(15 downto 0);
             EN: in std_logic;
             RST: in std_logic;
             CLK: in std_logic;
             Q: out std_logic_vector(15 downto 0));
    end component;

    component FF3 is
        port(D: in std_logic_vector(2 downto 0);
             EN: in std_logic;
             RST: in std_logic;
             CLK: in std_logic;
             Q: out std_logic_vector(2 downto 0));
    end component;

    component FF1 is
        port(D: in std_logic;
             EN: in std_logic;
             RST: in std_logic;
             CLK: in std_logic;
             Q: out std_logic);
    end component;

    --signals
    signal taken_inp, taken_outp, taken_enable: std_logic_vector(7 downto 0) <= (others => '0');
    signal count_holder_enable: std_logic <= '0';
    signal PC_enable, BA_enable: std_logic_vector(7 downto 0) <= (others => '0');
    signal count_holder_inp, count_holder_outp: std_logic_vector(2 downto 0) <= "000";
    --new datatype to hold 8 * 16bit values
    type vector_8_16bit is array(0 to 7) of std_logic_vector(15 downto 0);
    signal all_PC_outp, all_BA_outp: vector_8_16bit;
    signal flag: std_logic;
begin
    --signal maps
    all_PC_outp, all_BA_outp <= (others => (others => '0'));
    taken_inp <= not taken_outp;
    count_holder_inp <= std_logic_vector(to_unsigned(1, 3) + unsigned(count_holder_outp)); --go to next state of FSM
    
    --port maps
    registers: for i in 0 to 7 generate
        taken_reg: FF1 port map(
            clk => clk,
            rst => rst,
            d => taken_inp(i),
            q => taken_outp(i),
            en => taken_enable(i)
        );

        pc_reg: FF16 port map(
            clk => clk,
            rst => rst,
            d => new_PC_inp,
            q => all_PC_outp(i),
            en => PC_enable(i)
        );

        ba_reg: FF16 port map(
            clk => clk,
            rst => rst,
            d => BA_inp,
            q => all_BA_outp(i),
            en => BA_enable(i)
        );
    end generate;

    count_holder: FF3 port map(
        clk => clk,
        rst => rst,
        en => count_holder_enable,
        d => count_holder_inp,
        q => count_holder_outp
    );

    --processes
    process(toggle, in_addr)
    begin
        taken_enable <= (others =>'0');
        if(toggle='1') then
            taken_enable(unsigned(in_addr)) <= '1';
        end if;
    end process;

    process(beq_check, new_PC_in, all_PC_outp, count_holder_outp)
    begin
        count_holder_enable <= '0';
		PC_enable <= (others => '0');
		BA_enable <= (others => '0');
        flag <= false;
        for i in 0 to 7 loop
            if (new_PC_in = all_PC_outp(i)) then
                flag <= true;
                exit;
            end if;
        end loop;

        if(flag = false) and (is_BEQ = '1') then
            count_holder_enable <= '1';
            PC_enable(unsigned(count_holder_outp)) <= '1';
            BA_enable(unsigned(count_holder_outp)) <= '1';
        end if;
    end process;

    process(taken_outp, PC_inp, all_PC_outp, all_BA_outp)
    begin
        for i in 0 to 7 loop
            if(PC_in = PCs_out(i)) then
                BA_outp <= all_BA_outp(i);
                is_taken <= taken_out(i);
                out_addr <= std_logic_vector(to_unsigned(i,3));
                exit;
            end if;
        end loop;
    end process;

end architecture;