library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity divisor is
    --N al ser generic puede usarse por multiples componentes
	--N configura la division de la frecuencia de reloj
    Generic ( N : integer := 24);
    --  N=10 -> Periodo 41 us
    --  N=23 -> Periodo 336 ms
    Port ( 
        reloj : in std_logic; --50Mhz
        div_reloj : out std_logic
    );
end Divisor;

architecture Behavioral of Divisor is begin
    process (reloj)
        variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
        begin
        if rising_edge (reloj) then
            cuenta := cuenta + 1;
        end if;
        div_reloj <= cuenta (N);
    end process;
end Behavioral; 