LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Std_logic_arith.ALL;
USE IEEE.Std_logic_unsigned.ALL;

ENTITY Servomotor IS
	PORT (
		reloj_sv : IN STD_LOGIC;
		Pini, Pfin, Inc, Dec : IN STD_LOGIC;
		D1, D2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		control : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE Behavioral OF Servomotor IS
	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF reloj_sv 	: SIGNAL IS "P11";
	ATTRIBUTE chip_pin OF Pini 		: SIGNAL IS "C12";
	ATTRIBUTE chip_pin OF Pfin 		: SIGNAL IS "C10";
	ATTRIBUTE chip_pin OF Inc 		: SIGNAL IS "D12";
	ATTRIBUTE chip_pin OF Dec 		: SIGNAL IS "C11";
	ATTRIBUTE chip_pin OF control 	: SIGNAL IS "V5";
	ATTRIBUTE chip_pin OF D1 		: SIGNAL IS "C17,D17,E16,C16,C15,E15,C14";
	ATTRIBUTE chip_pin OF D2 		: SIGNAL IS "B17,A18,A17,B16,E18,D18,C18";

	COMPONENT divisor IS
		PORT (
			reloj : IN STD_LOGIC;
			div_reloj : OUT STD_LOGIC
		);

	END COMPONENT;

	COMPONENT pwm IS
		PORT (
			reloj_pwm : IN STD_LOGIC;
			D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			S : OUT STD_LOGIC
		);

	END COMPONENT;

	SIGNAL reloj_serv : STD_LOGIC;
	SIGNAL pulso : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
BEGIN
	U1 : divisor PORT MAP(reloj_sv, reloj_serv);
	U2 : pwm PORT MAP(reloj_serv, pulso, control);

	PROCESS (reloj_serv, Pini, Pfin, Inc, Dec)
		VARIABLE valor : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
		VARIABLE cuenta : INTEGER RANGE 0 TO 1023 := 0;

	BEGIN
		IF reloj_serv = '1' AND reloj_serv'event THEN
			IF (cuenta > 0) THEN
				cuenta := cuenta - 1;
			ELSE
				IF Pini = '1' THEN
					valor := X"00";

				ELSIF Pfin = '1' THEN
					valor := X"23";

				ELSIF Inc = '1' AND valor < X"23" THEN
					valor := valor + 1;

				ELSIF Dec = '1' AND valor > X"00" THEN
					valor := valor - 1;

				END IF;
				cuenta := 1023;
			END IF;
		END IF;
		pulso <= valor;

	END PROCESS;

	PROCESS (pulso)
	BEGIN
		IF (pulso = X"00") THEN
			D1 <= "1000000";
			D2 <= "1000000";
		ELSIF (pulso = X"01") THEN
			D1 <= "1111001";
			D2 <= "1000000";
		ELSIF (pulso = X"02") THEN
			D1 <= "0100100";
			D2 <= "1000000";
		ELSIF (pulso = X"03") THEN
			D1 <= "0110000";
			D2 <= "1000000";
		ELSIF (pulso = X"04") THEN
			D1 <= "0011001";
			D2 <= "1000000";
		ELSIF (pulso = X"05") THEN
			D1 <= "0010010";
			D2 <= "1000000";
		ELSIF (pulso = X"06") THEN
			D1 <= "0000010";
			D2 <= "1000000";
		ELSIF (pulso = X"07") THEN
			D1 <= "0111000";
			D2 <= "1000000";
		ELSIF (pulso = X"08") THEN
			D1 <= "0000000";
			D2 <= "1000000";
		ELSIF (pulso = X"09") THEN --9
			D1 <= "0010000";
			D2 <= "1000000";
		ELSIF (pulso = X"0A") THEN
			D1 <= "1000000";
			D2 <= "1111001";
		ELSIF (pulso = X"0B") THEN
			D1 <= "1111001";
			D2 <= "1111001";
		ELSIF (pulso = X"0C") THEN
			D1 <= "0100100";
			D2 <= "1111001";
		ELSIF (pulso = X"0D") THEN
			D1 <= "0110000";
			D2 <= "1111001";
		ELSIF (pulso = X"0E") THEN
			D1 <= "0011001";
			D2 <= "1111001";
		ELSIF (pulso = X"0F") THEN
			D1 <= "0010010";
			D2 <= "1111001";
		ELSIF (pulso = X"10") THEN
			D1 <= "0000010";
			D2 <= "1111001";
		ELSIF (pulso = X"11") THEN
			D1 <= "0111000";
			D2 <= "1111001";
		ELSIF (pulso = X"12") THEN
			D1 <= "0000000";
			D2 <= "1111001";
		ELSIF (pulso = X"13") THEN
			D1 <= "0010000"; --19
			D2 <= "1111001";
		ELSIF (pulso = X"14") THEN
			D1 <= "1000000";
			D2 <= "0100100";
		ELSIF (pulso = X"15") THEN
			D1 <= "1111001";
			D2 <= "0100100";
		ELSIF (pulso = X"16") THEN
			D1 <= "0100100";
			D2 <= "0100100";
		ELSIF (pulso = X"17") THEN
			D1 <= "0110000";
			D2 <= "0100100";
		ELSIF (pulso = X"18") THEN
			D1 <= "0011001";
			D2 <= "0100100";
		ELSIF (pulso = X"19") THEN
			D1 <= "0010010";
			D2 <= "0100100";
		ELSIF (pulso = X"1A") THEN
			D1 <= "0000010";
			D2 <= "0100100";
		ELSIF (pulso = X"1B") THEN
			D1 <= "0111000";
			D2 <= "0100100";
		ELSIF (pulso = X"1C") THEN
			D1 <= "0000000";
			D2 <= "0100100";
		ELSIF (pulso = X"1D") THEN
			D1 <= "0010000"; --29
			D2 <= "0100100";
		ELSIF (pulso = X"1E") THEN
			D1 <= "1000000";
			D2 <= "0110000";
		ELSIF (pulso = X"1F") THEN
			D1 <= "1111001";
			D2 <= "0110000";
		ELSIF (pulso = X"20") THEN
			D1 <= "0100100";
			D2 <= "0110000";
		ELSIF (pulso = X"21") THEN
			D1 <= "0110000";
			D2 <= "0110000";
		ELSIF (pulso = X"22") THEN
			D1 <= "0011001";
			D2 <= "0110000";
		ELSIF (pulso = X"23") THEN
			D1 <= "0010010";
			D2 <= "0110000";
		END IF;
	END PROCESS;
END behavioral;