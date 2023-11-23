--*********************************
--*Tarea 4								 *
--*VLSI									 *
--*Realizado por:						 *
--*	Hernádez Jiménez Juan Carlos*
--*	Mejía Alba Israel Hipolito	 *
--*********************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity principal is
	port ( clk: in std_logic;
			Red,Green,Blue: out std_logic_vector (3 downto 0);
			hsync, vsync: out std_logic);
end entity principal;


architecture behavioral of principal is

	--Asignacion de Piness
	attribute chip_pin : string;
	attribute chip_pin of clk	    		 : signal is "P11";	
	attribute chip_pin of Red		 		 : signal is "Y1,Y2,v1,AA1";	
 	attribute chip_pin of Green		 	 : signal is "R1,R2,T2,W1";
	attribute chip_pin of Blue		 		 : signal is "N2,P4,T1,P1";
	attribute chip_pin of hsync		 	 : signal is "N3";
	attribute chip_pin of vsync		 	 : signal is "N1";

component relojLento is
	port ( clk50MHz: in std_logic;
			segundo: out std_logic );
end component;

component reloj is
	port ( clk50MHz: in std_logic;
			reloj_pixel: buffer std_logic );
end component;

component vga is
   port ( clk50MHz: in std_logic;
			h_sync: out std_logic;
			v_sync: out std_logic;
			rows: out integer;
			columns: out integer;
			display_ena_o: out std_logic	);
end component;

component generador is
	port (seg: in std_logic; 
			row: in integer;
			column: in integer;
			display_ena_i: in std_logic;
			R,G,B: out std_logic_vector(3 downto 0) );
end component;

		signal reloj_px, seg: std_logic;
		signal filas, columnas: integer;
		signal unidades: std_logic_vector(3 downto 0);
		signal R_r,G_r,B_r,R_n,G_n,B_n: std_logic_vector(3 downto 0);
		signal display_ena: std_logic;

begin
	
	
	N1: reloj port map (clk, reloj_px);
	N2: relojLento port map (clk, seg);
	N3: vga port map (reloj_px, hsync, vsync, filas, columnas,display_ena);
	N4: generador port map (seg, filas, columnas,display_ena,R_n,G_n,B_n);
	
	process (clk)
	begin
		R_r <= R_n;
		G_r <= G_n;
		B_r <= B_n;
	end process;
	
	process (clk)
	begin
	Red   <= R_r;
	Green <= G_r;
	Blue  <= B_r;
	end process;
	
end behavioral;