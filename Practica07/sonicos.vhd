LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY sonicos IS
	PORT (
		clk : IN STD_LOGIC;
		led, sensor_disp : OUT STD_LOGIC;
		sensor_eco : IN STD_LOGIC;
		control : OUT STD_LOGIC;
		Ucm, Dcm : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END sonicos;

ARCHITECTURE Behavioral OF sonicos IS

	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF reloj : SIGNAL IS "P11";
	ATTRIBUTE chip_pin OF UD : SIGNAL IS "C12";
	ATTRIBUTE chip_pin OF rst : SIGNAL IS "D12";
	ATTRIBUTE chip_pin OF FH : SIGNAL IS "C11,C10";
	ATTRIBUTE chip_pin OF MOT : SIGNAL IS "W7,W8,W9,W10";

	SIGNAL cuenta : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
	SIGNAL contador_s : INTEGER RANGE 0 TO 150000000 := 0;
	SIGNAL centimetros : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centimetros_unid : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centimetros_dece : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sal_unid : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sal_dece : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL eco_pasado : STD_LOGIC := '0';
	SIGNAL eco_sinc : STD_LOGIC := '0';
	SIGNAL eco_nsinc : STD_LOGIC := '0';
	SIGNAL espera : STD_LOGIC := '0';
	SIGNAL value1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0F";
	SIGNAL UM, DM : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL reloj_divi : STD_LOGIC;
	SIGNAL ancho : STD_LOGIC_VECTOR (7 DOWNTO 0) := X"0F";
	SIGNAL mover : STD_LOGIC := '0';
	TYPE estados IS (Abierto, Cerrado);
	SIGNAL E_presente, E_siguiente : estados := Cerrado;

BEGIN

	Trigger : PROCESS (clk) BEGIN
		IF rising_edge(clk) THEN
			IF espera = '0' THEN
				IF cuenta = 500 THEN
					sensor_disp <= '0';
					espera <= '1';
					cuenta <= (OTHERS => '0');
				ELSE
					sensor_disp <= '1';
					cuenta <= cuenta + 1;
				END IF;
			ELSIF eco_pasado = '0' AND eco_sinc = '1' THEN
				cuenta <= (OTHERS => '0');
				centimetros <= (OTHERS => '0');
				centimetros_unid <= (OTHERS => '0');
				centimetros_dece <= (OTHERS => '0');
			ELSIF eco_pasado = '1' AND eco_sinc = '0' THEN
				sal_unid <= centimetros_unid;
				sal_dece <= centimetros_dece;
			ELSIF cuenta = 2900 - 1 THEN
				IF centimetros_unid = 9 THEN
					centimetros_unid <= (OTHERS => '0');
					centimetros_dece <= centimetros_dece + 1;
				ELSE
					centimetros_unid <= centimetros_unid + 1;
				END IF;
				centimetros <= centimetros + 1;
				cuenta <= (OTHERS => '0');
				IF centimetros = 3448 THEN
					espera <= '0';
				END IF;
			ELSE
				cuenta <= cuenta + 1;
			END IF;
			eco_pasado <= eco_sinc;
			eco_sinc <= eco_nsinc;
			eco_nsinc <= sensor_eco;
		END IF;
	END PROCESS;

	DecoUnidades : PROCESS (sal_unid)
	BEGIN
		IF sal_unid = X"0" THEN
			Ucm <= "1000000";
		ELSIF sal_unid = X"1" THEN
			Ucm <= "1111001";
		ELSIF sal_unid = X"2" THEN
			Ucm <= "0100100";
		ELSIF sal_unid = X"3" THEN
			Ucm <= "0110000";
		ELSIF sal_unid = X"4" THEN
			Ucm <= "0011001";
		ELSIF sal_unid = X"5" THEN
			Ucm <= "0010010";
		ELSIF sal_unid = X"6" THEN
			Ucm <= "0000010";
		ELSIF sal_unid = X"7" THEN
			Ucm <= "0111000";
		ELSIF sal_unid = X"8" THEN
			Ucm <= "0000000";
		ELSIF sal_unid = X"9" THEN
			Ucm <= "0011000";
		ELSE
			Ucm <= "1111111";
		END IF;
	END PROCESS;

	DecoDecenas : PROCESS (sal_dece)
	BEGIN
		IF sal_dece = X"0" THEN
			Dcm <= "1000000";
		ELSIF sal_dece = X"1" THEN
			Dcm <= "1111001";
		ELSIF sal_dece = X"2" THEN
			Dcm <= "0100100";
		ELSIF sal_dece = X"3" THEN
			Dcm <= "0110000";
		ELSIF sal_dece = X"4" THEN
			Dcm <= "0011001";
		ELSIF sal_dece = X"5" THEN
			Dcm <= "0010010";
		ELSIF sal_dece = X"6" THEN
			Dcm <= "0000010";
		ELSIF sal_dece = X"7" THEN
			Dcm <= "0111000";
		ELSIF sal_dece = X"8" THEN
			Dcm <= "0000000";
		ELSIF sal_dece = X"9" THEN
			Dcm <= "0011000";
		ELSE
			Dcm <= "1111111";
		END IF;
	END PROCESS;

	ContadorS : PROCESS (sal_unid, sal_dece, clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (sal_unid = X"5" AND sal_dece = X"1") THEN
				led <= '1';
				mover <= '1';
			ELSE
				led <= '0';
				mover <= '0';
			END IF;
		END IF;
	END PROCESS;

	DiviServo : PROCESS (clk)
		CONSTANT N : INTEGER := 11;
		VARIABLE cuenta_divi : STD_LOGIC_VECTOR (27 DOWNTO 0) := X"0000000";
	BEGIN
		IF rising_Edge(clk) THEN
			cuenta_divi := cuenta_divi + 1;
		END IF;
		reloj_divi <= cuenta_divi(N);
	END PROCESS;

	PWM : PROCESS (reloj_divi)
		VARIABLE cuenta_pwm : INTEGER RANGE 0 TO 255 := 0;
	BEGIN
		IF reloj_divi = '1' AND reloj_divi 'event THEN
			cuenta_pwm := (cuenta_pwm + 1) MOD 256;
			IF cuenta_pwm < ancho THEN
				control <= '1';
			ELSE
				control <= '0';
			END IF;
		END IF;
	END PROCESS;
	PROCESS (E_presente, clk)
	BEGIN
		IF rising_edge(clk) THEN
			CASE E_presente IS
				WHEN Cerrado =>
					IF mover = '1' THEN
						E_siguiente <= Abierto;
					END IF;
				WHEN Abierto =>
					IF mover = '0'THEN
						IF contador_s = 0 THEN
							E_siguiente <= Cerrado;
						END IF;
						contador_s <= contador_s - 1;
					ELSE
						contador_s <= 150000000;
					END IF;
			END CASE;
			E_presente <= E_siguiente;
		END IF;
	END PROCESS;

	PROCESS (E_presente) IS
	BEGIN
		CASE E_presente IS
			WHEN Abierto => value1 <= X"09";
			WHEN Cerrado => value1 <= X"1F";
			WHEN OTHERS => value1 <= X"09";
		END CASE;
	END PROCESS;

	PROCESS (reloj_divi, mover)
		VARIABLE count : INTEGER RANGE 0 TO 1023 := 0;
	BEGIN
		IF reloj_divi = '1' AND reloj_divi 'event THEN
			IF count > 0 THEN
				count := count - 1;
			ELSE
				count := 1023;
				ancho <= value1;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;