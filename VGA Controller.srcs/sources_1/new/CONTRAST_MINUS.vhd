library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity CONTRAST_MINUS is
  Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
         pixel_out : out STD_LOGIC_VECTOR(11 downto 0) );
end CONTRAST_MINUS;

architecture ARCH of CONTRAST_MINUS is
signal red, green, blue : STD_LOGIC_VECTOR(3 downto 0);
signal  aux_red, aux_blue, aux_green : STD_LOGIC_VECTOR(3 downto 0);
begin
    
    aux_red <= (pixel_in(11 downto 8) - "1000");
    red <= "00" & aux_red(3 downto 2) + "1000";
    aux_blue <= (pixel_in(3 downto 0) - "1000");
    blue <= "00" & aux_blue(3 downto 2) + "1000";
    aux_green <= (pixel_in(7 downto 4) - "1000");
    green <= "00" & aux_green(3 downto 2) + "1000";
    
    pixel_out(11 downto 8) <= red ;
    pixel_out(7 downto 4) <=  green;
    pixel_out(3 downto 0) <=  blue;
    
end architecture;