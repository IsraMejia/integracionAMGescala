 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity leds is
	Port ( 
		reloj : in STD_LOGIC;
		R : out STD_LOGIC;
		G : out STD_LOGIC;
		B : out STD_LOGIC
	);
end Leds;
 

architecture Behavioral of Leds is
	
	component divisor is
		--N al ser generic puede usarse por multiples componentes
		--N configura la division de la frecuencia de reloj
		Generic ( N : integer := 24); 
		Port ( 
			reloj : in std_logic;
			div_reloj : out std_logic
		);
	end component;

	component PWM is
		Port ( 
			reloj_pwm : in STD_LOGIC;
			D : in STD_LOGIC_VECTOR (7 downto 0);
			S : out STD_LOGIC
		);
	end component;
	
	--Seeñales para generar y sincronizar las señales PWM
	signal relojPWM : STD_LOGIC;
	signal relojCiclo : STD_LOGIC;

	--Señales de 8bits para los valores PWM para los canales RGB
	signal cR : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	signal cG : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	signal cB : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	
	--Estados de nuestra maquina de estados para los ciclos ded colores 
	type estados is (rojo, naranja, amarillo, verde, azul, indigo, violeta);
 

	--Señales de tipo estados para conocer el estado actual y el siguiente de los cilos de colores
	signal pre_state, next_state: estados := rojo;

	begin
		--Divisor para el reloj PWM. N=10 -> Periodo 41 us
		dPWM:    divisor 	generic map (10) port map (reloj, relojPWM);
		--Divisor para el ciclo de colores . N=23 -> Periodo 336 ms
		dColors: divisor 	generic map (23) port map (reloj, relojCiclo);

		--Moduladores de ancho de pulso (PWM)
		--Regularan la intensidad de iluminacion para cada color del led RGB
		pwmR: PWM 	port map (relojPWM, cR, R);
		pwmG: PWM 	port map (relojPWM, cG, G);
		pwmB: PWM 	port map (relojPWM, cB, B);

		process (relojCiclo)  
		begin
			
			if rising_edge (relojCiclo) then				
				
				case pre_state is --Comparamos estados de pre_state
					
					when rojo => --Anodo comun Morado->Rojo
						cR <= "11111111"; -- Rojo
						cG <= "00000000";
						cB <= "11111111";
						next_state <= naranja; --Se pasa al siguiente estado/color

					when naranja =>
						cR <= "01001011"; -- Naranja 
						cG <= "00000000";
						cB <= "10000010";
						next_state <= amarillo;
				
					when amarillo =>
						cR <= "00000000"; -- Amarillo
						cG <= "00000000";
						cB <= "11111111";
						next_state <= verde;
			
					when verde =>
						cR <= "00000001"; -- Verde
						cG <= "00000000";
						cB <= "00000001";
						next_state <= azul;
				
					when azul =>
						cR <= "11111111"; -- Azul claro
						cG <= "11111111";
						cB <= "00000000";
						next_state <= indigo;
					
					when indigo =>
						cR <= "11111111"; -- Azul (Indigo)
						cG <= "10100101";
						cB <= "11111111";
						next_state <= violeta;
				
					when violeta =>
						cR <= "11111111"; -- Violeta
						cG <= "00000000";
						cB <= "00000000";
						next_state <= rojo;

				end case;

				pre_state <= next_state; --Reiniciamos el ciclo de colores
			end if;
		end process;
		
end Behavioral;