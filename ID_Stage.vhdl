library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_Stage is
  port (
    CLK, RST: in std_logic;
    PC_IF: in std_logic_vector(15 downto 0);
    OP_IF: in std_logic_vector(15 downto 0);
    
    SEPC_ID, SE_ID: out std_logic_vector(15 downto 0);
    A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID: out std_logic_vector(2 downto 0);
    ALU_FM_ID, CWB_ID: out std_logic_vector(1 downto 0);
    RF_WREN_ID, SEPC_CS_ID: out std_logic_vector
  );
end ID_Stage ;

architecture behav of ID_Stage is

begin

    process(CLK, RST, PC_IF, OP_IF)
    begin
        case(OP_IF(15 downto 12)) is
            when "0001" =>
                A1_RR <= ir(11 downto 9);
                A2_RR <= ir(8 downto 6);
                A3_RR <= ir(5 downto 3);
                ALU_CS_RR <= "000";
                ALU_FM_RR <= "11";
                CWB_RR <= "00";
                RF_D3MUX_RR <= "000";
                RF_WREN_RR <= '1';
            when others =>
                
        end case;
    end process ; -- 
end architecture ; -- arch