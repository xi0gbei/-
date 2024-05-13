----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/20 10:14:51
-- Design Name: 
-- Module Name: CALC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CALC is
    PORT(
    CLK, PLUS, MINUS, RST, CHA: IN BIT;
    OUTPUT: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end CALC;
-----------------------------------------
architecture Behavioral of CALC is
SIGNAL COUNTING: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
SIGNAL MONI: STD_LOGIC := '0';
SIGNAL COUNTER: INTEGER RANGE 0 TO 50000000 := 0;
SIGNAL ONLY: INTEGER RANGE 0 TO 1:= 0;
SIGNAL RE: INTEGER RANGE 0 TO 1:= 0;
SIGNAL CH: INTEGER RANGE 0 TO 1:= 0;
SIGNAL COUNTER2: INTEGER RANGE 0 TO 1000000 := 0;
begin
PROCESS(CLK,RST)
BEGIN
IF (CLK'EVENT AND CLK = '1') THEN
    IF (PLUS = '1' AND MINUS = '1' AND RST = '1' AND CHA ='1') THEN 
        COUNTER2 <= COUNTER2 + 1;
    IF (COUNTER2 = 500000) THEN 
        ONLY <= 0;
        COUNTER2 <= 0;
    END IF;
    ELSE COUNTER2 <= 0;
    END IF; 
    IF (PLUS = '0' AND ONLY = 0) THEN
        COUNTING <= COUNTING + "00000001";
        ONLY <= 1;
    END IF;
    IF (MINUS = '0' AND ONLY = 0) THEN
        COUNTING <= COUNTING - "00000001";
        ONLY <= 1;
    END IF;
    IF (RST = '0' AND ONLY = 0) THEN
        COUNTING <= "00000000";
        MONI <= '0';
        ONLY <= 1;
    END IF;
    IF (CHA = '0') THEN
        ONLY <= 1;
        CH <= 1;
        COUNTER <= COUNTER + 1;
    IF (COUNTER = 50000000) THEN
        RE <= 1;
        COUNTER <= 0;
    END IF;
    END IF;
    IF (ONLY = 0 AND CH = 1 AND RE = 1) THEN
        CH <= 0;
        RE <= 0;
        MONI <= '0';
        ONLY <= 0;
        COUNTING <= "00000000";
        COUNTER <= 0;
    ELSIF (ONLY = 0 AND CH = 1 AND RE = 0) THEN
        MONI <= NOT MONI;
        ONLY <= 0;
        CH <= 0;
        COUNTER <= 0;
    END IF;
    IF (MONI = '0') THEN
        OUTPUT(0) <= NOT COUNTING(0);
        OUTPUT(1) <= NOT COUNTING(1);
        OUTPUT(2) <= NOT COUNTING(2);
        OUTPUT(3) <= NOT COUNTING(3);
    ELSIF (MONI = '1') THEN
        OUTPUT(0) <= NOT COUNTING(4);
        OUTPUT(1) <= NOT COUNTING(5);
        OUTPUT(2) <= NOT COUNTING(6);
        OUTPUT(3) <= NOT COUNTING(7);
    END IF;
END IF;
END PROCESS;
end Behavioral;
