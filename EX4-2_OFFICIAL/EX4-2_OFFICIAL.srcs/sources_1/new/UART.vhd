----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/26 16:39:49
-- Design Name: 
-- Module Name: UART - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--------------------------------------
entity UART is
PORT (
    CLK : IN BIT;
    KEY1 : IN BIT;
    KEY2 : IN BIT;
    KEY3 : IN BIT;
    KEY4 : IN BIT;
    RX: IN BIT;
    TX: OUT STD_LOGIC
);
end UART;

architecture Behavioral of UART is
----------------
SIGNAL STORING : BIT := '0';
SIGNAL CALC : BIT := '0';
SIGNAL RX_CON : INTEGER RANGE 1 TO 3 := 1;
SIGNAL RXING : BIT := '0';
SIGNAL RX_PAUSE : STD_LOGIC;
SIGNAL RX_BEGIN : BIT := '0';
SIGNAL RX_CLK : INTEGER RANGE 0 TO 433 := 0;
SIGNAL RX_COUNT: INTEGER RANGE 0 TO 8 := 0;
SIGNAL RX_CONSE: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL TX_CLK : INTEGER RANGE 0 TO 433 := 0;
SIGNAL TX_CONSE: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL TX_BEGIN: BIT := '0';
SIGNAL TX_COUNT: INTEGER RANGE 0 TO 8 := 0;
SIGNAL TX_PAUSE: STD_LOGIC := '1';
SIGNAL KEY_CON : INTEGER RANGE 1 TO 4 := 1;
SIGNAL KEY_ENSURE: BIT := '0';
SIGNAL KEY_PRESS : BIT := '0';
SIGNAL ENSURE_CLK: INTEGER RANGE 0 TO 50000 := 0;
SIGNAL KEY_CLK : INTEGER RANGE 0 TO 34720 := 0;
SIGNAL KEY_BEGIN: BIT := '0';
SIGNAL KEY_ONLY:BIT := '1';
----------------
begin
PROCESS(CLK)
BEGIN
IF(CLK'EVENT AND CLK = '1') THEN
    IF(RX = '0') THEN RX_PAUSE <= '0';
        ELSE RX_PAUSE <= '1';
    END IF;
    IF(RX_PAUSE = '0' AND RX_CON = 1 AND RX_BEGIN = '0' AND RXING = '0' AND STORING = '0') THEN
        RX_BEGIN <='1';
    END IF;
    IF(RX_BEGIN = '1' AND RXING = '0') THEN
        RX_CLK <= RX_CLK + 1;
    END IF;
    IF(RX_CLK = 216 AND RX_BEGIN = '1' AND RX = '0') THEN
        RX_BEGIN <= '0';
        RXING <= '1';
        RX_CLK <= 0;
    END IF;
    IF(RXING = '1') THEN
        IF (RX_CLK < 433) THEN
            RX_CLK <= RX_CLK + 1;
        ELSIF (RX_CLK = 433) THEN
            RX_CLK <= 0;
            IF (RX_CON = 1) THEN
                RX_CON <= 2;
                RX_CONSE(0) <= RX_PAUSE;
                RX_COUNT <= 1;
            END IF;
            IF (RX_CON = 2 AND RX_COUNT < 8) THEN
                RX_CONSE(RX_COUNT) <= RX_PAUSE;
                RX_COUNT <= RX_COUNT + 1;
            ELSIF (RX_CON = 2 AND RX_COUNT = 8) THEN
                RX_CON <= 1;
                RXING <= '0';
                RX_COUNT <= 0;
                STORING <= '1';
            END IF;
        END IF;
    END IF;
    IF(STORING = '1' AND CALC = '0') THEN
        IF (RX_CONSE > "01011010" OR RX_CONSE < "01000001") THEN
        TX_CONSE <= "01000000";
        ELSE
        TX_CONSE <= RX_CONSE + "00100000";
        END IF;
        CALC <= '1';
        STORING <= '0';
    END IF;
    IF(CALC = '1') THEN
            IF(TX_CLK < 433) THEN
                IF(TX_BEGIN = '0') THEN
                TX_PAUSE <= '0';
                END IF;
                TX_CLK <= TX_CLK + 1;
            ELSIF(TX_CLK = 433 AND TX_BEGIN = '0') THEN
                TX_PAUSE <= TX_CONSE(0);
                TX_COUNT <= TX_COUNT + 1;
                TX_BEGIN <= '1';
                TX_CLK <= 0;
            ELSIF(TX_CLK = 433 AND TX_COUNT < 8 AND TX_BEGIN = '1') THEN
                TX_PAUSE<= TX_CONSE(TX_COUNT);
                TX_COUNT <= TX_COUNT + 1;
                TX_CLK <= 0;
            ELSIF(TX_CLK = 433 AND TX_COUNT = 8 AND TX_BEGIN = '1') THEN
                TX_BEGIN <= '0';
                CALC <= '0';
                TX_PAUSE <= '1';
                TX_CLK <= 0;
                TX_COUNT <= 0;
            END IF;
    ELSE TX_PAUSE <= '1';
    END IF;
    IF(KEY1 = '1' AND KEY2 = '1' AND KEY3 = '1' AND KEY4 = '1') THEN
    IF(ENSURE_CLK < 50000) THEN
    ENSURE_CLK <= ENSURE_CLK + 1;
    ELSIF(ENSURE_CLK = 50000) THEN
    ENSURE_CLK <= 0;
    KEY_ENSURE <= '0';
    KEY_ONLY <= '1';
    END IF;
    ELSIF (KEY_ENSURE = '0') THEN 
    KEY_ENSURE <= '1';
    ENSURE_CLK <= 0;
    END IF;
    IF(KEY_ENSURE = '1' AND KEY_PRESS = '0') THEN
        IF(KEY1 = '0') THEN
        KEY_PRESS <= '1';
        KEY_CON <= 1;
        KEY_BEGIN <= '1';
        ELSIF(KEY2 = '0') THEN
        KEY_PRESS <= '1';
        KEY_CON <= 2;
        KEY_BEGIN <= '1';
        ELSIF(KEY3 = '0') THEN
        KEY_PRESS <= '1';
        KEY_CON <= 3;
        KEY_BEGIN <= '1';
        ELSIF(KEY4 = '0') THEN
        KEY_PRESS <= '1';
        KEY_CON <= 4;
        KEY_BEGIN <= '1';
        END IF;
    END IF;
    IF(KEY_BEGIN = '1' AND KEY_CLK < 34720) THEN
    KEY_CLK <= KEY_CLK + 1;
    ELSIF(KEY_CLK = 34720) THEN
    KEY_CLK <= 0;
    KEY_BEGIN <= '0';
    KEY_PRESS <= '0';
    END IF;
    IF(KEY_PRESS = '1' AND KEY_CON = 1 AND KEY_ONLY = '1') THEN
        IF(KEY_CLK = 4340) THEN
        CALC <= '1';
        TX_CONSE <= "01000001";
        ELSIF(KEY_CLK = 8680) THEN
        CALC <= '1';
        TX_CONSE <= "01000010";
        ELSIF(KEY_CLK = 13020) THEN
        CALC <= '1';
        TX_CONSE <= "01000011";
        ELSIF(KEY_CLK = 17360) THEN
        CALC <= '1';
        TX_CONSE <= "01000100";
        ELSIF(KEY_CLK = 21700) THEN
        CALC <= '1';
        TX_CONSE <= "01000101";
        ELSIF(KEY_CLK = 26040) THEN
        CALC <= '1';
        TX_CONSE <= "01000110";
        ELSIF(KEY_CLK = 30380) THEN
        CALC <= '1';
        TX_CONSE <= "01000111";
        ELSIF(KEY_CLK = 34710) THEN
        CALC <= '1';
        TX_CONSE <= "00001010";
        KEY_ONLY <= '0';
        END IF;
    ELSIF(KEY_PRESS = '1' AND KEY_CON = 2 AND KEY_ONLY = '1') THEN
        IF(KEY_CLK = 4340) THEN
        CALC <= '1';
        TX_CONSE <= "01100001";
        ELSIF(KEY_CLK = 8680) THEN
        CALC <= '1';
        TX_CONSE <= "01100010";
        ELSIF(KEY_CLK = 13020) THEN
        CALC <= '1';
        TX_CONSE <= "01100011";
        ELSIF(KEY_CLK = 17360) THEN
        CALC <= '1';
        TX_CONSE <= "01100100";
        ELSIF(KEY_CLK = 21700) THEN
        CALC <= '1';
        TX_CONSE <= "01100101";
        ELSIF(KEY_CLK = 26040) THEN
        CALC <= '1';
        TX_CONSE <= "01100110";
        ELSIF(KEY_CLK = 30380) THEN
        CALC <= '1';
        TX_CONSE <= "01100111";
        ELSIF(KEY_CLK = 34710) THEN
        CALC <= '1';
        TX_CONSE <= "00001010";
        KEY_ONLY <= '0';
        END IF;
        ELSIF(KEY_PRESS = '1' AND KEY_CON = 3 AND KEY_ONLY = '1') THEN
        IF(KEY_CLK = 4340) THEN
        CALC <= '1';
        TX_CONSE <= "00110001";
        ELSIF(KEY_CLK = 8680) THEN
        CALC <= '1';
        TX_CONSE <= "00110010";
        ELSIF(KEY_CLK = 13020) THEN
        CALC <= '1';
        TX_CONSE <= "00110011";
        ELSIF(KEY_CLK = 17360) THEN
        CALC <= '1';
        TX_CONSE <= "00110100";
        ELSIF(KEY_CLK = 21700) THEN
        CALC <= '1';
        TX_CONSE <= "00110101";
        ELSIF(KEY_CLK = 26040) THEN
        CALC <= '1';
        TX_CONSE <= "00110110";
        ELSIF(KEY_CLK = 30380) THEN
        CALC <= '1';
        TX_CONSE <= "00110111";
        ELSIF(KEY_CLK = 34710) THEN
        CALC <= '1';
        TX_CONSE <= "00001010";
        KEY_ONLY <= '0';
        END IF;
        ELSIF(KEY_PRESS = '1' AND KEY_CON = 4 AND KEY_ONLY = '1') THEN
        IF(KEY_CLK = 4340) THEN
        CALC <= '1';
        TX_CONSE <= "00100001";
        ELSIF(KEY_CLK = 8680) THEN
        CALC <= '1';
        TX_CONSE <= "00100010";
        ELSIF(KEY_CLK = 13020) THEN
        CALC <= '1';
        TX_CONSE <= "00100011";
        ELSIF(KEY_CLK = 17360) THEN
        CALC <= '1';
        TX_CONSE <= "00100100";
        ELSIF(KEY_CLK = 21700) THEN
        CALC <= '1';
        TX_CONSE <= "00100101";
        ELSIF(KEY_CLK = 26040) THEN
        CALC <= '1';
        TX_CONSE <= "00100110";
        ELSIF(KEY_CLK = 30380) THEN
        CALC <= '1';
        TX_CONSE <= "00100111";
        ELSIF(KEY_CLK = 34710) THEN
        CALC <= '1';
        TX_CONSE <= "00001010";
        KEY_ONLY <= '0';
        END IF;
    END IF;
END IF;
IF(CLK'EVENT AND CLK = '1') THEN
TX <= TX_PAUSE;
END IF;
END PROCESS;
end Behavioral;
