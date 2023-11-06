LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vga IS
	GENERIC (--Constantes para monitor VGA en 640x400
		CONSTANT h_pulse : INTEGER := 96;
		CONSTANT h_bp : INTEGER := 48; 
		CONSTANT h_pixels : INTEGER := 640;
		CONSTANT h_fp : INTEGER := 16;
		CONSTANT v_pulse : INTEGER := 2;
		CONSTANT v_bp : INTEGER := 33;
		CONSTANT v_pixels : INTEGER := 400;
		CONSTANT v_fp : INTEGER := 10
	);
	PORT (
		clk50MHz : IN STD_LOGIC;
		sw1, sw2, sw3, sw4 : IN STD_LOGIC;
		red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		h_sync : OUT STD_LOGIC;
		v_sync : OUT STD_LOGIC);
END ENTITY vga;
 
ARCHITECTURE behaivoral OF vga IS
 
	--Contadores
	CONSTANT h_period : INTEGER := h_pulse + h_bp + h_pixels + h_fp;
	CONSTANT v_period : INTEGER := v_pulse + v_bp + v_pixels + v_fp; 
	SIGNAL h_count : INTEGER RANGE 0 TO h_period - 1 := 0;
	SIGNAL v_count : INTEGER RANGE 0 TO v_period - 1 := 0;
	SIGNAL reloj_pixel : STD_LOGIC;
	SIGNAL column, row : INTEGER;
	SIGNAL display_ena : STD_LOGIC;
	SIGNAL y : INTEGER RANGE 0 TO 400 := 400;
	SIGNAL x : INTEGER RANGE 0 TO 600 := 0;

	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF clk50MHz 	: SIGNAL IS "P11";
	ATTRIBUTE chip_pin OF red 		: SIGNAL IS "Y1,Y2,v1,AA1";
	ATTRIBUTE chip_pin OF green 	: SIGNAL IS "R1,R2,T2,W1";
	ATTRIBUTE chip_pin OF blue 		: SIGNAL IS "N2,P4,T1,P1";
	ATTRIBUTE chip_pin OF h_sync 	: SIGNAL IS "N3";
	ATTRIBUTE chip_pin OF v_sync	: SIGNAL IS "N1";
	ATTRIBUTE chip_pin OF sw1 		: SIGNAL IS "C10";
	ATTRIBUTE chip_pin OF sw2 		: SIGNAL IS "C11";
	ATTRIBUTE chip_pin OF sw3 		: SIGNAL IS "D12";
	ATTRIBUTE chip_pin OF sw4 		: SIGNAL IS "C12";

BEGIN

	relojpixel : PROCESS (clk50MHz) IS
	BEGIN
		IF rising_edge(clk50MHz) THEN
			reloj_pixel <= NOT reloj_pixel;
		END IF;
	END PROCESS relojpixel; -- 25mhz

	contadores : PROCESS (reloj_pixel) -- H_periodo=800, V_periodo=525
	BEGIN
		IF rising_edge(reloj_pixel) THEN
			IF h_count < (h_period - 1) THEN
				h_count <= h_count + 1;
			ELSE
				h_count <= 0;
				IF v_count < (v_period - 1) THEN
					v_count <= v_count + 1;
				ELSE
					v_count <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS contadores;

	senial_hsync : PROCESS (reloj_pixel) --h_pixel+h_fp+h_pulse= 784
	BEGIN
		IF rising_edge(reloj_pixel) THEN
			IF h_count > (h_pixels + h_fp) OR
				h_count > (h_pixels + h_fp + h_pulse) THEN
				h_sync <= '0';
			ELSE
				h_sync <= '1';
			END IF;
		END IF;
	END PROCESS senial_hsync;

	senial_vsync : PROCESS (reloj_pixel) --vpixels+v_fp+v_pulse=525
	BEGIN --checar si se en parte visible es 1 o 0
		IF rising_edge(reloj_pixel) THEN
			IF v_count > (v_pixels + v_fp) OR
				v_count > (v_pixels + v_fp + v_pulse) THEN
				v_sync <= '0';
			ELSE
				v_sync <= '1';
			END IF;
		END IF;
	END PROCESS senial_vsync;

	coords_pixel : PROCESS (reloj_pixel)
	BEGIN --asignar una coordenada en parte visible
		IF rising_edge(reloj_pixel) THEN
			IF (h_count < h_pixels) THEN
				column <= h_count;
			END IF;
			IF (v_count < v_pixels) THEN
				row <= v_count;
			END IF;
		END IF;
	END PROCESS coords_pixel;

	generador_imagen : PROCESS (display_ena, row, column)
	BEGIN
		IF (display_ena = '1') THEN
			
			IF ((column > (x + 1) AND column < (x + 10)) AND (row > (y + 1) AND row < (y + 10)) ) THEN
				red <= (OTHERS => '1'); -- Marco  esquina superior izquierda
				green <= (OTHERS => '1'); 
				blue <= (OTHERS => '1'); 
			ELSIF ((column >= (x + 120) AND column <= (x + 126)) AND (row > (y + 3) AND row <= (y + 9)) )THEN
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '1'); -- Marco  esquina superior Derecha
				blue <= (OTHERS => '0');  
			ELSIF ((column >= (x + 120) AND column <= (x + 126)) AND (row > (y + 117) AND row <= (y + 123)) )THEN
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1');  -- Marco  esquina inferior derecha
			ELSIF  ((column >= (x + 3) AND column <= (x + 9)) AND (row > (y + 117) AND row <= (y + 123)) ) THEN
				red <= (OTHERS => '1'); 
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '1');  -- Marco  esquina superiinferior izquierda


				--Inicio dibujo Jordan
			ELSIF ((column > (x + 81) AND column <= (x + 87)) AND (row > (y + 15) AND row <= (y + 18)) ) THEN
				red <= (OTHERS => '1'); --inicio balon
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 78) AND column <= (x + 90)) AND (row > (y + 18) AND row <= (y + 27)) ) THEN
				red <= (OTHERS => '1'); -- fin balon
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0');
			
			ELSIF ((column > (x + 81) AND column <= (x + 84)) AND (row > (y + 27) AND row <= (y + 36)) ) THEN
				red <= (OTHERS => '1'); --Antebrazo Jordan  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0');  	
			ELSIF ((column > (x + 57) AND column <= (x + 63)) AND (row > (y + 33) AND row <= (y + 36)) ) THEN
				red <= (OTHERS => '1'); --inicio cabeza  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 

			ELSIF ((column > (x + 57) AND column <= (x + 66)) AND (row > (y + 36) AND row <= (y + 48)) ) THEN
				red <= (OTHERS => '1'); --cabeza  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 	
			ELSIF ((column > (x + 54) AND column <= (x + 69)) AND (row > (y + 39) AND row <= (y + 45)) ) THEN
				red <= (OTHERS => '1'); --orejas  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 75) AND column <= (x + 84)) AND (row > (y + 36) AND row <= (y + 42)) ) THEN
				red <= (OTHERS => '1'); --bicep  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 75) AND column <= (x + 81)) AND (row > (y + 42) AND row <= (y + 48)) ) THEN
				red <= (OTHERS => '1'); --tricep  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 

			ELSIF ((column > (x + 60) AND column <= (x + 78)) AND (row > (y + 48) AND row <= (y + 57)) ) THEN
				red <= (OTHERS => '1'); --Pecho1  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0');
			ELSIF ((column > (x + 54) AND column <= (x + 75)) AND (row > (y + 51) AND row <= (y + 63)) ) THEN
				red <= (OTHERS => '1'); --  Pecho2
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 			
			ELSIF ((column > (x + 57) AND column <= (x + 75)) AND (row > (y + 63) AND row <= (y + 69)) ) THEN
				red <= (OTHERS => '1'); --Abdomen1  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			
			ELSIF ((column > (x + 51) AND column <= (x + 54)) AND (row > (y + 51) AND row <= (y + 63)) ) THEN
				red <= (OTHERS => '1'); --brazo1   
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 48) AND column <= (x + 54)) AND (row > (y + 57) AND row <= (y + 63)) ) THEN
				red <= (OTHERS => '1'); --brazo2  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 45) AND column <= (x + 51)) AND (row > (y + 60) AND row <= (y + 66)) ) THEN
				red <= (OTHERS => '1'); --brazo3  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 42) AND column <= (x + 48)) AND (row > (y + 63) AND row <= (y + 69)) ) THEN
				red <= (OTHERS => '1'); --brazo3  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 39) AND column <= (x + 45)) AND (row > (y + 69) AND row <= (y + 72)) ) THEN
				red <= (OTHERS => '1'); --brazo4  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 33) AND column <= (x + 42)) AND (row > (y + 72) AND row <= (y + 78)) ) THEN
				red <= (OTHERS => '1'); --mano izq  
				green <= (OTHERS => '0');  
				blue <= (OTHERS => '0');
			 
			ELSIF ((column > (x + 60) AND column <= (x + 75)) AND (row > (y + 69) AND row <= (y + 81)) ) THEN
				red <= (OTHERS => '1'); --abdomen2  
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 57) AND column <= (x + 90)) AND (row > (y + 81) AND row <= (y + 87)) ) THEN
				red <= (OTHERS => '1'); --cadera
				green <= (OTHERS => '0'); 
				blue <= (OTHERS => '0'); 
			ELSIF ((column > (x + 75) AND column <= (x + 78)) AND (row > (y + 72) AND row <= (y + 81)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 1 
			ELSIF ((column > (x + 78) AND column <= (x + 81)) AND (row > (y + 75) AND row <= (y + 81)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 2 
			ELSIF ((column >= (x + 84) AND column <= (x + 87)) AND (row > (y + 87) AND row <= (y + 90)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 3 
			ELSIF ((column >= (x + 84) AND column <= (x + 87)) AND (row > (y + 81) AND row <= (y + 84)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 4 
			ELSIF ((column >= (x + 81) AND column <= (x + 99)) AND (row > (y + 87) AND row <= (y + 90)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 5 
			ELSIF ((column >= (x + 84) AND column <= (x + 102)) AND (row > (y + 90) AND row <= (y + 93)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 6
			ELSIF ((column >= (x + 90) AND column <= (x + 105)) AND (row > (y + 93) AND row <= (y + 96)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 7
			ELSIF ((column >= (x + 96) AND column <= (x + 104)) AND (row > (y + 96) AND row <= (y + 99)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 8
			ELSIF ((column >= (x + 102) AND column <= (x + 114)) AND (row > (y + 96) AND row <= (y + 102)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 9
			ELSIF ((column >= (x + 111) AND column <= (x + 114)) AND (row > (y + 93) AND row <= (y + 99)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 10
			ELSIF ((column >= (x + 105) AND column <= (x + 111)) AND (row > (y + 102) AND row <= (y + 105)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 11
			ELSIF ((column >= (x + 105) AND column <= (x + 108)) AND (row > (y + 105) AND row <= (y + 108)) ) THEN
				red <= (OTHERS => '1'); --Pierna Derecha 12 
			
			ELSIF ((column >= (x + 57) AND column <= (x + 63)) AND (row > (y + 81) AND row <= (y + 90)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 1,2
			ELSIF ((column >= (x + 54) AND column <= (x + 60)) AND (row > (y + 84) AND row <= (y + 93)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 3
			ELSIF ((column >= (x + 48) AND column <= (x + 60)) AND (row > (y + 87) AND row <= (y + 96)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 4
			ELSIF ((column >= (x + 42) AND column <= (x + 54)) AND (row > (y + 90) AND row <= (y + 96)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 5
			ELSIF ((column >= (x + 39) AND column <= (x + 48)) AND (row > (y + 93) AND row <= (y + 99)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 6
			ELSIF ((column >= (x + 36) AND column <= (x + 45)) AND (row > (y + 96) AND row <= (y + 102)) ) THEN
				red <= (OTHERS => '1'); --Pierna Izq 7
			ELSIF ((column >= (x + 27) AND column <= (x + 39)) AND (row > (y + 102) AND row <= (y + 105)) ) THEN
				red <= (OTHERS => '1'); --tenis iz 1
				ELSIF ((column >= (x + 27) AND column <= (x + 36)) AND (row > (y + 105) AND row <= (y + 108)) ) THEN
				red <= (OTHERS => '1'); --tenis iz 2

			ELSE 
				red <= (OTHERS => '0'); 
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;
		ELSE
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END PROCESS generador_imagen;

	display_enable : PROCESS (reloj_pixel) --- h_pixels=640; y_pixeles=400
	BEGIN
		IF rising_edge(reloj_pixel) THEN
			IF (h_count < h_pixels AND v_count < v_pixels) THEN
				display_ena <= '1';
			ELSE
				display_ena <= '0';
			END IF;
		END IF;
	END PROCESS display_enable;

	CambiarDePosicion : PROCESS (clk50MHz)
	BEGIN
		IF rising_edge(clk50MHz) THEN
			IF sw4 = '1' THEN
				x <= 10;
				y <= 20;
			ELSIF sw3 = '1' THEN
				x <= 480;
				y <= 20;
			ELSIF sw2 = '1' THEN
				x <= 480;
				y <= 260;
			ELSIF sw1 = '1' THEN
				x <= 10;
				y <= 260;
			ELSE
				x <= 250;
				y <= 130;
			END IF;
		END IF;
	END PROCESS;
END behaivoral;