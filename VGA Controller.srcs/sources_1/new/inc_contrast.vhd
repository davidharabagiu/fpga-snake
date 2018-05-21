library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity CONTRAST_PLUS is
  Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
         pixel_out : out STD_LOGIC_VECTOR(11 downto 0) );
end CONTRAST_PLUS;

architecture ARCH of CONTRAST_PLUS is
signal red, green, blue : STD_LOGIC_VECTOR(5 downto 0);
signal  aux_red, aux_blue, aux_green : STD_LOGIC_VECTOR(5 downto 0);
begin
    
    aux_red <= ("00"& pixel_in(11 downto 8) - "001000");
    red <= ( aux_red + aux_red ) + ("00" & pixel_in(11 downto 8));
    aux_blue <= ( "00"& pixel_in(3 downto 0) - "001000");
    blue <= ( aux_blue + aux_blue ) + ("00" & pixel_in(3 downto 0));
    aux_green <= ("00"& pixel_in(7 downto 4) - "001000");
    green <= ( aux_green + aux_green )  + ("00" & pixel_in(7 downto 4));
    
    pixel_out(11 downto 8) <= "0000" when red(5) = '1' else
                              "1111" when red(4) = '1' else 
                              red(3 downto 0);
    pixel_out(7 downto 4) <=  "0000" when green(5) = '1' else
                              "1111" when green(4) = '1' else
                               green(3 downto 0);
    pixel_out(3 downto 0) <=  "0000" when blue(5) = '1' else
                              "1111" when blue(4) = '1' else 
                               blue(3 downto 0);
end architecture;