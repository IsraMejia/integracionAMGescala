LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL; 

ENTITY sonicos IS
	PORT ( 
		clk : IN STD_LOGIC;
		
		sensor_eco1 : IN STD_LOGIC; 
		led1, sensor_disp1 : OUT STD_LOGIC;
		Ucm1, Dcm1 : buffer STD_LOGIC_VECTOR (6 DOWNTO 0);
		
		sensor_eco2 : IN STD_LOGIC; 
		led2, sensor_disp2 : OUT STD_LOGIC;
		Ucm2, Dcm2 : buffer STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END sonicos;

ARCHITECTURE Behavioral OF sonicos IS 

	--Asignacion de Pines
	ATTRIBUTE chip_pin : STRING;
	ATTRIBUTE chip_pin OF clk : SIGNAL IS "P11"; 
	ATTRIBUTE chip_pin OF led1 : SIGNAL IS "B11";
	ATTRIBUTE chip_pin OF sensor_disp1 : SIGNAL IS "W6";
	ATTRIBUTE chip_pin OF sensor_eco1 : SIGNAL IS "V5";      
	ATTRIBUTE chip_pin OF Ucm1 : SIGNAL IS "F20,F19,H19,J18,E19,E20,F18";
	ATTRIBUTE chip_pin OF Dcm1 : SIGNAL IS "N20,N19,M20,N18,L18,K20,J20";
	
	

	
	ATTRIBUTE chip_pin OF led2 : SIGNAL IS "A8";
	ATTRIBUTE chip_pin OF sensor_disp2 : SIGNAL IS "AB2";
	ATTRIBUTE chip_pin OF sensor_eco2 : SIGNAL IS "AA2";
	ATTRIBUTE chip_pin OF Ucm2 : SIGNAL IS "C17,D17,E16,C16,C15,E15,C14"; 
	ATTRIBUTE chip_pin OF Dcm2 : SIGNAL IS "B17,A18,A17,B16,E18,D18,C18";
	

	component sonic IS
	PORT ( 
		clk :  IN STD_LOGIC; 
		sensor_eco : IN  STD_LOGIC; 
		led, sensor_disp : OUT  STD_LOGIC;
		Ucm, Dcm : buffer  STD_LOGIC_VECTOR (6 DOWNTO 0)
	); 
	END component sonic; 
 

BEGIN

	ultra1 :sonic
		port map(
			clk 		=> clk,
			sensor_eco  => sensor_eco1,
			led 		=> led1, 
			sensor_disp => sensor_disp1,
			Ucm		    => Ucm1,
			Dcm 		=> Dcm1
		)
	;
	
	ultra2 :sonic
		port map(
			clk => clk,
			sensor_eco   => sensor_eco2,
			led 		 => led2, 
			sensor_disp  => sensor_disp2,
			Ucm 		 => Ucm2,
			Dcm 		 => Dcm2
		)
	;
	  

	
	
	

END Behavioral;