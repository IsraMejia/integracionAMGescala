library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity relojLento is
	port ( clk50MHz: in std_logic;
			segundo: out std_logic );
end entity relojLento;


architecture behavioral of relojLento is

begin
	
	divisor: process (clk50MHz)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	 begin
			if rising_edge (clk50MHz) then
			if cuenta=X"48009E0" then
				cuenta:= X"0000000";
			else
				cuenta:=cuenta+1;
			end if;
			end if;
				segundo <=cuenta(22);
	 end process;
	
end behavioral;