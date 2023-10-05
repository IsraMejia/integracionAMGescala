/*
La practica va del PWM 
La frecuencia de trabajo nosotros la definimos
hay 8 bits que representan un ciclo de la señal de salida 

Se tiene que hacer en archivos separados para mandar a llamar los componentes
Se tienen que usar 10 leds
*/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity tren is
Port (
    reloj, alto, SA, SN, emergencia, estacion : in std_logic;
    alto1, alto2, este, oeste, reset_FF1: out std_logic
);
end tren;

architecture Behavioral of tren is
    signal segundo: std_logic;

    type estados is (s0, s1);
    signal epresente, esiguiente: estados;

    begin
        process (reloj)
            begin
            if rising_edge(segundo) then 
            epresente <= esiguiente;
            end if;
        end process;
        process (epresente, estacion, alto, emergencia, SA,SN)
        begin
            case epresente is
            when s0 => 
            if estacion = '1' then 
                alto2 <= '1';
                esiguiente <=s1;
                else
                esiguiente <=s0;
                end if;
                when s1 => 
                if alto = '1' then 
                esiguiente <=s1;
                elsif emergencia = '1' then
                reset_FF1 <= '1';
                alto1 <= '1';
                esiguiente <=s1;
                elsif SA = '1' then
                oeste <= '1';
                esiguiente <=s0;
                elsif SN = '1' then
                este <= '1';
                esiguiente <=s0;
                elsif esiguiente <=s0;
            end if; 
        end process;
        end Behavioral;