library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity RX is
 port( 	reloj : IN STD_LOGIC;
			D1,D2,D3,D4,D5,D6 : buffer STD_LOGIC_VECTOR(6 downto 0);
			LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
			control: OUT STD_LOGIC;
			RX_WIRE : IN STD_LOGIC);
end entity;

architecture behaivoral OF RX IS
 signal BUFF: STD_LOGIC_VECTOR(9 downto 0);
 signal Flag: STD_LOGIC := '0';
 signal PRE: INTEGER RANGE 0 TO 5208 := 0;
 signal INDICE: INTEGER RANGE 0 TO 9 := 0;
 signal PRE_val: INTEGER range 0 to 41600;
 signal baud: STD_LOGIC_VECTOR(2 downto 0);
 signal registros: STD_LOGIC_VECTOR (7 downto 0) := "00000000";
 type estados is (ServoA, ServoC, Mensaje, Contador, Otros);
 signal e_presente, e_siguiente: estados := Otros;
 signal banderas: STD_LOGIC_VECTOR (3 downto 0) := "0000";
 signal Q: STD_LOGIC_VECTOR (3 downto 0) := "0000";
 signal segundo: STD_LOGIC;
 signal value1: STD_LOGIC_VECTOR(7 downto 0) := X"0D";
 signal n, z, reset: std_logic;
 signal Qum, Qdm: std_logic_vector(3 downto 0);
 signal ancho : STD_LOGIC_VECTOR (7 downto 0) := X"0D";
 signal reloj_divi: STD_LOGIC;
 
		--Asignacion de Pines
	attribute chip_pin : string;
	attribute chip_pin of reloj	    : signal is "P11";	
	attribute chip_pin of control		 : signal is "W10";	
 	attribute chip_pin of RX_WIRE		 : signal is "V10";
	attribute chip_pin of D1		    : signal is "C17,D17,E16,C16,C15,E15,C14"; 
	attribute chip_pin of D2		 	 : signal is "B17,A18,A17,B16,E18,D18,C18"; 
	attribute chip_pin of D3 			 : signal is "B22,C22,B21,A21,B19,A20,B20";	
 	attribute chip_pin of D4 			 : signal is "E17,D19,C20,C19,E21,E22,F21";
	attribute chip_pin of D5 			 : signal is "F20,F19,H19,J18,E19,E20,F18";	
 	attribute chip_pin of D6 			 : signal is "N20,N19,M20,N18,L18,K20,J20";
	attribute chip_pin of LEDS			 : signal is "D14,E14,C13,D13,B10,A10,A9,A8";
 
 begin
 
 divisor: process (reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	 begin
			if rising_edge (reloj) then
			if cuenta=X"48009E0" then
				cuenta:= X"0000000";
			else
				cuenta:=cuenta+1;
			end if;
			end if;
				segundo <=cuenta(22);
	 end process;
	 
 DiviServo:Process(reloj)
		constant N: INTEGER := 11;
		variable cuenta_divi: STD_LOGIC_VECTOR (27 downto 0) := X"0000000";
	begin
		if rising_Edge(reloj) then
			cuenta_divi := cuenta_divi +1;
		end if;
			reloj_divi <= cuenta_divi(N);
	end process;
	 
	PWM: process(reloj_divi)
		variable cuenta_pwm: INTEGER RANGE 0 TO 255 := 0;
	begin
		if reloj_divi = '1' and reloj_divi 'event then
			cuenta_pwm := (cuenta_pwm+1) mod 256;
		if cuenta_pwm < ancho then
			control <=  '1';
		else
			control <= '0';
		end if;
		end if;
	end process;
 
	 RX_dato : process(reloj)
	 begin
		if (reloj'EVENT and reloj = '1') then
			if (Flag = '0' and RX_WIRE = '0') then
				Flag<= '1';
				INDICE <= 0;
				PRE <= 0;
			end if;
			if (Flag = '1') then
				BUFF(INDICE)<=RX_WIRE;
				if(PRE < PRE_val) then
					PRE <= PRE + 1;
				else
					PRE <= 0;
				end if;
			if(PRE = PRE_val/2) then
				if(INDICE < 9) then
					INDICE <= INDICE + 1;
				else
					if(BUFF(0) = '0' and BUFF(9)= '1') then
						registros <= BUFF(8 DOWNTO 1);
						LEDS <= BUFF(8 DOWNTO 1);
					else
						registros <= "00000000";
						LEDS <= "00000000";
					end if;
					Flag <= '0';
				end if;
			end if;
			end if;
		end if;
	 end process RX_dato;
	 
	 baud<="011";
	 with (baud) select
	 PRE_val <= 41600	when "000", -- 1200 bauds
					20800	when "001", -- 2400 bauds
					10400 when "010", -- 4800 bauds
					5200 	when "011", -- 9600 bauds
					2600 	when "100", -- 19200 bauds
					1300 	when "101", -- 38400 bauds
					866 	when "110", -- 57600 bauds
					432 	when others; --115200 bauds
					
	Comportamiento: Process (e_presente, reloj)
		begin
			if rising_edge(reloj) then
				case e_presente is
					when Otros =>
						if registros = "00110001" then --se manda 1
							e_siguiente <= ServoA;
						elsif registros = "00110010" then --se manda 2
							e_siguiente <= ServoC;
						elsif registros = "00110011" then --se manda 3
							e_siguiente <= Mensaje;
						elsif registros = "00110100" then --se manda 4
							e_siguiente <= Contador;
						else
							e_siguiente <= Otros;
						end if;
					when ServoA =>
						if registros = "00110001" then
							e_siguiente <= ServoA;
						elsif registros = "00110010" then
							e_siguiente <= ServoC;
						elsif registros = "00110011" then
							e_siguiente <= Mensaje;
						elsif registros = "00110100" then
							e_siguiente <= Contador;
						else
							e_siguiente <= Otros;
						end if;
					when ServoC =>
						if registros = "00110001" then
							e_siguiente <= ServoA;
						elsif registros = "00110010" then
							e_siguiente <= ServoC;
						elsif registros = "00110011" then
							e_siguiente <= Mensaje;
						elsif registros = "00110100" then
							e_siguiente <= Contador;
						else
							e_siguiente <= Otros;
						end if;
					when Mensaje =>
							if registros = "00110001" then
								e_siguiente <= ServoA;
							elsif registros = "00110010" then
								e_siguiente <= ServoC;
							elsif registros = "00110011" then
								e_siguiente <= Mensaje;
							elsif registros = "00110100" then
								e_siguiente <= Contador;
							else
								e_siguiente <= Otros;
							end if;
					when Contador =>
						if registros = "00110001" then
							e_siguiente <= ServoA;
						elsif registros = "00110010" then
							e_siguiente <= ServoC;
						elsif registros = "00110011" then
							e_siguiente <= Mensaje;
						elsif registros = "00110100" then
							e_siguiente <= Contador;
						else
							e_siguiente <= Otros;
						end if;
					when others =>
						e_siguiente <= Otros;
				end case;
				e_presente <= e_siguiente;
			end if;
	end process;
	
	Asignacion: Process (e_presente)
	begin
		case e_presente is
			when ServoA 	=> banderas <= "0001";
			when ServoC 	=> banderas <= "0010";
			when Mensaje 	=> banderas <= "0100";
			when Contador 	=> banderas <= "1000";
			when others 	=> banderas <= "0000";
		end case;
	end process;
	
	
	cambioComportamiento: Process (banderas,segundo)
	begin
		if banderas = "0001" then
			value1 <= X"18";
			D1 <= "1111111";
			D2 <= "1111111";
			D4 <= "1111111";
			D5 <= "1111111";
			D6 <= "1111111";
			D3 <= "1111111";
			Q 	<= "0000";
		elsif banderas = "0010" then
			value1 <= X"0D";
			D1 <= "1111111";
			D2 <= "1111111";
			D4 <= "1111111";
			D5 <= "1111111";
			D6 <= "1111111";
			D3 <= "1111111";
			Q 	<= "0000";
		elsif banderas = "0100" then
		
			case Q is
				 when "0000" => D1 <= "0000110"; -- E
				 when "0001" => D1 <= "0101011"; -- n
				 when "0011" => D1 <= "1000111"; -- L
				 when "0100" => D1 <= "0001000"; -- A
				 when "0110" => D1 <= "1000000"; -- O
				 when "0111" => D1 <= "1000111"; -- L
				 when "1000" => D1 <= "0001000"; -- A
				 when others => D1 <= "1111111"; -- espacios
			end case;

			if rising_edge(segundo) then
				Q <= Q + 1;
				D2 <= D1;
				D3 <= D2;
				D4 <= D3;
				D5 <= D4;
				D6 <= D5;
			end if;
			
				 
		elsif banderas = "1000" then			
			Case Qum is
				when "0000" => D1 <= "1000000";  --0
				when "0001" => D1 <= "1111001"; --1
				when "0010" => D1 <= "0100100"; --2
				when "0011" => D1 <= "0110000"; --3
				when "0100" => D1 <= "0011001"; --4
				when "0101" => D1 <= "0010010"; --5
				when "0110" => D1 <= "0000010"; --6
				when "0111" => D1 <= "1111000"; --7
				when "1000" => D1 <= "0000000"; --8
				when "1001" => D1 <= "0010000"; --9
				when others => D1 <= "1000000"; --F
			end case;
		

			Case Qdm is
				when "0000" => D2 <= "1000000";  --0
				when "0001" => D2 <= "1111001"; --1
				when "0010" => D2 <= "0100100"; --2
				when "0011" => D2 <= "0110000"; --3
				when "0100" => D2 <= "0011001"; --4
				when "0101" => D2 <= "0010010"; --5
				when "0110" => D2 <= "0000010"; --6
				when "0111" => D2 <= "1111000"; --7
				when "1000" => D2 <= "0000000"; --8
				when "1001" => D2 <= "0010000"; --9
				when others => D2 <= "1000000"; --F
			end case;
						
			D4 <= "1111111";
			D5 <= "1111111";
			D6 <= "1111111";
			D3 <= "1111111";
			Q 	<= "0000";
			
		else
			D1 <= "1111111";
			D2 <= "1111111";
			D3 <= "0001000";
			D4 <= "0101011";
			D6 <= "1111111";
			D5 <= "1111111";
			Q 	<= "0000";
		end if;
	end process;
		
	Process(reloj_divi)
		variable count: INTEGER RANGE 0 TO 1023 :=0;
	begin
		if reloj_divi = '1' and reloj_divi 'event then
		if count > 0 then
			count := count -1;
		else
			count := 1023;
			ancho <= value1;
		end if;
		end if;
	end process;
	
	unidades: process (segundo)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (segundo) then
		if cuenta ="1001" then
			cuenta:="0000";
			n <= '1';
			reset <= '0';
		elsif (Qum = "0110" and Qdm = "0111") or banderas /= "1000" then
			cuenta:= "0000";
			reset <= '1';
			n <= '1';
		else
			cuenta:= cuenta +1;
			n <= '0';
		end if;end if;
			Qum <= cuenta;
	end process;

	decenas: process (segundo)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (n) then
		if reset = '1' then
			cuenta:="0000";
		else
			cuenta:= cuenta +1;
		end if; end if;
			Qdm <= cuenta;
	end process;
		
end architecture behaivoral;