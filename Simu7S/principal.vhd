LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY principal IS
	PORT (
		clk : IN STD_LOGIC;
		Red, Green, Blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		hsync, vsync : OUT STD_LOGIC);
END ENTITY principal;
ARCHITECTURE behavioral OF principal IS

	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF clk : SIGNAL IS "P11";
	ATTRIBUTE chip_pin OF Red : SIGNAL IS "Y1,Y2,v1,AA1";
	ATTRIBUTE chip_pin OF Green : SIGNAL IS "R1,R2,T2,W1";
	ATTRIBUTE chip_pin OF Blue : SIGNAL IS "N2,P4,T1,P1";
	ATTRIBUTE chip_pin OF hsync : SIGNAL IS "N3";
	ATTRIBUTE chip_pin OF vsync : SIGNAL IS "N1";

	COMPONENT relojLento IS
		PORT (
			clk50MHz : IN STD_LOGIC;
			segundo : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT reloj IS
		PORT (
			clk50MHz : IN STD_LOGIC;
			reloj_pixel : BUFFER STD_LOGIC);
	END COMPONENT;

	COMPONENT vga IS
		PORT (
			clk50MHz : IN STD_LOGIC;
			h_sync : OUT STD_LOGIC;
			v_sync : OUT STD_LOGIC;
			rows : OUT INTEGER;
			columns : OUT INTEGER;
			display_ena_o : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT generador IS
		PORT (
			seg : IN STD_LOGIC;
			row : IN INTEGER;
			column : IN INTEGER;
			posicionx, posicionx1, posicionx2 : IN INTEGER;
			display_ena_i : IN STD_LOGIC;
			R, G, B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;

	SIGNAL reloj_px, seg : STD_LOGIC;
	SIGNAL filas, columnas : INTEGER;
	SIGNAL unidades : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL R_r, G_r, B_r, R_n, G_n, B_n : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL display_ena : STD_LOGIC;

BEGIN
	N1 : reloj PORT MAP(clk, reloj_px);
	N2 : relojLento PORT MAP(clk, seg);
	N3 : vga PORT MAP(reloj_px, hsync, vsync, filas, columnas, display_ena);
	N4 : generador PORT MAP(seg, filas, columnas, 100, 300, 500, display_ena, R_n, G_n, B_n);

	PROCESS (clk)
	BEGIN
		R_r <= R_n;
		G_r <= G_n;
		B_r <= B_n;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		Red <= R_r;
		Green <= G_r;
		Blue <= B_r;
	END PROCESS;

END behavioral;