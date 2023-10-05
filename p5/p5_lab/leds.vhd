library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity leds is
-- Port ( reloj_in : in STD_LOGIC;
Port ( reloj : in STD_LOGIC;
 led1 : out STD_LOGIC;
 led2 : out STD_LOGIC;
 led3 : out STD_LOGIC;
 led4 : out STD_LOGIC;
 led5 : out STD_LOGIC;
 led6 : out STD_LOGIC;
 led7 : out STD_LOGIC;
 led8 : out STD_LOGIC;
 led9 : out STD_LOGIC;
 led10 : out STD_LOGIC
 
 );
end Leds;
architecture Behavioral of Leds is
component divisor is
Generic ( N : integer := 24);
Port ( 
    reloj : in std_logic;
    div_reloj : out std_logic
);
end component;
component PWM is
 Port ( reloj_pwm : in STD_LOGIC;
 D : in STD_LOGIC_VECTOR (7 downto 0);
 S : out STD_LOGIC);
 end component;
signal relojPWM : STD_LOGIC;
signal relojCiclo : STD_LOGIC;
signal a1 : STD_LOGIC_VECTOR (7 downto 0) := X"16";
signal a2 : STD_LOGIC_VECTOR (7 downto 0) := X"29";
signal a3 : STD_LOGIC_VECTOR (7 downto 0) := X"36";
signal a4 : STD_LOGIC_VECTOR (7 downto 0) := X"46";
signal a5 : STD_LOGIC_VECTOR (7 downto 0) := X"56";
signal a6 : STD_LOGIC_VECTOR (7 downto 0) := X"66";
signal a7 : STD_LOGIC_VECTOR (7 downto 0) := X"76";
signal a8 : STD_LOGIC_VECTOR (7 downto 0) := X"86";
signal a9 : STD_LOGIC_VECTOR (7 downto 0) := X"96";
signal a10 : STD_LOGIC_VECTOR (7 downto 0) := X"FF"; 
begin
N1: divisor generic map (10) port map (reloj, relojPWM);
N2: divisor generic map (23) port map (reloj, relojCiclo);

P1: PWM port map  (relojPWM, a1, led1);
P2: PWM port map  (relojPWM, a2, led2);
P3: PWM port map  (relojPWM, a3, led3);
P4: PWM port map  (relojPWM, a4, led4);
P5: PWM port map  (relojPWM, a5, led5);
P6: PWM port map  (relojPWM, a6, led6);
P7: PWM port map  (relojPWM, a7, led7);
P8: PWM port map  (relojPWM, a8, led8);
P9: PWM port map  (relojPWM, a9, led9);
P10: PWM port map (relojPWM, a10, led10); 

process (relojCiclo) 
variable Cuenta : integer range 0 to 255 := 0;
begin
if relojCiclo='1' and relojCiclo'event then

a1 <= a10;
a2 <= a1;  
a3 <= a2;
a4 <= a3;
a5 <= a4;
a6 <= a5; 
a7 <= a6;
a8 <= a7;
a9 <= a8;
a10 <= a9;  

end if;
end process;
end Behavioral;