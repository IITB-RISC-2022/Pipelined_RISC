library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port(alu_op: in std_logic_vector(2 downto 0);
      inp_a: in std_logic_vector(15 downto 0);
      inp_b: in std_logic_vector(15 downto 0);
      out_c: out std_logic;
      out_z: out std_logic;
      alu_out: out std_logic_vector(15 downto 0));
end entity;

architecture behav of ALU is
begin
	process(alu_op, inp_a, inp_b) 
	-- temp_out is a temp variable that stores the output of the ALU
	variable temp_out, temp_a, temp_b : std_logic_vector(16 downto 0);
	begin
		temp_out := (others => '0');
		if (alu_op = "000") then
			temp_a(15 downto 0) := inp_a;
			temp_b(15 downto 0) := inp_b;
			temp_a(16) := '0';
			temp_b(16) := '0';
			temp_out := std_logic_vector(unsigned(temp_a) + unsigned(temp_b));
			out_c <= temp_out(16);
		elsif (alu_op = "001") then
			temp_out(15 downto 0) := inp_a xor inp_b;
			out_c <= '0';
		elsif (alu_op = "010") then
			temp_out(15 downto 0) := inp_a nand inp_b;
			out_c <= '0';
		elsif (alu_op = "011") then
			temp_out(15 downto 0) := std_logic_vector(unsigned(inp_a) + unsigned(inp_b)-1);
		elsif (alu_op = "100") then
			temp_out(15 downto 0) := inp_b;
		end if;
		
		if temp_out(15 downto 0) = "0000000000000000" then 
			out_z <= '1';
		else
			out_z <= '0';
		end if;
		
		alu_out <= temp_out(15 downto 0);
	end process;

end architecture;