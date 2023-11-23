/*

*/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 

entity textrom is
	port ( clk1,reset1: in std_logic;
			R1,G1,B1: out std_logic_vector(2 downto 0);  
			hsync1, vsync1: out std_logic);
end entity textrom;


architecture behavioral of textrom is

component font_test_gen is
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
end component;

component vga_sync is
   port(
      clk, reset: in std_logic;
      hsync, vsync: out std_logic;
      video_on, p_tick: out std_logic;
      pixel_x, pixel_y: out std_logic_vector (9 downto 0)
    );
end component;

component font_rom is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end component;

		signal video_on2: std_logic;
		signal font_word_in1: std_logic_vector(7 downto 0);
		signal rom_addr1: std_logic_vector (10 downto 0);
      signal pixel_x2, pixel_y2: std_logic_vector(9 downto 0);
     
      signal video_on1, p_tick1: std_logic;
      signal pixel_x1, pixel_y1: std_logic_vector (9 downto 0);
		signal addr1: std_logic_vector(10 downto 0);
      signal data1: std_logic_vector(7 downto 0);

      attribute chip_pin : string;		
		attribute chip_pin of clk1	       : signal is "P11";
		attribute chip_pin of reset1	   : signal is "C10";		  
      attribute chip_pin of hsync1	       : signal is "N3";
		attribute chip_pin of vsync1	       : signal is "n1"; 
      attribute chip_pin of R1		       : signal is "AA1, V1";
		attribute chip_pin of G1		       : signal is "W1, T2";
		attribute chip_pin of B1		       : signal is "P1, T1"; 

begin
	
	
	N1: font_rom port map (
         clk1,addr1,data1 
   );

	N2: vga_sync port map (
      clk1,reset1,hsync1,vsync1,video_on1,p_tick1,pixel_x1,pixel_y1
   );

	N3: font_test_gen port map (
      clk1,video_on1,font_word_in1,rom_addr1,pixel_x2,pixel_y2,R1,G1,B1
   );

   process (clk)
   begin if rising_edge(clk) then
      if p_tick ='1' then
         r_reg <= r_next;
         g_reg <= g_next;
         b_reg <= b_next;
      end if;
   end if;
   end process; 
         
	
end behavioral;