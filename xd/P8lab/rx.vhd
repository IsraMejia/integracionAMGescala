LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY RX IS
    PORT (
        reloj : IN STD_LOGIC;
        LEDS : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        RX_WIRE : IN STD_LOGIC);
END ENTITY;

ARCHITECTURE behaivoral OF RX IS
    SIGNAL BUFF : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL Flag : STD_LOGIC := '0';
    SIGNAL PRE : INTEGER RANGE 0 TO 5208 := 0;
    SIGNAL INDICE : INTEGER RANGE 0 TO 9 := 0;
    SIGNAL PRE_val : INTEGER RANGE 0 TO 41600;
    SIGNAL baud : STD_LOGIC_VECTOR(2 DOWNTO 0); 

BEGIN
    RX_dato : PROCESS (reloj)
    BEGIN
        IF (reloj'EVENT AND reloj = '1') THEN
            IF (Flag = '0' AND RX_WIRE = '0') THEN
                Flag <= '1';
                INDICE <= 0;
                PRE <= 0;
            END IF;
            IF (Flag = '1') THEN
                BUFF(INDICE) <= RX_WIRE;
                IF (PRE < PRE_val) THEN
                    PRE <= PRE + 1;
                ELSE
                    PRE <= 0;
                END IF;
                IF (PRE = PRE_val/2) THEN
                    IF (INDICE < 9) THEN
                        INDICE <= INDICE + 1;
                    ELSE
                        IF (BUFF(0) = '0' AND BUFF(9) = '1') THEN
                            LEDS <= BUFF(8 DOWNTO 1);
                        ELSE
                            LEDS <= "00000000";
                        END IF;
                        Flag <= '0';
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS RX_dato;

    baud <= "011";
    WITH (baud) SELECT
    PRE_val <= 41600 WHEN "000", -- 1200 bauds
        20800 WHEN "001", -- 2400 bauds
        10400 WHEN "010", -- 4800 bauds
        5200 WHEN "011", -- 9600 bauds
        2600 WHEN "100", -- 19200 bauds
        1300 WHEN "101", -- 38400 bauds
        866 WHEN "110", -- 57600 bauds
        432 WHEN OTHERS; --115200 bauds
END ARCHITECTURE behaivoral;