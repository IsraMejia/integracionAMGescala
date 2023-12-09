--Este archivo, es el top en cuanto a jerarquia del proyecto, 
--se encarga de crear e instanciar los componentes de todas las entidades 
--involucradas en la creacion del juego, y la interaccion necesaria entre cada una de ellas 

library ieee;
use ieee.std_logic_1164.all;
 
entity PINGPONG is  
	generic( 
	
		divisor:integer := 2; --divisor de frecuencia por defecto
		
		-- con estos divisores, el reloj de la raqueta es aprox 2x mas rapido que el de la pelota 
		divisor_raqueta : integer := 200000; --velocidad  jugadores (divisor de frecuencia)	
		divisor_pelota : integer  := 415000; --velocidad pelota (divisor de frecuencia)	
	
		--Marcos horizontales de pixeles visibles de una VGA de 640x480 visibles	
		Psh: integer := 96; --Ancho del pulso de sincronización horizontal en píxeles
		Ihv: integer := 144;--Inicio del período de actividad horizontal en píxeles
		Fhv: integer := 784;--Final del período de actividad horizontal en píxeles, fin de la parte visible

		TotalHorizontal: integer := 800;--Ancho total de la señal horizontal en píxeles o ciclos (visibles o no visibles)
		Psv: integer := 2;  --Pulsos de sincronización vertical en líneas de píxeles

		--Marcos verticales de pixeles visibles de una VGA de 640x480 visibles	
		Ivv: integer := 35; --Inicio del período de actividad vertical en líneas de píxeles
		--33+2 // 32= BPV aqui es donde se empiezan a dibujar pixeles de forma vertical
		Fvv: integer := 515;--Final del período de actividad vertical en líneas de píxeles, fin de la parte visible
		--35+480
		TotalVertical: integer := 525; --Ancho total de la señal vertical en líneas de píxeles o ciclos (visibles o no visibles)
		--515+10
		
		--Definicion de medidas finales del juego
		MedidaVerticalRaqueta: integer := 95; --Medidas verticales de las raquetas de los jugadores
		MedidaHorizontalRaqueta: integer := 15  --Medidas horizontales de las raquetas de los jugadores
	);

	port(
		clk : in std_logic; --Reloj de 50Mhz de la FPGA DE10-Lite
		encendido: in std_logic;--Si esta encendido el juego o no 
		
		Hsync	: buffer std_logic; -- Horizontal sync pulse. señal de sincronizacion horizontal
		Vsync	: buffer std_logic; -- Vertical sync pulse. señal de sincronizacion vertical

		palancasjugadores : in std_logic_vector(1 downto 0); --Switches/controles de cada jugador
		start_game		: in std_logic; --Bit de control para saber si el juego ha iniciado
		seg_marcador_j1 	: out std_logic_vector(6 downto 0);
		seg_marcador_j2	: out std_logic_vector(6 downto 0);
		separador1_marcador		: out std_logic;
		separador2_marcador		: out std_logic;
		
		--ball_speed : in std_logic_vector(1 downto 0);
		--cambiar a std_logic
		
		--Vectores RGB para los colores al momento de dibujar la interfaz del juego en el monitor VGA
		R, G, B 		 : out std_logic_vector(3 downto 0);
 
		--Para los sensores Ultrasonicos de cada jugador
		sensor_eco1 : IN STD_LOGIC; 
		led1, sensor_disp1 : OUT STD_LOGIC;
		--Ucm1, Dcm1 : buffer STD_LOGIC_VECTOR (6 DOWNTO 0);
		sonicplayer1: OUT STD_LOGIC;
		
		sensor_eco2 : IN STD_LOGIC; 
		led2, sensor_disp2 : OUT STD_LOGIC;
		--Ucm2, Dcm2 : buffer STD_LOGIC_VECTOR (6 DOWNTO 0);
		sonicplayer2: out STD_LOGIC
	);

end  PINGPONG;



architecture PINGPONG_bhv of PINGPONG is

	--Relojes de imagenes
	signal reloj_pixeles 		 :  std_logic;--Señal de reloj para contar los píxeles
	signal reloj_raquetas		 :  std_logic;--Señal de reloj para las raquetas
	signal reloj_pelota	     :  std_logic;--Señal de reloj para el balon
	
	signal Hactive :  std_logic; --indican cuando los píxeles deben ser mostrados en la pantalla.
	-- '1' durante el período de actividad horizontal y '0' el resto del tiempo
	signal Vactive :  std_logic;--indica cuando una línea de píxeles deben ser mostradas en la pantalla.
	-- '1' durante el período de actividad vertical y '0' el resto del tiempo.
	signal habilitador :  std_logic; --1 cuando Hactive y Vactive son 1 -> mostrar pixeles en pantalla
	
	signal marcador_j1  : integer;
	signal marcador_j2  : integer;

	signal sonicplayer1_internal: STD_LOGIC ;-- := '0';  -- Inicialización con valor por defecto
	signal sonicplayer2_internal: STD_LOGIC ;-- := '0';  -- Inicialización con valor por defecto



		--Asignacion de Pines
		ATTRIBUTE chip_pin : STRING;
		attribute chip_pin of clk	       : signal is "N14"; 
		attribute chip_pin of encendido	       : signal is "A12";		
		attribute chip_pin of start_game       : signal is "B8";
				
		attribute chip_pin of Hsync	       : signal is "N3";
		attribute chip_pin of Vsync	       : signal is "n1";
		
		attribute chip_pin of R		       : signal is "AA1, V1, Y2, Y1";
		attribute chip_pin of G		       : signal is "W1, T2, R2, R1";
		attribute chip_pin of B		       : signal is "P1, T1, P4, N2";
		
		ATTRIBUTE chip_pin OF seg_marcador_j1 : SIGNAL IS "F20,F19,H19,J18,E19,E20,F18";
		attribute chip_pin of separador1_marcador : signal is "E17";
		attribute chip_pin of separador2_marcador : signal is "B22";
		ATTRIBUTE chip_pin OF seg_marcador_j2 : SIGNAL IS "B17,A18,A17,B16,E18,D18,C18";

		ATTRIBUTE chip_pin OF palancasjugadores : SIGNAL IS "C10,F15";
		
		--Para los sensores Ultrasonicos
		ATTRIBUTE chip_pin OF led1 : SIGNAL IS "B11";
		ATTRIBUTE chip_pin OF sensor_disp1 : SIGNAL IS "W6";
		ATTRIBUTE chip_pin OF sensor_eco1 : SIGNAL IS "V5";       
				
		ATTRIBUTE chip_pin OF led2 : SIGNAL IS "A8";
		ATTRIBUTE chip_pin OF sensor_disp2 : SIGNAL IS "AB2";
		ATTRIBUTE chip_pin OF sensor_eco2 : SIGNAL IS "AA2"; 

	 
	
	--Componente que genera los relojes que se ocupan para el juego
	component divisor_frec is		
		generic( 
			divisor 	 : integer:= 2
		);		
		port( 	
			reloj_entrada 	: in std_logic;
			encendido 		: in std_logic;
			reloj_salida: out std_logic
		);	
	end component divisor_frec;
	

	--Componente para controlar el monitor VGA
	component controlador_vga is
		generic(		
			--Marcos horizontales de pixeles visibles de una VGA de 640x480 visibles	
			Psh: integer := 96; --Ancho del pulso de sincronización horizontal en píxeles
			Ihv: integer := 144;--Inicio del período de actividad horizontal en píxeles
			Fhv: integer := 784;--Final del período de actividad horizontal en píxeles, fin de la parte visible

			TotalHorizontal: integer := 800;--Ancho total de la señal horizontal en píxeles o ciclos (visibles o no visibles)
			Psv: integer := 2;  --Pulsos de sincronización vertical en líneas de píxeles

			--Marcos verticales de pixeles visibles de una VGA de 640x480 visibles	
			Ivv: integer := 35; --Inicio del período de actividad vertical en líneas de píxeles
			--33+2 // 32= BPV aqui es donde se empiezan a dibujar pixeles de forma vertical
			Fvv: integer := 515;--Final del período de actividad vertical en líneas de píxeles, fin de la parte visible
			--35+480
			TotalVertical: integer := 525 --Ancho total de la señal vertical en líneas de píxeles o ciclos (visibles o no visibles)
			--515+10
		);			
		port(
			reloj_pixeles	: in std_logic; --Señal de reloj para contar los píxeles
			encendido	: in std_logic; --esta encendido el juego o no 

			--BUFFER : permiten retroalimentacion interna en la entidad, pero no desde otras entidades
			--util usar buffers ya que se retrolimentan las señales de sincronizacion  con datos de esta propia entidad nada mas
			--buffers de entrada
			Hsync	: buffer std_logic; -- Horizontal sync pulse. señal de sincronizacion horizontal
			Vsync	: buffer std_logic; -- Vertical sync pulse. señal de sincronizacion vertical
			--buffers de salida
			Hactive : buffer std_logic; --indican cuando los píxeles deben ser mostrados en la pantalla.
			-- '1' durante el período de actividad horizontal y '0' el resto del tiempo.
			Vactive : buffer std_logic; --indica cuando una línea de píxeles deben ser mostradas en la pantalla.
			-- '1' durante el período de actividad vertical y '0' el resto del tiempo.

			habilitador : out std_logic --1 cuando Hactive y Vactive son 1 -> mostrar pixeles en pantalla
		);
	end component controlador_vga;

	component sonic IS
	PORT ( 
		clk :  IN STD_LOGIC; 
		sensor_eco : IN  STD_LOGIC; 
		led, sensor_disp : OUT  STD_LOGIC;
		--Ucm, Dcm : buffer  STD_LOGIC_VECTOR (6 DOWNTO 0);
		sonicplayer: out STD_LOGIC
	); 
	END component sonic; 

	
	component imprime_pantalla is	
		--Aqui se define el tamaño final de la pelota
		generic(		
			--Marcos horizontales de pixeles visibles de una VGA de 640x480 visibles	
			Psh: integer := 96; --Ancho del pulso de sincronización horizontal en píxeles
			Ihv: integer := 144;--Inicio del período de actividad horizontal en píxeles
			Fhv: integer := 784;--Final del período de actividad horizontal en píxeles, fin de la parte visible

			TotalHorizontal: integer := 800;--Ancho total de la señal horizontal en píxeles o ciclos (visibles o no visibles)
			Psv: integer := 2;  --Pulsos de sincronización vertical en líneas de píxeles

			--Marcos verticales de pixeles visibles de una VGA de 640x480 visibles	
			Ivv: integer := 35; --Inicio del período de actividad vertical en líneas de píxeles
			--33+2 // 32= BPV aqui es donde se empiezan a dibujar pixeles de forma vertical
			Fvv: integer := 515;--Final del período de actividad vertical en líneas de píxeles, fin de la parte visible
			--35+480
			TotalVertical: integer := 525; --Ancho total de la señal vertical en líneas de píxeles o ciclos (visibles o no visibles)
			--515+10
			
			MedidaVerticalRaqueta: integer := 70; --Medidas verticales de las raquetas de los jugadores
			MedidaHorizontalRaqueta: integer := 15;  --Medidas horizontales de las raquetas de los jugadores
			MedidaPelota: integer := 10 --tamaño de la pelota
		); --TAMAÑO DE LA PELOTA
		
		port(
			encendido	     : in std_logic;--Si esta encendido el juego o no 
			
			--Relojes de imagenes
			reloj_pixeles 		 : in std_logic;--Señal de reloj para contar los píxeles
			reloj_raquetas		 : in std_logic;--Señal de reloj para las raquetas
			reloj_pelota	     : in std_logic;--Señal de reloj para el balon
			
			--puertos de sincronizacion 
			Hactive : in std_logic; --indican cuando los píxeles deben ser mostrados en la pantalla.
			-- '1' durante el período de actividad horizontal y '0' el resto del tiempo
			Vactive : in std_logic;--indica cuando una línea de píxeles deben ser mostradas en la pantalla.
			-- '1' durante el período de actividad vertical y '0' el resto del tiempo.
			Hsync : in std_logic; -- Horizontal sync pulse. señal de sincronizacion horizontal
			Vsync : in std_logic; -- Vertical sync pulse. señal de sincronizacion vertical
			habilitador  : in std_logic; --1 cuando Hactive y Vactive son 1 -> mostrar pixeles en pantalla

			palancasjugadores : in std_logic_vector(1 downto 0); --Switches/controles de cada jugador
			start_game		 : in std_logic;	--Bit de control para saber si el juego ha iniciado
			marcador_j1			 : buffer integer;
			marcador_j2			 : buffer integer;
			
			--puertos de colores
			R,G,B			 : out std_logic_vector(3 downto 0);
			
			sonicplayer1: in STD_LOGIC; 
        	sonicplayer2: in STD_LOGIC 
			
		);
	end component imprime_pantalla;


	--Componente para mostrar el marcador en pantalla
	component marcador_dss is
		port(
			marcador_j1 : in integer;	--score en decimal del jugador 1 
			marcador_j2 : in integer;	--score en decimal del jugador 2 

			seg_marcador_j1	 : out std_logic_vector(6 downto 0); -- 7 segmentos del marcador 1
			separador1_marcador	 : out std_logic; 	--barra que divide los marcadores de cada jugador
			separador2_marcador	 : out std_logic; 	--barra que divide los marcadores de cada jugador
			seg_marcador_j2	 : out std_logic_vector(6 downto 0) -- 7 segmentos del marcador 1
			
		);
	end component;
	

			

begin

	----Mapeando puertos para el divisor de frecuencias que nos de el reloj de control de pixeles
	inst_div_f: divisor_frec	 
		generic map (divisor => divisor)
		port map(reloj_entrada => clk,  encendido => encendido,   reloj_salida => reloj_pixeles)
	;
	
	--Mapeando puertos para Sincronizar la imagen del monitor VGA pixel a pixel
	ins_controlador_vga: controlador_vga	
		generic map(
			Psh => Psh,
			Ihv => Ihv,
			Fhv => Fhv,
			TotalHorizontal => TotalHorizontal,
			Psv => Psv,
			Ivv => Ivv,
			Fvv => Fvv,
			TotalVertical => TotalVertical
		)						
		port map(
			reloj_pixeles 	=> reloj_pixeles, 
			encendido	=> encendido,
			Hsync		=> Hsync,
			Vsync		=> Vsync,
			Hactive		=> Hactive,
			Vactive		=> Vactive,
			habilitador 		=> habilitador
		)
	;
		
	--Mapeando puertos para los ultrasonicos de los jugadores
	ultra1 :sonic
	port map(
		clk 		=> clk,
		sensor_eco  => sensor_eco1,
		led 		=> led1, 
		sensor_disp => sensor_disp1,
		--Ucm		    => Ucm1, 
		--Dcm 		=> Dcm1,
		sonicplayer => sonicplayer1_internal 
	)
	;

	ultra2 :sonic
		port map(
			clk => clk,
			sensor_eco   => sensor_eco2,
			led 		 => led2, 
			sensor_disp  => sensor_disp2,
			--Ucm 		 => Ucm2,
			--Dcm 		 => Dcm2,
			sonicplayer => sonicplayer2_internal
		)
	;
	
	--Mapeando puertos para poder Dibujar en pantalla el videojuego
	ins_imprime_pantalla: imprime_pantalla	
		generic map(
			Psh => Psh,
			Ihv => Ihv,
			Fhv => Fhv,
			TotalHorizontal => TotalHorizontal,
			Psv => Psv,
			Ivv => Ivv,
			Fvv => Fvv,
			TotalVertical => TotalVertical,
			MedidaVerticalRaqueta => medidaVerticalRaqueta,
			MedidaHorizontalRaqueta => medidaHorizontalRaqueta
		)		
		port map(	
			reloj_pixeles	=> reloj_pixeles,
			reloj_raquetas	=> reloj_raquetas, 
			reloj_pelota	=> reloj_pelota,
			encendido	=> encendido,
			Hactive		=> Hactive,
			Vactive 	=> Vactive,
			Hsync		=> Hsync,
			Vsync		=> Vsync,
			habilitador		=> habilitador,
			palancasjugadores=> palancasjugadores,
			start_game	=> start_game,
			marcador_j1		=> marcador_j1,
			marcador_j2		=> marcador_j2, 
			R		    => R,
			G			=> G,
			B			=> B,
			sonicplayer1 => sonicplayer1_internal, 
        	sonicplayer2 => sonicplayer2_internal
		)
	;
				
	
	--Mapeando puertos para el reloj de los jugadores
	ins_reloj_jugadores: divisor_frec 
		generic map (divisor => divisor_raqueta )
		port map(reloj_entrada => clk, encendido => encendido, reloj_salida => reloj_raquetas)
	;
	
	----Mapeando puertos para el reloj de la pelota
	ins_reloj_pelota: divisor_frec
		generic map (divisor => divisor_pelota)
		port map(reloj_entrada => clk, encendido => encendido, reloj_salida => reloj_pelota)
	;
	
	----Mapeando puertos para mostrar en pantalla los marcadores
	ins_marcador: marcador_dss
		port map(
			marcador_j1 => marcador_j1, marcador_j2 => marcador_j2, 
			seg_marcador_j1 => seg_marcador_j1, separador1_marcador => separador1_marcador, 
			separador2_marcador => separador2_marcador, seg_marcador_j2 => seg_marcador_j2 
		)
	;
					
end PINGPONG_bhv;

