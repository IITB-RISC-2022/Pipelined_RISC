library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY is
	port(CLK, WR_Enable, RW_Enable: in std_logic;
		  ADDR: in std_logic_vector(15 downto 0);
		  DATA: in std_logic_vector(15 downto 0);
		  OUTP: out std_logic_vector(15 downto 0)
	);
end MEMORY;

architecture behav of MEMORY is
	type vec_array is array(0 to 2**5 - 1) of std_logic_vector(15 downto 0);
	--0111000000000010
	signal RAM: vec_array:= (
		0 => "0000000000000001",	 
		1 => "1111111111111110",-- in ra rb rc	
		others=>(others=>'1'));
	-- signal RAM: vec_array:= (others=>b"0000000000000000");

-- 00 00 000 001 002 0 00
begin
	process(CLK, ADDR, RW_Enable)
	variable out_t : std_logic_vector(15 downto 0) := (others => '1');
	begin
	if falling_edge(CLK) then
		if WR_Enable = '1' then
			RAM(to_integer(unsigned(ADDR))) <= DATA;
		end if;
	end if;
	
	if RW_Enable = '1' then
		if to_integer(unsigned(ADDR)) < 15 then
			out_t := RAM(to_integer(unsigned(ADDR)));
		else
			out_t := (others => '0');
		end if;
	end if;
	outp <= out_t;
	end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is
	port(
		CLK: in std_logic;
		ADDR: in std_logic_vector(15 downto 0);
		OUTP: out std_logic_vector(15 downto 0)
	);
end IM;


architecture behav of IM is
	type vec_array is array(0 to 2**5 - 1) of std_logic_vector(15 downto 0);
	signal RAM: vec_array:= (
		-- 0 => "0111000000001010",
		0 => "0111001000000000",
		1 => "0111000001000000",
		-- 1 => "0001001011011000", -- r1, r3, r3
		-- 2 => "0000000000000001", -- r0, 1
		-- 3 => "0001001011111000", -- r1, r3, r7
		others=>(others=>'1'));
begin
	process(CLK, ADDR)
	variable out_t : std_logic_vector(15 downto 0) := (others => '1');
	begin
		if to_integer(unsigned(ADDR)) < 15 then
			out_t := RAM(to_integer(unsigned(ADDR)));
		else
			out_t := (others => '1');
		end if;
		outp <= out_t;
	end process;
end architecture;