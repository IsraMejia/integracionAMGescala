
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
	
	process(pixel_x, pixel_y)
	begin 	
		if (unsigned(pixel_x(9 downto 8)) >= 0 and unsigned(pixel_x(9 downto 8)) <= 15) then 
			char_addr<= "0000010"; --figura 1 vertical izq
			row_addr<=pixel_y(3 downto 0);
			rom_addr <= char_addr & row_addr;
			bit_addr<=pixel_x(2 downto 0);
			font_bit <= font_word_in(to_integer(unsigned(not bit_addr)));
			if (unsigned(pixel_y(9 downto 6)) <= 0) then
				 text_bit_on <= font_bit;
			else
				 text_bit_on <= '0';
			end if;
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
			r <= "000";
			g <= "111";
			b <= "111";	
        else
          r<= "110"; -- sin color
			 g<= "000";
			 b<= "000";
         end if;
      end if;
   end process;
end arch;
