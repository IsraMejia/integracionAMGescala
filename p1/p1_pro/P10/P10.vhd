
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity P10 is
    Port ( 
		reloj : in std_logic;
        display1, display2, display3, display4: out std_logic_vector (6 downto 0)
	);
end P10;

architecture Behavioral of P10 is
    signal segundo : std_logic ;
    signal N, E, reset, Z: std_logic;
    signal U, D, H1, H2: std_logic_vector(3 downto 0) := "0000";
begin
    Divi : process (reloj) 
        variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
    begin
        if rising_edge(reloj) then
            if cuenta = X"48009E0" then
                cuenta := X"0000000";
            else
                cuenta := cuenta + 1;
            end if;
        end if;
		segundo <= cuenta(22);
    end process;
	 
	-- el divisor se queda igual, no hay cambios

    Unidades: process (segundo)
	variable cuenta: std_logic_vector( 3 downto 0) := "0000";
begin
	if rising_edge (segundo) then
	if cuenta ="1001" then
		cuenta :="0000";
		N <= '1';
	else
		cuenta := cuenta + 1;
		N <= '0';
	end if; end if;
	U <= cuenta;
end process;

-- Unidades no sufrió ningún cambio.

Decenas: process (segundo)
	variable cuenta: std_logic_vector( 3 downto 0) := "0000";
begin
	if rising_edge (N) then
	if cuenta ="0101" then
		cuenta :="0000";
		E <= '1';
	else
		cuenta := cuenta +1;
		E <='0';
	end if; end if;
	D <= cuenta;
end process;

--decenas trabaj igual que antes, toma el flanco de la señal
-- que sale de unidades (N), pero siempre esta
--sincronizado, ya que utiliza "segundo", en el proceso.

HU:process(segundo)
variable cuenta: std_logic_vector(3 downto 0):="0000";
begin
	if rising_edge (E) then
	if cuenta ="1001"then
		cuenta:="0000";
		Z <= '1';
		reset <='0';
	elsif H1 = "0001" AND H2 ="0001" then
		cuenta := "0000";
		reset <='1';
		Z <= '1';
	else 
		cuenta := cuenta+1;
		Z<='0';
		reset <='0';
		end if; end if;
	H1 <= cuenta;
end process;

--Unidades de Hora (HU), trabaja exactamente igual,
--se utiliza las variables H1 y H2, que representan los digitos
--decimales y unidades de las horas
--ya que se llega a 59 segundos, entra a la condicion para saber
--si el reloj queda en 11, de ser asi, cambia todo a 0.

HD: process (segundo)
	variable cuenta: std_logic_vector(3 downto 0):="0000";
begin
	if rising_edge(Z) then
	if reset= '1' then
		cuenta:= "0000";
	else
		cuenta:= cuenta+1;
	end if; end if;
	H2 <= cuenta;
end process;

--HD (decenas de hora), solamente se toma en cuenta el reset,
--cuando es 1, regresa a 0.


    with U select
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
						  "1000000" when others; --F

    with D select
        display2 <= "1000000" when "0000", --0
						  "1111001" when "0001", --1
						  "0100100" when "0010", --2
						  "0110000" when "0011", --3
						  "0011001" when "0100", --4
						  "0010010" when "0101", --5
						  "1000000" when others; --F

    with H1 select
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
						  "1000000" when others; --F
    
    with H2 select
        display4 <= "1000000" when "0000", --0
						  "1111001" when "0001", --1
						  "0100100" when "0010", --2
						  "1000000" when others; --F

end Behavioral;
