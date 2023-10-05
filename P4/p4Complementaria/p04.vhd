-- Práctica 04; VLSI grupo 04
-- Realizado por:
-- Hernández Jiménez Juan Carlos
-- Mejía Alba Israel Hipolito


library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_unsigned.all;

entity p04 is
	Generic (FREQ_CLK: integer := 50_000_00);
   Port ( 
			 CLK: IN STD_LOGIC;
			 IND: buffer std_logic;
			 LED: out std_logic;
			 FILAS: out std_logic_vector(3 downto 0);
			 COLUMNAS: in std_logic_vector(3 downto 0);
			 D0, D1, D2, D3: buffer std_logic_vector(6 downto 0);
			 Ds1, Ds2: out std_logic_vector(6 downto 0)
	);
end p04;

architecture behavioral of p04 is
	--Asignacion de Pines
	attribute chip_pin : string;
	attribute chip_pin of clk	     : signal is "P11";	
 	attribute chip_pin of D0	  	 : signal is "C17,D17,E16,C16,C15,E15,C14";
	attribute chip_pin of D1	   	 : signal is "B17,A18,A17,B16,E18,D18,C18"; 
	attribute chip_pin of D2	   	 : signal is "B22,C22,B21,A21,B19,A20,B20"; 
	attribute chip_pin of D3	   	 : signal is "E17,D19,C20,C19,E21,E22,F21"; 
	attribute chip_pin of Ds2	   	 : signal is "F20,F19,H19,J18,E19,E20,F18"; 
	attribute chip_pin of Ds1	  	 : signal is "N20,N19,M20,N18,L18,K20,J20";
	attribute chip_pin of LED	     : signal is "A8";	
	attribute chip_pin of FILAS	     : signal is "Y7,78,AA10,W11";	
	attribute chip_pin of COLUMNAS	 : signal is "Y11,AB13,W13,AA15";	 

	CONSTANT DELAY_1MS  : INTEGER := (FREQ_CLK/1000)-1;
	CONSTANT DELAY_10MS : INTEGER := (FREQ_CLK/100)-1;
	
	SIGNAL CONTA_1MS: INTEGER RANGE 0 TO DELAY_1MS;
	SIGNAL CONTA_10MS: INTEGER RANGE 0 TO DELAY_10MS;
	
	SIGNAL BANDERA: STD_LOGIC; --Eventos de 1ms
	SIGNAL BANDERA2: STD_LOGIC; --eventos de 10 ms

	SIGNAL IND_S : STD_LOGIC := '0';
	SIGNAL EDO : INTEGER RANGE 0 TO 1 := 0;
	SIGNAL FILA : INTEGER RANGE 0 TO 3 := 0;
	SIGNAL FILA_REG_S : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL BOTON_PRES: STD_LOGIC_VECTOR(3 DOWNTO 0); 
	
	SIGNAL Display : STD_LOGIC_VECTOR(6 DOWNTO 0);

	SIGNAL Bot_1: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_2: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_3: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_4: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_5: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_6: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_7: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_8: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_9: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_0: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_A: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_B: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_C: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_D: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_AS: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Bot_GA: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	Type estados is (e1,e2,e3,e4,e5);
	Signal estado_actual, estado_siguiente: estados;

	signal reiniciar : STD_LOGIC_VECTOR (3 downto 0) := "0000";

begin
    FILAS <= FILA_REG_S;

	-- RETARDO 1 MS --
	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CONTA_1MS <= CONTA_1MS + 1;
			BANDERA <= '0'; --1ms
			IF CONTA_1MS = DELAY_1MS THEN
				CONTA_1MS <= 0;
				BANDERA <= '1';
			END IF;
		END IF;
	END PROCESS;

	-- RETARDO 10 MS --
	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CONTA_10MS <= CONTA_10MS + 1;
			BANDERA2 <= '0';
			IF CONTA_10MS = DELAY_10MS THEN
				CONTA_10MS <= 0;
				BANDERA2 <= '1'; --10 ms
			END IF;
		END IF;
	END PROCESS;

	-- PROCESO EN LAS FILAS ----
	PROCESS(CLK, BANDERA2) --10ms
	BEGIN
		IF RISING_EDGE(CLK) AND BANDERA2 = '1' THEN
			FILA <= FILA + 1;
			IF FILA = 3 THEN
				FILA <= 0;
			END IF;
		END IF;
	END PROCESS;

	WITH FILA SELECT
		FILA_REG_S     <= "1000" WHEN 0,
						  "0100" WHEN 1,
						  "0010" WHEN 2,
						  "0001" WHEN OTHERS;

	-- PROCESO EN EL TECLADO AL SELECCIONAR UN VALOR --
	PROCESS(CLK, BANDERA)
	BEGIN
		IF RISING_EDGE(CLK) AND BANDERA = '1' THEN 
			IF FILA_REG_S = "1000" THEN
				Bot_1 <= Bot_1(6 DOWNTO 0) & COLUMNAS(3);
				Bot_2 <= Bot_2(6 DOWNTO 0) & COLUMNAS(2);
				Bot_3 <= Bot_3(6 DOWNTO 0) & COLUMNAS(1);
				Bot_A <= Bot_A(6 DOWNTO 0) & COLUMNAS(0);
			ELSIF FILA_REG_S = "0100" THEN
				Bot_4 <= Bot_4(6 DOWNTO 0) & COLUMNAS(3);
				Bot_5 <= Bot_5(6 DOWNTO 0) & COLUMNAS(2);
				Bot_6 <= Bot_6(6 DOWNTO 0) & COLUMNAS(1);
				Bot_B <= Bot_B(6 DOWNTO 0) & COLUMNAS(0);
			ELSIF FILA_REG_S = "0010" THEN
				Bot_7 <= Bot_7(6 DOWNTO 0) & COLUMNAS(3);
				Bot_8 <= Bot_8(6 DOWNTO 0) & COLUMNAS(2);
				Bot_9 <= Bot_9(6 DOWNTO 0) & COLUMNAS(1);
				Bot_C <= Bot_C(6 DOWNTO 0) & COLUMNAS(0);
			ELSIF FILA_REG_S = "0001" THEN
				Bot_AS <= Bot_AS(6 DOWNTO 0) & COLUMNAS(3);
				Bot_0 <= Bot_0(6 DOWNTO 0) & COLUMNAS(2);
				Bot_GA <= Bot_GA(6 DOWNTO 0) & COLUMNAS(1);
				Bot_D <= Bot_D(6 DOWNTO 0) & COLUMNAS(0);
			END IF;
		END IF;
	END PROCESS;

	-- SALIDA --
	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			IF Bot_0 		= "11111111" THEN BOTON_PRES <= X"0"; IND_S <= '1';
			ELSIF Bot_1 	= "11111111" THEN BOTON_PRES <= X"1"; IND_S <= '1';
			ELSIF Bot_2 	= "11111111" THEN BOTON_PRES <= X"2"; IND_S <= '1';
			ELSIF Bot_3		= "11111111" THEN BOTON_PRES <= X"3"; IND_S <= '1';
			ELSIF Bot_4 	= "11111111" THEN BOTON_PRES <= X"4"; IND_S <= '1';
			ELSIF Bot_5 	= "11111111" THEN BOTON_PRES <= X"5"; IND_S <= '1';
			ELSIF Bot_6 	= "11111111" THEN BOTON_PRES <= X"6"; IND_S <= '1';
			ELSIF Bot_7 	= "11111111" THEN BOTON_PRES <= X"7"; IND_S <= '1';
			ELSIF Bot_8 	= "11111111" THEN BOTON_PRES <= X"8"; IND_S <= '1';
			ELSIF Bot_9 	= "11111111" THEN BOTON_PRES <= X"9"; IND_S <= '1';
			ELSIF Bot_A 	= "11111111" THEN BOTON_PRES <= X"A"; IND_S <= '1';
			ELSIF Bot_B 	= "11111111" THEN BOTON_PRES <= X"B"; IND_S <= '1';
			ELSIF Bot_C 	= "11111111" THEN BOTON_PRES <= X"C"; IND_S <= '1';
			ELSIF Bot_D 	= "11111111" THEN BOTON_PRES <= X"D"; IND_S <= '1';
			ELSIF Bot_AS 	= "11111111" THEN BOTON_PRES <= X"E"; IND_S <= '1';
			ELSIF Bot_GA 	= "11111111" THEN BOTON_PRES <= X"F"; IND_S <= '1';
			ELSE  IND_S <= '0';
			END IF;
		END IF;
	END PROCESS;

	-- ACTIVACIÓN PARA LA BANDERA UN CICLO DE RELOJ --
	PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			IF EDO = 0 THEN
				IF IND_S = '1' THEN
					IND <= '1';
					EDO <= 1;
				ELSE
					EDO <= 0;
					IND <= '0';
				END IF;
			ELSE
				IF IND_S = '1' THEN
					EDO <= 1;
					IND <= '0';
				ELSE
					EDO <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
		-- 7-Decodificador del Display
	PROCESS(BOTON_PRES)
	BEGIN
		CASE BOTON_PRES IS
			WHEN "0000" => Display <= "1000000"; -- 0
			WHEN "0001" => Display <= "1111001"; -- 1
			WHEN "0010" => Display <= "0100100"; -- 2
			WHEN "0011" => Display <= "0110000"; -- 3
			WHEN "0100" => Display <= "0011001"; -- 4
			WHEN "0101" => Display <= "0010010"; -- 5
			WHEN "0110" => Display <= "0000010"; -- 6
			WHEN "0111" => Display <= "1111000"; -- 7
			WHEN "1000" => Display <= "0000000"; -- 8
			WHEN "1001" => Display <= "0010000"; -- 9
			WHEN "1010" => Display <= "0001000"; -- A
			WHEN "1011" => Display <= "0000011"; -- B
			WHEN "1100" => Display <= "1000110"; -- C
			WHEN "1101" => Display <= "0100001"; -- D
			WHEN "1110" => Display <= "0011100"; -- *
			WHEN "1111" => Display <= "0110110"; -- #
			WHEN OTHERS => Display <= "1111111";  
		END CASE;
	END PROCESS;
	
	--Inicio de la máquina de estados
	PROCESS(clk)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			estado_actual <= estado_siguiente;
		END IF;
	END PROCESS;
	
	--Máquina de estados
	PROCESS(estado_actual)
	BEGIN
		CASE estado_actual IS
			WHEN e1 =>
				IF ( BOTON_PRES = X"1" and IND = '1') then
					estado_siguiente <= e2;
				ELSE
					estado_siguiente <= e1;
				END IF;
				
			WHEN e2 =>
				IF ( BOTON_PRES = X"2" and IND = '1') then
					estado_siguiente <= e3;
				ELSE
					estado_siguiente <= e1;
				END IF;
			
			WHEN e3 =>
				IF ( BOTON_PRES = X"3" and IND = '1') then
					estado_siguiente <= e4;
				ELSE
					estado_siguiente <= e1;
				END IF;
			
			WHEN e4 =>
				IF ( BOTON_PRES = X"4" and IND = '1') then
					estado_siguiente <= e5;
				ELSE
					estado_siguiente <= e1;
				END IF;
				
			WHEN e5 =>
				estado_siguiente <= e1;
		END CASE;
	END PROCESS;
	
	--DESPLAZAMIENTO DISPLAYS 
	PROCESS(IND)
	BEGIN
		IF reiniciar = 5 THEN
			reiniciar <= "0000";
			D0 <= "0111111";
			D1 <= "0111111";
			D2 <= "0111111";
			D3 <= "0111111";
		ELSE
			IF IND = '1' THEN
				D3 <= D2;
				reiniciar <= reiniciar+1;
				D2 <= D1;
				reiniciar <= reiniciar+1;
				D1 <= D0;
				reiniciar <= reiniciar+1;
				D0 <= Display;
				reiniciar <= reiniciar+1;
			END IF;
		END IF;
	END PROCESS;

	--PASSWORD 9*79
	PROCESS(CLK)
	BEGIN
		IF rising_edge (CLK) THEN
		IF reiniciar = 4 THEN
		IF (D3 = "0010000" AND D2 = "0011100" AND D1 = "1111000" AND D0 = "0010000") THEN
			LED <= '1';		
			Ds1 <= "0010010";
			Ds2 <= "1101111";
		ELSE
			LED <= '0';
			Ds1 <= "0101011";
			Ds2 <= "0100011";
		END IF;
		ELSE
			Ds1 <= "1111111";
			Ds2 <= "1111111";
		END IF;
		END IF;
	END PROCESS;
end behavioral;