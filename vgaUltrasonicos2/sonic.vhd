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
		Ucm, Dcm : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END sonicos;

ARCHITECTURE Behavioral OF sonicos IS
 
    SIGNAL cuenta : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
	SIGNAL contador_s : INTEGER RANGE 0 TO 125000000 := 0;
	
	--Maneja la distancia mas cercana antes del STOP
	SIGNAL centimetros : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centimetros_unid : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL centimetros_dece : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

	--Señales que se pasaran para el pingpong
	SIGNAL sal_unid : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sal_dece : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	
	--Para sincronizar las señales de eco
	SIGNAL eco_pasado : STD_LOGIC := '0';
	SIGNAL eco_sinc : STD_LOGIC := '0';
	SIGNAL eco_nsinc : STD_LOGIC := '0';
	SIGNAL espera : STD_LOGIC := '0';
 

BEGIN

	Trigger : PROCESS (clk) BEGIN
		IF rising_edge(clk) THEN
			
		IF espera = '0' THEN
				IF cuenta = 500 THEN --Por cada 500 pulssos de reloj se revisa el sensor ultrasonico (Señal Trigger)
					sensor_disp <= '0';
					espera <= '1';
					cuenta <= (OTHERS => '0');
				ELSE
					sensor_disp <= '1';
					cuenta <= cuenta + 1;
				END IF;

			--Calculo de la distancia	y contador de pulsos
			ELSIF eco_pasado = '0' AND eco_sinc = '1' THEN
				cuenta <= (OTHERS => '0');
				centimetros <= (OTHERS => '0');
				centimetros_unid <= (OTHERS => '0');
				centimetros_dece <= (OTHERS => '0');

			--Si se se mide la distancia del objeto que se encuentre en 4 bits
			ELSIF eco_pasado = '1' AND eco_sinc = '0' THEN
				sal_unid <= centimetros_unid;
				sal_dece <= centimetros_dece;

			--Cada 10 unidades se registra un aumento de 10 cm	
			ELSIF cuenta = 2900 - 1 THEN
				IF centimetros_unid = 9 THEN
					centimetros_unid <= (OTHERS => '0');
					centimetros_dece <= centimetros_dece + 1;
				ELSE --Si no son 10 unidades, el contador solo aumenta a unidades en 1cm
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
	
	Salidas : PROCESS (sal_unid, sal_dece, clk)
	BEGIN 
		IF rising_edge(clk) THEN
			IF (sal_unid = X"4" AND (sal_dece >= X"2" AND sal_dece <= X"6")) THEN
				led <= '1'; 
			ELSE
				led <= '0'; 
			END IF;
		END IF;
	END PROCESS;

	
	
	

END Behavioral;