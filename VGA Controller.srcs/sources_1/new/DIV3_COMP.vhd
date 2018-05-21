library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DIV3_COMP is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           c : out STD_LOGIC_VECTOR (1 downto 0);
           r : out STD_LOGIC_VECTOR (1 downto 0));
end DIV3_COMP;

architecture Behavioral of DIV3_COMP is

begin

    c <= "00" when x < 3
        else "01" when x < 6
        else "10" when x < 9
        else "11";
    
    r <= "00" when (x = 0 or x = 3 or x = 6 or x = 9)
        else "01" when (x = 1 or x = 4 or x = 7 or x = 10)
        else "10";

end Behavioral;
