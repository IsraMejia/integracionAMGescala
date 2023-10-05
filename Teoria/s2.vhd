

--Esto implica que se maneja Registros , Contadores o Maquinas de estado
signal r_reg, r_next : std_logic_vetor(n_element to 0);
r_reg <= r next


--Recomendaciones de modelsim
Entity nombre_tb is 
end entity;

architecture testbrench of nombre_tb is 
    signal in1, in2 : std_logic;
    signal out1, out2 : std_logic;

    portmap(
        in1 => in1; in2 => in2;
        out1 => out1, out2 => out2;
    );