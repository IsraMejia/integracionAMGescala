LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY TX IS
	PORT (
		reloj : IN STD_LOGIC;
		SW : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		LED : OUT STD_LOGIC;
		TX_WIRE : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaivoral OF TX IS
	SIGNAL conta : INTEGER := 0;
	SIGNAL valor : INTEGER := 70000;
	SIGNAL INICIO : STD_LOGIC;
	SIGNAL dato : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL PRE : INTEGER RANGE 0 TO 5208 := 0;
	SIGNAL INDICE : INTEGER RANGE 0 TO 9 := 0;
	SIGNAL BUFF : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL Flag : STD_LOGIC := '0';
	SIGNAL PRE_val : INTEGER RANGE 0 TO 41600;
	SIGNAL baud : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL i : INTEGER RANGE 0 TO 4;
	SIGNAL pulso : STD_LOGIC := '0';
	SIGNAL conta2 : INTEGER RANGE 0 TO 49999999 := 0;
	SIGNAL dato_bin : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL hex_val, hex_val1, hex_val2, hex_val3, hex_val4, hex_val5, hex_val6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL contador : INTEGER := 0;
	TYPE estados IS (I, S, R, A, E, L, vacio);
	SIGNAL e_presente, e_siguiente : estados := J;
	SIGNAL Q : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
	TYPE arreglo IS ARRAY (0 TO 4) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL asc_dato : arreglo := (X"30", X"30", X"30", X"30", X"30", X"30", X"0A");

	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF reloj : SIGNAL IS "P11";
	ATTRIBUTE chip_pin OF SW : SIGNAL IS "C12,D12,C11,C10";
	ATTRIBUTE chip_pin OF LED : SIGNAL IS "A8";
	ATTRIBUTE chip_pin OF TX_WIRE : SIGNAL IS "W10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ";

BEGIN
	TX_divisor : PROCESS (reloj)
	BEGIN
		IF rising_edge(reloj) THEN
			contador <= contador + 1;
			IF (contador < 140000) THEN
				pulso <= '1';
			ELSE
				pulso <= '0';
			END IF;
		END IF;
	END PROCESS TX_divisor;

	TX_prepara : PROCESS (reloj, pulso)
		--type arreglo is array (0 to 1) of STD_LOGIC_VECTOR(7 downto 0);
		--variable asc_dato : arreglo := (X"30",X"0A");
	BEGIN
		asc_dato(0) <= hex_val;
		asc_dato(1) <= hex_val1;
		asc_dato(2) <= hex_val2;
		asc_dato(3) <= hex_val3;
		asc_dato(4) <= hex_val4;
		asc_dato(5) <= hex_val5;
		asc_dato(6) <= hex_val6;

		IF (pulso = '1') THEN
			IF rising_edge(reloj) THEN
				IF (conta = valor) THEN
					conta <= 0;
					INICIO <= '1';
					Dato <= asc_dato(i);
					IF (i = 4) THEN
						i <= 0;
					ELSE
						i <= i + 1;
					END IF;
				ELSE
					conta <= conta + 1;
					inicio <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS TX_prepara;

	TX_envia : PROCESS (reloj, inicio, dato)
	BEGIN
		IF (reloj'EVENT AND reloj = '1') THEN
			IF (Flag = '0' AND INICIO = '1') THEN
				Flag <= '1';
				BUFF(0) <= '0';
				BUFF(9) <= '1';
				BUFF(8 DOWNTO 1) <= dato;
			END IF;
			IF (Flag = '1') THEN
				IF (PRE < PRE_val) THEN
					PRE <= PRE + 1;
				ELSE
					PRE <= 0;
				END IF;
				IF (PRE = PRE_val/2) THEN
					TX_WIRE <= BUFF(INDICE);
					IF (INDICE < 9) THEN
						INDICE <= INDICE + 1;
					ELSE
						Flag <= '0';
						INDICE <= 0;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS TX_envia;

	LED <= pulso;
	dato_bin <= SW;
	baud <= "011";
	--with(dato_bin) select
	--hex_val <= X"30" when "0000",
	--X"31" when "0001",
	--X"32" when "0010",
	--X"33" when "0011",
	--X"34" when "0100",
	--X"35" when "0101",
	--X"36" when "0110",
	--X"37" when "0111",
	--X"38" when "1000",
	--X"39" when "1001",
	--X"41" when "1010",
	--X"42" when "1011",
	--X"43" when "1100",
	--X"44" when "1101",
	--X"45" when "1110",
	--X"46" when "1111",
	--X"23" when others;

	PROCESS (reloj)
	BEGIN
		IF rising_edge(reloj) THEN
			CASE e_presente IS
				WHEN I =>
					e_siguiente <= S;
				WHEN S =>
					e_siguiente <= R;
				WHEN R =>
					e_siguiente <= A;
				WHEN E =>
					e_siguiente <= L;
				WHEN L =>
					e_siguiente <= M;
				WHEN M =>
					e_siguiente <= vacio;

				WHEN OTHERS =>
					e_siguiente <= vacio;
			END CASE;
			e_presente <= e_siguiente;
		END IF;
	END PROCESS;
	PROCESS (e_presente)
	BEGIN
		CASE e_presente IS
			WHEN I => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			WHEN S => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			WHEN R => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			WHEN A => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M

			WHEN E => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			WHEN L => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			WHEN M => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M
			
			--WHEN N => hex_val <= X"4A";
			--	hex_val1 <= X"55";
			--	hex_val2 <= X"41";
			--	hex_val3 <= X"4A";

			WHEN vacio => 	hex_val <= X"49"; --I
						hex_val1 <= X"53";--S
						hex_val2 <= X"52";--R
						hex_val3 <= X"41";--A
						hex_val4 <= X"45";--E
						hex_val5 <= X"4C";--L
						hex_val6 <= X"4D";--M

		END CASE;
	END PROCESS; 

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