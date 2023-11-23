library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reloj is
	port ( clk50MHz: in std_logic;
			reloj_pixel: buffer std_logic );
end entity reloj;


architecture behavioral of reloj is

begin
	
	relojpixel: process (clk50MHz) is
	 begin
		if rising_edge(clk50MHz) then
			reloj_pixel <= not reloj_pixel;
		end if;
	 end process relojpixel; -- 25mhz
	
end behavioral;