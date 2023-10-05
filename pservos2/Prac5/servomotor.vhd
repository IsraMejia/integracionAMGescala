Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;

Entity servomotor_disp is
      Port (reloj_sv : in std_logic;
			Pini, Pfin, Inc, Dec : in std_logic;
			D1,D2: out std_logic_vector(6 downto 0);				   
			control : out std_logic);



End entity;

Architecture Behavioral of servomotor_disp is


--Asignacion de Pines
	attribute chip_pin : string;
	attribute chip_pin of reloj_sv	       : signal is "P11";	
 	attribute chip_pin of Pini	   : signal is "C12";
	attribute chip_pin of Pfin	   : signal is "C10"; 
	attribute chip_pin of Inc	   : signal is "D12"; 
	attribute chip_pin of Dec	   : signal is "C11"; 
	attribute chip_pin of control	   : signal is "V5"; 
	attribute chip_pin of D1	  	 : signal is "C17,D17,E16,C16,C15,E15,C14";
	attribute chip_pin of D2	   	 : signal is "B17,A18,A17,B16,E18,D18,C18"; 

Component divisor is
     Port (reloj : in std_logic;
     div_reloj: out std_logic);

End Component;

Component pwm is
Port (reloj_pwm : in std_logic;
               D: in std_logic_vector(7 downto 0);
               S: out std_logic);

End Component;

Signal reloj_serv: std_logic;
Signal pulso : std_logic_vector(7 downto 0) := X"00";


Begin
      U1: divisor Port map(reloj_sv, reloj_serv);
      U2: pwm Port map(reloj_serv, pulso, control);

		

		Process(reloj_serv, Pini, Pfin, Inc, Dec)
      Variable valor : std_logic_vector(7 downto 0) := X"00";
      Variable cuenta : integer range 0 to 1023 := 0;

      Begin 
           If reloj_serv= '1' and reloj_serv'event then
              If (cuenta > 0) then
                  cuenta := cuenta - 1;
              Else
                  If Pini = '1' then
                     valor := X"00";

                     Elsif Pfin = '1' then
                           valor := X"23";

                     Elsif Inc = '1' and valor < X"23" then
                           valor := valor + 1;

                     Elsif Dec = '1' and valor > X"00" then
                           valor := valor - 1;

                  End if;
						cuenta := 1023;
              End if;
           End if;
       pulso <= valor;

      End process;

	process(pulso)
	begin
	if (pulso = X"00") then
		D1<="1000000";
		D2<="1000000";	
	elsif (pulso = X"01") then
		D1<="1111001"; 
		D2<="1000000";
	elsif (pulso = X"02") then
		D1<="0100100";
		D2<="1000000";
	elsif (pulso = X"03") then
		D1<="0110000";
		D2<="1000000";
	elsif (pulso = X"04") then
		D1<="0011001";
		D2<="1000000";
	elsif (pulso = X"05") then
		D1<="0010010";
		D2<="1000000";
	elsif (pulso = X"06") then
		D1<="0000010";
		D2<="1000000";
	elsif (pulso = X"07") then
		D1<="0111000";
		D2<="1000000";
	elsif (pulso = X"08") then
		D1<="0000000";
		D2<="1000000";
	elsif (pulso = X"09") then --9
		D1<="0010000";
		D2<="1000000";
	elsif (pulso = X"0A") then
		D1<="1000000";
		D2<="1111001";
	elsif (pulso = X"0B") then
		D1<="1111001";
		D2<="1111001";
	elsif (pulso = X"0C") then
		D1<="0100100";
		D2<="1111001";
	elsif (pulso = X"0D") then
		D1<="0110000";
		D2<="1111001";
	elsif (pulso = X"0E") then
		D1<="0011001";
		D2<="1111001";
	elsif (pulso = X"0F") then
			D1<="0010010";
		D2<="1111001";
	elsif (pulso = X"10") then
		D1<="0000010";
		D2<="1111001";
	elsif (pulso = X"11") then
		D1<="0111000";
		D2<="1111001";
	elsif (pulso = X"12") then
		D1<="0000000";
		D2<="1111001";
	elsif (pulso = X"13") then
		D1<="0010000"; --19
		D2<="1111001";
	elsif (pulso = X"14") then
		D1<="1000000";
		D2<="0100100";
	elsif (pulso = X"15") then
		D1<="1111001";
		D2<="0100100";
	elsif (pulso = X"16") then
		D1<="0100100";
		D2<="0100100";
	elsif (pulso = X"17") then
		D1<="0110000";
		D2<="0100100";
	elsif (pulso = X"18") then
		D1<="0011001";
		D2<="0100100";
	elsif (pulso = X"19") then
		D1<="0010010";
		D2<="0100100";
	elsif (pulso = X"1A") then
		D1<="0000010";
		D2<="0100100";
	elsif (pulso = X"1B") then
		D1<="0111000";
		D2<="0100100";
	elsif (pulso = X"1C") then
		D1<="0000000";
		D2<="0100100";
	elsif (pulso = X"1D") then
		D1<="0010000"; --29
		D2<="0100100";
	elsif (pulso = X"1E") then
		D1<="1000000";
		D2<="0110000";
	elsif (pulso = X"1F") then
		D1<="1111001";
		D2<="0110000";
	elsif (pulso = X"20") then
		D1<="0100100";
		D2<="0110000";
	elsif (pulso = X"21") then
		D1<="0110000";
		D2<="0110000";
	elsif (pulso = X"22") then
		D1<="0011001";
		D2<="0110000";
	elsif (pulso = X"03") then
		D1<="0010010";
		D2<="0110000";
	end if;
	end process;
End behavioral;
