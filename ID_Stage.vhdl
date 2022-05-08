LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ID_Stage IS
  PORT (
    CLK, RST : IN STD_LOGIC;
    PC_IF : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    OP_IF : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

    SEPC_ID, SE_ID : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    A1_ID, A2_ID, A3_ID, ALU_CS_ID, RF_D3MUX_ID : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ALU_FM_ID, CWB_ID : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    RF_WREN_ID, SEPC_CS_ID, ALUY_B_CS_ID, MEM_WREN_ID : OUT STD_LOGIC
  );
END ID_Stage;

ARCHITECTURE behav OF ID_Stage IS
  component LShifter7 is
  port (
      inp : in std_logic_vector (8 downto 0);
      outp : out std_logic_vector (15 downto 0)
    );
  end component;
BEGIN
  PROCESS (CLK, RST, PC_IF, OP_IF)
  BEGIN
    CASE(OP_IF (15 DOWNTO 12)) IS
      WHEN "0001" =>
        A1_ID <= OP_IF(11 DOWNTO 9);
        A2_ID <= OP_IF(8 DOWNTO 6);
        A3_ID <= OP_IF(5 DOWNTO 3);
        ALU_CS_ID <= "000";
        ALU_FM_ID <= "11";
        CWB_ID <= "00";
        RF_D3MUX_ID <= "000";
        RF_WREN_ID <= '1';
        MEM_WREN_ID <= '0';

        SEPC_ID <= (others => '0');
        SE_ID <= (others => '0');
        SEPC_CS_ID <= '0';
        ALUY_B_CS_ID <= '0';

      WHEN "0000" =>
        A1_ID <= (others => '0');
        A2_ID <= (others => '0');
        A3_ID <= OP_IF(11 DOWNTO 9);
        ALU_CS_ID <= "000";
        ALU_FM_ID <= "00";
        CWB_ID <= "00";
        RF_D3MUX_ID <= "000";
        RF_WREN_ID <= '1';
        MEM_WREN_ID <= '0';

        SEPC_ID <= (others => '0');
        SE_ID <= (others => '0');
        SEPC_CS_ID <= '0';
        ALUY_B_CS_ID <= '0';
        
      WHEN OTHERS =>

    END CASE;
  END PROCESS; -- 
END ARCHITECTURE; -- arch