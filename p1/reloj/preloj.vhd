library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity preloj is --reldig
Port (
    reloj: in std_logic;
    AN: out std_logic_vector (3 downto 0);
    --L:  out std_logic_vector (6 downto 0);
    L1:  out std_logic_vector (6 downto 0);
    L2:  out std_logic_vector (6 downto 0);
    L3:  out std_logic_vector (6 downto 0);
    L4:  out std_logic_vector (6 downto 0);
);
end preloj;

architecture behavioral of preloj is
    signal segundo: std_logic;
    signal rapido: std_logic;
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

    attribute PIN_MAP : string;


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
            segundo <= cuenta(22);
            rapido <= cuenta(10);
        end process;
        

        unidades: process (segundo)
        variable cuenta: std_logic_vector(3 downto 0) := "0000";
        begin
            if rising_edge (segundo) then
                if cuenta ="1001" then
                    cuenta:="0000";
                    n <= '1';
                else
                    cuenta:= cuenta +1;
                    n <= '0';
                end if;
            end if;
            qum <= cuenta;
        end process;


        decenas: process (n)
        variable cuenta: std_logic_vector(3 downto 0) := "0000";
        begin
            if rising_edge (n) then
                if cuenta ="0101" then
                    cuenta:="0000";
                    e <= '1';
                else
                    cuenta:= cuenta +1;
                    e<= '0';
                end if;
            end if;
            Qdm <= cuenta;
        end process;

        HoraU: Process(E,reset)
        variable cuenta: std_logic_vector(3 downto 0):="0000";
        begin
            if rising_edge(E) then
                if cuenta="1001" then
                    cuenta:= "0000";
                    Z<='1';
                else
                    cuenta:=cuenta+1;
                    Z<='0';
                end if;
            end if;
            if reset='1' then
                cuenta:="0000";
            end if;
            Quh<=cuenta;
            U<=cuenta(2);
        end Process;


        HoraD: Process(Z, reset)
        variable cuenta: std_logic_vector(3 downto 0):="0000";
        begin
            if rising_edge(Z) then
                if cuenta="0010" then
                    cuenta:= "0000";
                    else
                    cuenta:=cuenta+1;
                    end if;
            end if;
            
            if reset='1' then
                cuenta:="0000";
            end if;
            Qdh<=cuenta;
            D <=cuenta(1);
        end Process;

        inicia: process (U,D)
        begin
            reset <= (U and D);
        end process;

        Contrapid: process (rapido)
            variable cuenta: std_logic_vector(1 downto 0) := "00";
        begin
            if rising_edge (rapido) then
                cuenta:= cuenta +1; 
            end if;
            Qr <= cuenta;
        end process;
        
        muxy: process (Qr)
        begin
            if Qr = "00" then
                Qs<= Qum;
            elsif Qr = "01" then
                Qs<= Qdm;
            elsif Qr = "10" then
                Qs<= Quh;
            elsif Qr = "11" then
                Qs<= Qdh;
            end if;
        end process;

        seledisplay: process (Qr)
        begin
            case Qr is
                when "00" => AN <= "1110";
                when "01" => AN <= "1101";
                when "10" => AN <= "1011";
                when others => AN <= "0111";
            end case;
        end process;

        with Qs select
            L <= "1000000" when "0000", --0
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

       