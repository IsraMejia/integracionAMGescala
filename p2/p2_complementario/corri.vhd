library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity corri is
	 Port (
		reloj: in std_logic;
		selec: in std_logic;
		display1, display2, display3, display4, display5, display6: buffer std_logic_vector (6 downto 0)
		--buffer
	);
end corri;


architecture Behavioral of corri is
 signal segundo: std_logic;
 signal Q: std_logic_vector(5 downto 0):="000000";
 
 begin

	divisor: process (reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
		begin
			if rising_edge (reloj) then
				if cuenta=X"48009E0" then 
				cuenta:= X"0000000"; --Reiniciar la cuenta del divisor
				else
				cuenta:=cuenta+1;
				end if;
			end if;
			segundo <=cuenta(22); 
			--Se actualiza la señal segundo usando el bit 22 de la cuenta
 	end process;
 
	
	contador:process (segundo)
		--Proceso encargado de mostrar la bienvenida o los productos
		begin
			if rising_edge (segundo) then
				if selec/='1' then --Si no es 1 el switch
					Q <= Q +1;
					if Q="001010" then 
						--Si se llega al final de mensaje de bienvenidos, reinicia el mensaje						
						Q<= "000000";
					end if;
					if Q="101000" then
						--Si llega al final de la cuenta (dos mensajes), reinicia la cuenta
						Q<= "000000";
					end if;
					
			elsif selec='1' then --Cuando El switch esta activado
				Q <= Q +1;
				if Q="101000" then 
						--Si llega al final de la cuenta (dos mensajes), reinicia la cuenta
					Q<= "000000"; 
				end if;
			 end if;
			end if;
	end process;
 
	--Mediante Flipflops mandamos el valor de un display al siguiente cada segundo
 	FF1 : process (segundo)
		begin
			if rising_edge (segundo) then
				display2 <= display1;
			end if;
	end process;
 
	
	FF2 : process (segundo)
		begin
			if rising_edge (segundo) then
			display3 <= display2;
			end if;
	end process;
 
	
	FF3 : process (segundo)
		begin
			if rising_edge (segundo) then
			display4 <= display3;
			end if;
	end process;
 
 
	FF4 : process (segundo)
		begin
			if rising_edge (segundo) then
			display5 <= display4;
			end if;
	end process;
 
 
	FF5 : process (segundo)
		begin
			if rising_edge (segundo) then
			display6 <= display5;
			end if;
	end process;
 
 
	with Q select display1 <=   "0000011" when "000000", -- b 
								"1111001" when "000001", -- I
								"0000110" when "000010", -- E
								"0101011" when "000011", -- n
								"0000011" when "000100", -- b
								"0000110" when "000101", -- E
								"0101011" when "000110", -- n
								"1111001" when "000111", -- I 
								"0100001" when "001000", -- D 
								"1000000" when "001001", -- O

								"1111111" when "001010", --espacio en blanco	

								"0010010" when "001011", --S 
								"1000000" when "001100", --o
								"0001100" when "001101", --P
								"0001000" when "001110", --A
								"1111111" when "001111", --espacio en blanco
								"0100100" when "010000", --2
								"0011001" when "010001", --4

								"1111111" when "010010", --espacio en blanco				
												
								"1000110" when "010011", --C 
								"0001000" when "010100", --A 
								"0001110" when "010101", --F 
								"0000110" when "010110", --E 
								"1111111" when "011000", --espacio en blanco 
								"0000110" when "011001", -- E
								"0001001" when "011010", -- x 
								"1111111" when "011011", --espacio en blanco	 								
								"1111001" when "011100", -- 1
								"0110000" when "011101", -- 3

								"1111111" when "011110", --espacio en blanco
								"0001100" when "011111", --P
								"1111001" when "100000", --I
								"0100100" when "100001", --Z
								"0100100" when "100010", --Z
								"0001000" when "100011", --A
								"1111111" when "100100", --espacio en blanco
								"0000000" when "100101", --8 
								"0010010" when "100110", --5
								"1111111" when "100111", --espacio en blanco 								
								"1111111" when "101000", --espacio en blanco Para ser mas claro cuando termina
											
													
								"1111111" when others;
end behavioral;
