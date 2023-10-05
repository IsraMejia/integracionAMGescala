library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity leds is
Port ( reloj : in STD_LOGIC;
		 R : out STD_LOGIC;
		 G : out STD_LOGIC;
		 B : out STD_LOGIC);
end Leds;

architecture Behavioral of Leds is
	component divisor is
	Generic ( N : integer := 24);
	Port ( reloj : in std_logic;
	div_reloj : out std_logic);
end component;

component PWM is
	Port ( reloj_pwm : in STD_LOGIC;
			 D : in STD_LOGIC_VECTOR (7 downto 0);
			 S : out STD_LOGIC);
end component;
	signal relojPWM : STD_LOGIC;
	signal relojCiclo : STD_LOGIC;
	signal a1 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal a2 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	signal a3 : STD_LOGIC_VECTOR (7 downto 0) := X"00";
	type estados is (e1, e2, e3, e4, e5, e6, e7);
	signal epre, esig: estados := e1;
begin
	N1: divisor generic map (10) port map (reloj, relojPWM);
	N2: divisor generic map (23) port map (reloj, relojCiclo);
	P1: PWM port map (relojPWM, a1, R);
	P2: PWM port map (relojPWM, a2, G);
	P3: PWM port map (relojPWM, a3, B);

process (relojCiclo)
begin
	if relojCiclo='1' and relojCiclo'event then
	case epre is
		when e1 =>
			  a1 <= X"FF"; -- Rojo
			  a2 <= X"00";
           a3 <= X"00";
			  esig <= e2;
		when e2 =>
           a1 <= X"FF"; -- Naranja
           a2 <= X"A5";
           a3 <= X"00";
			  esig <= e3;
      when e3 =>
			  a1 <= X"FF"; -- Amarillo
           a2 <= X"FF";
           a3 <= X"00";
			  esig <= e4;
      when e4 =>
           a1 <= X"00"; -- Verde
           a2 <= X"80";
           a3 <= X"00";
			  esig <= e5;
      when e5 =>
           a1 <= X"00"; -- Cian
           a2 <= X"FF";
           a3 <= X"FF";
			  esig <= e6;
      when e6 =>
           a1 <= X"00"; -- Azul
           a2 <= X"00";
           a3 <= X"FF";
			  esig <= e7;
      when e7 =>
           a1 <= X"80"; -- Violeta
           a2 <= X"00";
           a3 <= X"80";
			  esig <= e1;
	end case;

		epre <= esig;
	end if;
end process;
end Behavioral;