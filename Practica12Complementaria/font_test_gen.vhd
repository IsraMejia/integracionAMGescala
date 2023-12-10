
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity font_test_gen is
   port(
      clk: in std_logic;
      video_on: in std_logic;
		font_word_in: in std_logic_vector(7 downto 0);
		rom_addr: out std_logic_vector (10 downto 0);
      pixel_x, pixel_y: std_logic_vector(9 downto 0);
		flags: in std_logic_vector (3 downto 0);
      r: out std_logic_vector(2 downto 0);
		g: out std_logic_vector(2 downto 0);
		b: out std_logic_vector(2 downto 0)
   );
end font_test_gen;

architecture arch of font_test_gen is
   
   signal char_addr: std_logic_vector(6 downto 0);
   signal row_addr: std_logic_vector(3 downto 0); 
   signal bit_addr: std_logic_vector(2 downto 0);
   signal font_bit, text_bit_on: std_logic;
begin
	
	process(pixel_x, pixel_y, flags)
	begin	 
	if flags = "1000" then
		char_addr <= (others => '0');
	else 
		if ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 3 ))then
			char_addr <= "1001001"; --I
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 4 ))then
			char_addr <= "1010011"; --S
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 5 ))then
			char_addr <= "1010010"; --R 
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 6 ))then
			char_addr <= "1000001"; --A

		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 8 ))then
			char_addr <= "1001101"; --M
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 9 ))then
			char_addr <= "1000101"; --E
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 10 ))then
			char_addr <= "1001010"; --J
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 11 ))then
			char_addr <= "1001001"; --I
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 12 ))then 
			char_addr <= "1000001"; --A 

		--Marco Esquina vertical 1
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 2 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 3 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 4 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 5 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 6 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 7 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 8 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 9 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 10 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 11 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 12 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =2) and 
			(unsigned(pixel_x(9 downto 5)) = 13 ))then 
			char_addr <= "1000000"; 
		
		--Marco Esquina vertical 2
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 2 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 3 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 4 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 5 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 6 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 7 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 8 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 9 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 10 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 11 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 12 ))then 
			char_addr <= "1000000"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =4) and 
			(unsigned(pixel_x(9 downto 5)) = 13 ))then 
			char_addr <= "1000000"; 
		
		--Marcos a los lados
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 2 ))then 
			char_addr <= "0111100"; 
		elsif ((unsigned(pixel_y(9 downto 6)) =3) and 
			(unsigned(pixel_x(9 downto 5)) = 13 ))then 
			char_addr <= "0111110"; 
		





		else
			char_addr <= (others => '0');
		end if;
	end if;


         row_addr <= pixel_y(5 downto 2);
         rom_addr <= char_addr & row_addr;
         bit_addr <= pixel_x(4 downto 2);
         font_bit <= font_word_in(to_integer(unsigned(not bit_addr)));
			
			if (unsigned(pixel_y(9 downto 6)) >= 2) and 
				(unsigned(pixel_y(9 downto 6)) <  4+1) and 
				(unsigned(pixel_x(9 downto 5)) >= 1) and 
				(unsigned(pixel_x(9 downto 5)) < 13 + 1) then
				text_bit_on <= font_bit;
			else
				text_bit_on <= '0';
			end if;
			
	end process;		
						  
	
   -- circuito de multiplexeo rgb 
   process(video_on,font_bit,text_bit_on)
   begin
      if video_on='0' then
          	r <= "000"; --no hay color
			 g <= "000";
			 b <= "000";
      else
        if text_bit_on='1' then
			r<= "110"; -- color del texto
			g<= "110";
			b<= "000";
        else
          	r<= "000"; -- sin color
			g<= "000";
			b<= "000";
         end if;
      end if;
   end process;
end arch;

