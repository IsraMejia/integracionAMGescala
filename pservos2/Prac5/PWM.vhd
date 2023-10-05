Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_arith.all;
Use IEEE.std_logic_unsigned.all;

Entity PWM is
	Port( reloj_pwm: in std_logic;
			D: in std_logic_vector(7 downto 0);
			S: out std_logic);
end PWM;

architecture behavior of PWM is

	begin
		process(reloj_pwm)
			variable cuenta: integer range 0 to 254:= 0;
		begin
			if reloj_pwm'event and reloj_pwm='1' then
				cuenta:= cuenta + 1 mod 255;
				if cuenta < D then
					S <= '1';
				else 
					S <= '0';
				end if;
			end if;
		end process;
end behavior;