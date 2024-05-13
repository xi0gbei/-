----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 14:52:40
-- Design Name: 
-- Module Name: led_test - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.All;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
----------------------------------------
entity led_test is
    porT(clk, rst: IN BIT;
        output: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
end led_test;
-----------------------------------------
architecture Behavioral of led_test is
    SIGNAL counting: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    SIGNAL COUNTER: INTEGER RANGE 0 TO 50000000 := 0;
begin
    output <= counting;
    PROCESS (clk,rst)
    begin
        IF (clk'EVENT AND clk = '1') THEN
            counter <= counter + 1;
            IF(rst = '0') THEN
                COUNTER <= 0;
                COUNTING <= "1110";
            END IF;
            IF (counter = 50000000) THEN
                counter <= 0;
                output <= counting;
                IF (counting = "1110") THEN counting <= "1101";
                ELSIF (counting = "1101") THEN counting <= "1011";
                ELSIF (counting = "1011") THEN counting <= "0111";
                ELSE counting <= "1110";
                END IF;
             END IF;
         END IF;
   END PROCESS;
end Behavioral;