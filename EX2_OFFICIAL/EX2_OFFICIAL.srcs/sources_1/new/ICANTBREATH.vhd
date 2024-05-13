----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 19:16:58
-- Design Name: 
-- Module Name: ICANTBREATH - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
----------------------------------
entity ICANTBREATH is
    PORT(
    CLK: IN bit;
    OUTPUT: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
end ICANTBREATH;
----------------------
architecture Behavioral of ICANTBREATH is
SIGNAL COUNTING: STD_LOGIC:= '1';
SIGNAL COUNTER:INTEGER RANGE 0 TO 75000 :=75;
SIGNAL GROUPNUM:INTEGER RANGE 1 TO 1000;
SIGNAL COUNTER2:INTEGER RANGE 0 TO 75000;
SIGNAL ORDER:INTEGER RANGE 0 TO 1 :=0;
SIGNAL LED:INTEGER RANGE 0 TO 3 :=0;
begin
    PROCESS(CLK)
    BEGIN
    IF (CLK'EVENT AND CLK = '1') THEN
        COUNTER2 <= COUNTER2 + 1;
    IF (COUNTER2 < COUNTER AND ORDER = 0) THEN
        COUNTING <= '0';
    ELSIF (COUNTER2 >= COUNTER AND ORDER = 0) THEN COUNTING <= '1';
    ELSIF (COUNTER2 < COUNTER AND ORDER = 1) THEN COUNTING <= '1';
    ELSE COUNTING <= '0';
    END IF;
    IF (COUNTER2 = 75000) THEN
        COUNTER2 <= 0;
        GROUPNUM <= GROUPNUM + 1;
        COUNTER <= COUNTER + 75;
    END IF; 
    IF (GROUPNUM = 1000) THEN
        GROUPNUM <= 1;
        COUNTER <= 75;
    IF (ORDER = 0) THEN
        ORDER <= 1;
    ELSE 
        ORDER <= 0;
    IF (LED = 3) THEN
        LED <= 0;
    ELSE LED <= LED + 1;
    END IF;
    END IF;
    END IF;
        OUTPUT <= "1111";
        OUTPUT(LED) <= COUNTING;
    END IF;
    END PROCESS;
end Behavioral;
