
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity practica1 is
    Port ( 
		reloj : in std_logic;
        display1 : out std_logic_vector (6 downto 0);
		display2 : out std_logic_vector (6 downto 0); 
        display3 : out std_logic_vector (6 downto 0);
        display4 : out std_logic_vector (6 downto 0)
	);
end practica1;

architecture Behavioral of practica1 is
    signal segundo : std_logic ; --	Señal de segundos del divisor de frecuencia
		--Señales para iniciar procesos entre unidades del contador
    signal N : std_logic;
	signal E : std_logic;
	signal reset : std_logic;
	signal z : std_logic; 

		--Señales que le llegaran a los displays antes del deco
    signal  Um 	: std_logic_vector(3 downto 0) := "0000";
	signal  Dm  : std_logic_vector(3 downto 0) := "0000";
	signal  Uh  : std_logic_vector(3 downto 0) := "0000";
	signal  Dh  : std_logic_vector(3 downto 0) := "0000"; 

	--Asignacion de Pines
	attribute chip_pin : string;
	attribute chip_pin of reloj	       : signal is "P11";	
 	attribute chip_pin of display1	   : signal is "C17,D17,E16,C16,C15,E15,C14";
	attribute chip_pin of display2	   : signal is "B17,A18,A17,B16,E18,D18,C18"; 
	attribute chip_pin of display3	   : signal is "B22,C22,B21,A21,B19,A20,B20"; 
	attribute chip_pin of display4	   : signal is "E17,D19,C20,C19,E21,E22,F21"; 

begin
	--Divisor de frecuencias para usar el reloj de la DE10LITE
    Divi : process (reloj) --Se activa cuando hay cambios en el reloj
        variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
		begin
			if rising_edge(reloj) then
				if cuenta = X"48009E0" then --Se llega al limite de cuenta
					cuenta := X"0000000";
				else
					cuenta := cuenta + 1;
				end if;
			end if;
			--segundo <= cuenta(22);
			segundo <= cuenta(19);
    end process;
	  
    minUnidades: process (segundo)
		variable cuenta: std_logic_vector( 3 downto 0) := "0000";
		begin
			if rising_edge (segundo) then
				if cuenta ="1001" then  -- 9 limite de unidades segundos
					cuenta :="0000";
					N <= '1';
				else
					cuenta := cuenta + 1;
					N <= '0';
				end if; 
			end if;
			Um <= cuenta; --Señal de unidades de min que se manda al muxy
	end process;
 
	minDecenas: process (segundo)
		variable cuenta: std_logic_vector( 3 downto 0) := "0000";
		begin
			if rising_edge (N) then
			if cuenta ="0101" then -- 5 limite de unidades segundos
				cuenta :="0000";
				E <= '1';
			else
				cuenta := cuenta +1;
				E <='0';
			end if; end if;
			Dm <= cuenta; --Señal de Decenas de min que se manda al muxy
	end process;
 
	horasUnidades: process(segundo) --Al ser sincrono, se activa cada segundo
		variable cuenta: std_logic_vector(3 downto 0):="0000";
		begin
			if rising_edge (E)  then 	--Si hay un flanco de subida en E
				if cuenta ="1001" then  -- 9 Limite unidades de hora
					cuenta:="0000";
					Z <= '1';	--Avisar que paso una decena de hora
					reset <='0';
				elsif  Uh = "0001" AND Dh ="0001"  then  
					--Si ya va a pasar otra unidad de hora sabiendo que son las 12
					cuenta := "0000";
					reset <='1';
					Z <= '1'; --Avisar que paso una decena de hora
				else 
					cuenta := cuenta+1; -- Se agrega una unidad de hora
					Z<='0';
					reset <='0';
				end if; 
			end if;
			Uh <= cuenta; -- Señal de unidades de horas que se manda al muxy
	end process;
 
	horasDecenas: process (segundo) --Al ser sincrono, se activa cada segundo
		variable cuenta: std_logic_vector(3 downto 0):="0000";
		begin
			if rising_edge(Z) then --Si hay un flanco de subida en Z
				if reset= '1' then
					cuenta:= "0000"; --Se manda a reiniciar en el reset
				else
					cuenta:= cuenta+1;
					--Si es 0 puede subir a 1
				end if; 
			end if;
			Dh <= cuenta; -- Señal de Decenas de horas que se manda al muxy
	end process;
 

    with Um select
        display1 <= "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
					"1000000" when others; --0

    with Dm select
        display2 <= "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"1000000" when others; --0

    with Uh select
        display3 <= "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
					"1000000" when others; --0
    
    with Dh select
        display4 <= "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"1000000" when others; --0

end Behavioral;
