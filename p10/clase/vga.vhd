LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vga IS
    GENERIC (--Constantes para monitor VGA en 640x480
        CONSTANT h_pulse : INTEGER := 96;
        CONSTANT h_bp : INTEGER := 48;
        CONSTANT h_pixels : INTEGER := 640;
        CONSTANT h_fp : INTEGER := 16; 
        CONSTANT v_pulse : INTEGER := 2;
        CONSTANT v_bp : INTEGER := 33;
        CONSTANT v_pixels : INTEGER := 480;
        CONSTANT v_fp : INTEGER := 10
    );
    PORT ( 
        clk50MHz : IN STD_LOGIC;
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
	
    --Asignacion Pines
    attribute chip_pin : string;
    attribute chip_pin of clk50MHz     : signal is "P11";
    attribute chip_pin of h_sync	   : signal is "N3";
	attribute chip_pin of v_sync	   : signal is "n1";
    attribute chip_pin of red	       : signal is "AA1, V1, Y2, Y1";
	attribute chip_pin of green	       : signal is "W1, T2, R2, R1";
	attribute chip_pin of blue         : signal is "P1, T1, P4, N2";
	 
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

            IF ((row > 001 AND row < 640) AND
                (column > 100 AND column < 200)) THEN
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');

            ELSIF ((row > 001 AND row < 640) AND
                (column > 000 AND column < 100)) THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            
            ELSIF ((row > 001 AND row < 640) AND
                (column > 200 AND column < 300)) THEN
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            
            ELSIF ((row > 001 AND row < 640) AND
                (column > 300 AND column < 400)) THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
            
            ELSIF ((row > 001 AND row < 640) AND
                (column > 400 AND column < 500)) THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            
            ELSIF ((row > 001 AND row < 640) AND
                (column > 500 AND column < 600)) THEN
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
            
            ELSIF ((row > 001 AND row < 640) AND
                (column > 600 AND column < 700)) THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
            



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

    display_enable : PROCESS (reloj_pixel) --- h_pixels=640; y_pixeles=480
    BEGIN
        IF rising_edge(reloj_pixel) THEN
            IF (h_count < h_pixels AND v_count < v_pixels) THEN
                display_ena <= '1';
            ELSE
                display_ena <= '0';
            END IF;
        END IF;
    END PROCESS display_enable;

END behaivoral;