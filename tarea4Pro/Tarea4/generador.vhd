library ieee; --g4
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity generador is
	port (seg: in std_logic; 
			row: in integer;
			column: in integer;
			display_ena_i: in std_logic;
			R,G,B: out std_logic_vector(3 downto 0) );
end entity generador;


architecture behavioral of generador is

	subtype state is std_logic_vector (3 downto 0);
	signal present_state,present_stateD,present_stateC: state;
	constant state0, state0D, state0C: state:= "0000";
	constant state1, state1D, state1C: state:= "0001";
	constant state2, state2D, state2C: state:= "0010";
	constant state3, state3D, state3C: state:= "0011";
	constant state4, state4D, state4C: state:= "0100";
	constant state5, state5D, state5C: state:= "0101";
	constant state6, state6D, state6C: state:= "0110";
	constant state7, state7D, state7C: state:= "0111";
	constant state8, state8D, state8C: state:= "1000";
	constant state9, state9D, state9C: state:= "1001";
	constant posicionx: integer := 320;
	constant posicionx1: integer := 250;
	constant posicionx2: integer := 160;
	
	signal uno, dos, tres: std_logic_vector(3 downto 0):="0000";
	signal n, e: std_logic;


begin
	
	generador_imagen: process(display_ena_i, row, column)
	begin
		if((row>190 and row <300) and (column>posicionx-10 and column<posicionx+60)) then
	case present_state is
		when state0=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx and column<posicionx+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state1=>
		if ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when state2=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx and column<posicionx+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state3=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state4=>
		if ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state5=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state6=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx and column<posicionx+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state7=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state8=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx+10 and column<posicionx+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx and column<posicionx+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state9=>
		if ((row > 200 and row <210) and
		(column>posicionx+10 and column<posicionx+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx+40 and column<posicionx+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx+40 and column<posicionx+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx and column<posicionx+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx+10 and column<posicionx+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when others =>
		end case;
		end if;

		if((row>190 and row <300) and (column>posicionx1-10 and column<posicionx1+60)) then
	case present_stateD is
		when state0D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1 and column<posicionx1+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state1D=>
		if ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when state2D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1 and column<posicionx1+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state3D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state4D=>
		if ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state5D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state6D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1 and column<posicionx1+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state7D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state8D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx1 and column<posicionx1+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state9D=>
		if ((row > 200 and row <210) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx1+40 and column<posicionx1+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx1 and column<posicionx1+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx1+10 and column<posicionx1+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when others =>
		end case;
		end if;

		if((row>190 and row <300) and (column>posicionx2-10 and column<posicionx2+60)) then
	case present_stateC is
		when state0C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2 and column<posicionx2+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state1C=>
		if ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when state2=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2 and column<posicionx2+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state3C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state4C=>
		if ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state5C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state6C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2 and column<posicionx2+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state7C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state8C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 280 and row <290) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- D blanco
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 250 and row <280) and
		(column>posicionx2 and column<posicionx2+10)) then -- E cian
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		
		when state9C=>
		if ((row > 200 and row <210) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- A azul
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '1');
		elsif ((row > 210 and row <240) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- B verde
			R <= (others => '0');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 250 and row <280) and
		(column>posicionx2+40 and column<posicionx2+50)) then -- C rojo
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '0');
		elsif ((row > 210 and row <240) and
		(column>posicionx2 and column<posicionx2+10)) then -- F amarillo
			R <= (others => '1');
			G <= (others => '1');
			B <= (others => '0');
		elsif ((row > 240 and row <250) and
		(column>posicionx2+10 and column<posicionx2+40)) then -- G violeta
			R <= (others => '1');
			G <= (others => '0');
			B <= (others => '1');
		else -- fondo
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
		when others =>
		end case;
		end if;
	end process generador_imagen;
	
	process (uno)
	begin
	case uno is
		when "0001" => present_state <= state1;
		when "0010" => present_state <= state2;
		when "0011" => present_state <= state3;
		when "0100" => present_state <= state4;
		when "0101" => present_state <= state5;
		when "0110" => present_state <= state6;
		when "0111" => present_state <= state7;
		when "1000" => present_state <= state8;
		when "1001" => present_state <= state9;
		when others => present_state <= state0;
	end case;
	end process;
	
	process (dos)
	begin
	case dos is
		when "0001" => present_stateD <= state1D;
		when "0010" => present_stateD <= state2D;
		when "0011" => present_stateD <= state3D;
		when "0100" => present_stateD <= state4D;
		when "0101" => present_stateD <= state5D;
		when "0110" => present_stateD <= state6D;
		when "0111" => present_stateD <= state7D;
		when "1000" => present_stateD <= state8D;
		when "1001" => present_stateD <= state9D;
		when others => present_stateD <= state0D;
	end case;
	end process;
process (tres)

	begin
	case tres is
		when "0001" => present_stateC <= state1C;
		when "0010" => present_stateC <= state2C;
		when "0011" => present_stateC <= state3C;
		when "0100" => present_stateC <= state4C;
		when "0101" => present_stateC <= state5C;
		when "0110" => present_stateC <= state6C;
		when "0111" => present_stateC <= state7C;
		when "1000" => present_stateC <= state8C;
		when "1001" => present_stateC <= state9C;
		when others => present_stateC <= state0C;
	end case;
	end process;
	
	
	
	Cunidades: process (seg) -- va de 1 en 1 hasta 9
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (seg) then
		if cuenta ="1001" then
			cuenta:="0000";
			n <= '1';
		else
			cuenta:= cuenta +1;
			n <= '0';
		end if;end if;
			uno <= cuenta;
	end process;

	Cdecenas: process (n) -- va de 2 en 2 hasta 8
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (n) then
		if cuenta ="1000" then
			cuenta:="0000";
			e <= '1';
		else
			cuenta:= cuenta +2;
			e<= '0';
		end if; end if;
			dos <= cuenta;
	end process;

	Ccentenas: Process(e) -- va de 3 en 3 hasta 9
		variable cuenta: std_logic_vector(3 downto 0):="0000";
	begin
		if rising_edge(e) then
		if cuenta="1001" then
			cuenta:= "0000";
		else
			cuenta := cuenta+3;
		end if; end if;
			tres<=cuenta;
	end Process;
	
end behavioral;