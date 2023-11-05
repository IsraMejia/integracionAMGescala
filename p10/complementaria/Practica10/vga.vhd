library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
	generic( --Constantes para monitor VGA en 640x480
				constant h_pulse : integer := 96;
				constant h_bp : integer := 48;
				constant h_pixels : integer := 640;
				constant h_fp : integer := 16;
				constant v_pulse : integer := 2;
				constant v_bp : integer := 33;
				constant v_pixels : integer := 480;
				constant v_fp : integer := 10
	);
	port ( clk50MHz: in std_logic;
			sw1, sw2, sw3, sw4: in std_logic;
			red: out std_logic_vector (3 downto 0);
			green: out std_logic_vector (3 downto 0);
			blue: out std_logic_vector (3 downto 0);
			h_sync: out std_logic;
			v_sync: out std_logic );
end entity vga;

architecture behaivoral OF vga IS

--Contadores
	constant h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
	constant v_period : integer := v_pulse + v_bp + v_pixels + v_fp;
	signal h_count : integer range 0 to h_period - 1 := 0;
	signal v_count : integer range 0 to v_period - 1 := 0;
	signal reloj_pixel: std_logic;
	signal column, row: integer;
	signal display_ena: std_logic;
	signal y: integer range 0 to 480:= 400;
	signal x: integer range 0 to 640:= 0;

--Asignacion de Pines
	attribute chip_pin : string;
	attribute chip_pin of clk50MHz	    : signal is "P11";	
	attribute chip_pin of red		 		 : signal is "Y1,Y2,v1,AA1";	
 	attribute chip_pin of green		 	 : signal is "R1,R2,T2,W1";
	attribute chip_pin of blue		 		 : signal is "N2,P4,T1,P1";
	attribute chip_pin of h_sync		 	 : signal is "N3";
	attribute chip_pin of v_sync		 	 : signal is "N1";
	attribute chip_pin of sw1		 		 : signal is "C10";
	attribute chip_pin of sw2		 		 : signal is "C11";
	attribute chip_pin of sw3		 		 : signal is "D12";
	attribute chip_pin of sw4		 		 : signal is "C12";
	
begin

	relojpixel: process (clk50MHz) is
	begin
		if rising_edge(clk50MHz) then
			reloj_pixel <= not reloj_pixel;
		end if;
		end process relojpixel; -- 25mhz

	contadores : process (reloj_pixel) -- H_periodo=800, V_periodo=525
	begin
		if rising_edge(reloj_pixel) then
			if h_count<(h_period-1) then
				h_count<=h_count+1;
			else
				h_count<=0;
				if v_count<(v_period-1) then
					v_count<=v_count+1;
				else
					v_count<=0;
				end if;
			end if;
		end if;
	end process contadores;

	senial_hsync : process (reloj_pixel) --h_pixel+h_fp+h_pulse= 784
	begin
		if rising_edge(reloj_pixel) then
			if h_count>(h_pixels + h_fp) or
				h_count>(h_pixels + h_fp + h_pulse) then
				h_sync<='0';
			else
				h_sync<='1';
			end if;
		end if;
	end process senial_hsync;

	senial_vsync : process (reloj_pixel) --vpixels+v_fp+v_pulse=525
	begin --checar si se en parte visible es 1 o 0
		if rising_edge(reloj_pixel) then
			if v_count>(v_pixels + v_fp) or
				v_count>(v_pixels + v_fp + v_pulse) then
				v_sync<='0';
			else
				v_sync<='1';
			end if;
		end if;
	end process senial_vsync;

	coords_pixel: process(reloj_pixel)
	begin --asignar una coordenada en parte visible
		if rising_edge(reloj_pixel) then
			if (h_count < h_pixels) then
				column <= h_count;
			end if;
			if (v_count < v_pixels) then
				row <= v_count;
			end if;
		end if;
	end process coords_pixel;

	generador_imagen: process(display_ena, row, column)
	begin
		if(display_ena = '1') then
			if ((row > (y+44) and row <(y+51)) and (column>(x+22) and column<(x+31))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '0'); --parte del sol
			elsif ((row > (y+43) and row <(y+45)) and (column>(x+23) and column<(x+30))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '0'); -- resto del sol
			elsif ((row > (y+39) and row <(y+47)) and (column>(x+2) and column<(x+12))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1');-- Parte nube 1
			elsif ((row > (y+40) and row <(y+46)) and (column>(x+1) and column<(x+13))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1'); --completo nube 1
			elsif ((row > (y+35) and row <(y+41)) and (column>(x+18) and column<(x+26))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1');-- Parte nube 2
			elsif ((row > (y+36) and row <(y+40)) and (column>(x+17) and column<(x+27))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1'); --completo nube 2
			elsif ((row > (y+38) and row <(y+36)) and (column>(x+37) and column<(x+47))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1'); --Parte Nube 3
			elsif ((row > (y+39) and row <(y+35)) and (column>(x+36) and column<(x+48))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '1');-- completo nube 3
			elsif ((row > (y) and row <(y+15)) and (column>(x) and column<(x+23))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--Parte del pasto
			elsif ((row > (y) and row <(y+15)) and (column>(x+29) and column<(x+51))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--Parte del pasto
			elsif ((row > (y) and row <(y+6)) and (column>(x+22) and column<(x+30))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--Parte del pasto
			elsif ((row > (y+11) and row <(y+14)) and (column>(x+28) and column<(x+30))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+5) and row <(y+9)) and (column>(x+24) and column<(x+31))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--Parte del pasto
			elsif ((row > (y+11) and row <(y+15)) and (column>(x+22) and column<(x+26))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+12) and row <(y+14)) and (column>(x+25) and column<(x+27))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+9) and row <(y+12)) and (column>(x+22) and column<(x+25))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+8) and row <(y+10)) and (column>(x+22) and column<(x+24))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+6) and row <(y+8)) and (column>(x+23) and column<(x+25))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--parte del pasto
			elsif ((row > (y+8) and row <(y+10)) and (column>(x+28) and column<(x+30))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--Parte final del pasto
			elsif ((row > (y+18) and row <(y+21)) and (column>(x+18) and column<(x+21))) then
				red <= (others => '1');
				green<=(others => '1');
				blue<=(others => '0');--centro flor
			elsif ((row > (y+17) and row <(y+19)) and (column>(x+18) and column<(x+21))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '0');--petalo flor
			elsif ((row > (y+20) and row <(y+22)) and (column>(x+18) and column<(x+21))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '0');--petalo flor
			elsif ((row > (y+18) and row <(y+21)) and (column>(x+17) and column<(x+19))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '0');--petalo flor
			elsif ((row > (y+18) and row <(y+21)) and (column>(x+20) and column<(x+22))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '0');--petalo flor, final
			elsif ((row > (y+17) and row <(y+20)) and (column>(x+4) and column<(x+10))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '1');--capullo flor
			elsif ((row > (y+19) and row <(y+21)) and (column>(x+5) and column<(x+9))) then
				red <= (others => '1');
				green<=(others => '0');
				blue<=(others => '1');--capullo flor, final
			elsif ((row > (y+15) and row <(y+18)) and (column>(x+6) and column<(x+8))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--rama flor 1
			elsif ((row > (y+15) and row <(y+18)) and (column>(x+18) and column<(x+20))) then
				red <= (others => '0');
				green<=(others => '1');
				blue<=(others => '0');--rama flor 2
			elsif ((row > (y+14) and row <(y+40)) and (column>(x) and column<(x+5))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+14) and row <(y+39)) and (column>(x+29) and column<(x+51))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--Parte cielo
			elsif ((row > (y+21) and row <(y+36)) and (column>(x+4) and column<(x+30))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--Parte del cielo
			elsif ((row > (y+35) and row <(y+40)) and (column>(x+4) and column<(x+18))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');-- Parte del cielo
			elsif ((row > (y+35) and row <(y+44)) and (column>(x+26) and column<(x+38))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+44) and row <(y+51)) and (column>(x+30) and column<(x+40))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--Parte del cielo
			elsif ((row > (y+45) and row <(y+51)) and (column>(x+11) and column<(x+23))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--Parte del cielo
			elsif ((row > (y+38) and row <(y+51)) and (column>(x+46) and column<(x+51))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+45) and row <(y+51)) and (column>(x+39) and column<(x+47))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+40) and row <(y+44)) and (column>(x+12) and column<(x+27))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+46) and row <(y+51)) and (column>(x) and column<(x+12))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+43) and row <(y+46)) and (column>(x+12) and column<(x+23))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+14) and row <(y+18)) and (column>(x+7) and column<(x+19))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+14) and row <(y+18)) and (column>(x+19) and column<(x+26))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+17) and row <(y+22)) and (column>(x+21) and column<(x+30))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+17) and row <(y+22)) and (column>(x+9) and column<(x+18))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--Parte del cielo
			elsif ((row > (y+14) and row <(y+18)) and (column>(x+4) and column<(x+7))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+20) and row <(y+22)) and (column>(x+4) and column<(x+10))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+43) and row <(y+45)) and (column>(x+29) and column<(x+38))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+39) and row <(y+41)) and (column>(x+11) and column<(x+19))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte dl cielo
			elsif ((row > (y+39) and row <(y+51)) and (column>(x) and column<(x+2))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+16) and row <(y+18)) and (column>(x+26) and column<(x+29))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+43) and row <(y+44)) and (column>(x+22) and column<(x+24))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+45) and row <(y+47)) and (column>(x+1) and column<(x+3))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+39) and row <(y+41)) and (column>(x+1) and column<(x+3))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+35) and row <(y+37)) and (column>(x+17) and column<(x+19))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+35) and row <(y+37)) and (column>(x+25) and column<(x+27))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+39) and row <(y+41)) and (column>(x+25) and column<(x+27))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+38) and row <(y+40)) and (column>(x+37) and column<(x+40))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+38) and row <(y+40)) and (column>(x+44) and column<(x+47))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+44) and row <(y+46)) and (column>(x+44) and column<(x+47))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+19) and row <(y+21)) and (column>(x+4) and column<(x+6))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+19) and row <(y+21)) and (column>(x+8) and column<(x+10))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+20) and row <(y+22)) and (column>(x+17) and column<(x+19))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+20) and row <(y+22)) and (column>(x+20) and column<(x+22))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+17) and row <(y+19)) and (column>(x+17) and column<(x+19))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo
			elsif ((row > (y+17) and row <(y+19)) and (column>(x+20) and column<(x+22))) then
				red <= (others => '0');
				green<=(others => '0');
				blue<=(others => '1');--parte del cielo, final
			else
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '0');
			end if;
		else
			red<= (others => '0');
			green <= (others => '0');
			blue<= (others => '0');
		end if;
	end process generador_imagen;

	display_enable: process(reloj_pixel) --- h_pixels=640; y_pixeles=480
	begin
		if rising_edge(reloj_pixel) then
			if (h_count < h_pixels AND v_count < v_pixels) THEN
				display_ena <= '1';
			else
				display_ena <= '0';
			end if;
		end if;
	end process display_enable;
	
	CambiarDePosicion: process(clk50MHz)
	begin
		if rising_edge(clk50MHz) then
			if sw4='1' then
				x <= 50;
				y <= 50;
			elsif sw3='1' then
				x <= 589;
				y <= 50;
			elsif sw2='1' then
				x <= 589;
				y <= 429;
			elsif sw1='1' then
				x <= 0;
				y <= 429;
			else
				x <= 319;
				y <= 239;
			end if;
		end if;
	end process;
			

end behaivoral;