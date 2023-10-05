library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity relojDigital is
Port (
		reloj: in std_logic;
		UM: out std_logic_vector (6 downto 0);
		DM: out std_logic_vector (6 downto 0);
		UH: out std_logic_vector (6 downto 0);
		DH: out std_logic_vector (6 downto 0)
);
end relojDigital;

architecture behavioral of relojDigital is

	signal segundo: std_logic;
	--signal rapido: std_logic;
	signal n: std_logic;
	signal Qs: std_logic_vector(3 downto 0);
	signal Qum: std_logic_vector(3 downto 0);
	signal Qdm: std_logic_vector(3 downto 0);
	signal e: std_logic;
	signal Qr: std_logic_vector(1 downto 0);
	signal Quh: std_logic_vector(3 downto 0);
	signal Qdh: std_logic_vector(3 downto 0);
	signal z: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal reset: std_logic;

	begin

		divisor: process (reloj)
			variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
		begin
			if rising_edge (reloj) then
				if cuenta=X"48009E0" then
					cuenta:= X"0000000";
				else
					cuenta:= cuenta +1;
				end if;
			end if;
			segundo <= cuenta(10);
			--rapido <= cuenta(10);
		end process;
		
		unidades: process (segundo)
			variable cuenta: std_logic_vector(3 downto 0) := "0000";
		begin
			if rising_edge (segundo) then
				if cuenta ="1001" then --9 limite de unidades segundos
					cuenta:="0000";
					n <= '1';
				else
					cuenta:= cuenta +1;
					n <= '0';
				end if;
			end if;
			qum <= cuenta; --Señan de unidades que se manda al muxy
		end process;
		
		decenas: process (n)
			variable cuenta: std_logic_vector(3 downto 0) := "0000";
		begin
			if rising_edge (n) then
				if cuenta ="0101" then --5 limite de decenas de seg en min
					cuenta:="0000";
					e <= '1';
				else
					cuenta:= cuenta +1;
					e<= '0';
				end if;
			end if;
			Qdm <= cuenta; --Señan de decenas que se manda al muxy
		end process;
		

		HoraU: Process(E,reset) --Se ejecuta cuando haya un FS de E o reset=1
			variable cuenta: std_logic_vector(3 downto 0):="0000";
		begin
			if rising_edge(E) then
				if cuenta="1001" then -- 9 Limite unidades de hora
					cuenta:= "0000";
					Z<='1';
					elsif Quh = "0001" and Qdh = "0001" then
						cuenta:="0000"
				else
					cuenta:=cuenta+1;
					Z<='0';
				end if;
			end if;
			--if reset='1' then
			--	cuenta:="0000";
			--end if;
			Quh<=cuenta;  --Señan de unidades de horas que se manda al muxy
			U<=cuenta(2);
			--El bit de indice 2 se usa como referencia de las unidades de hora
		end Process;


		HoraD: Process(Z, reset) --Activa en Z=1 o reset = 1
			variable cuenta: std_logic_vector(3 downto 0):="0000";
		begin
			if rising_edge(Z) then
				if cuenta="0010" then -- 2 Max decenas horas, solo puede ser 1
					cuenta:= "0000";
				else
					cuenta:=cuenta+1;
				end if;
			end if;
			if reset='1' then	--Reinicia el contador de horas
				cuenta:="0000";
			end if;
			Qdh<=cuenta; --Señan de Dececnas de horas que se manda al muxy
			D <=cuenta(1); 
			--El bit de indice 1 se usa como referencia de las decenas de hora
		end Process;
		
		inicia: process (U,D)
		begin
			reset <= (U and D);
		end process;
		
		--	Contrapid: process (rapido)
		--		variable cuenta: std_logic_vector(1 downto 0) := "00";
		--	begin
		--		if rising_edge (rapido) then
		--			cuenta:= cuenta +1;
		--		end if;
		--		Qr <= cuenta;
		--	end process;
		
		with Qum select
			UM <=   "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
					"1000000" when others; --F

		with Qdm select
			DM <=	"1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
				"1000000" when others; --F

		with Quh select
			UH <= "1000000" when "0000", --0
				"1111001" when "0001", --1
				"0100100" when "0010", --2
				"0110000" when "0011", --3
				"0011001" when "0100", --4
				"0010010" when "0101", --5
				"0000010" when "0110", --6
				"1111000" when "0111", --7
				"0000000" when "1000", --8
				"0010000" when "1001", --9
			"1000000" when others; --F

		with Qdh select
			DH <= 
				"1000000" when "0000", --0
				"1111001" when "0001", --1
				"0100100" when "0010", --2
				"0110000" when "0011", --3
				"0011001" when "0100", --4
				"0010010" when "0101", --5
				"0000010" when "0110", --6
				"1111000" when "0111", --7
				"0000000" when "1000", --8
				"0010000" when "1001", --9
			"1000000" when others; --F

end Behavioral;