library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP is
    generic (n : INTEGER := 8);
    port (
        a : in STD_LOGIC_VECTOR (n - 1 downto 0);
        b : in STD_LOGIC_VECTOR (n - 1 downto 0);
        y : out STD_LOGIC
    );
end COMP;

architecture Behavioral of COMP is

begin

    y <= '1' when a = b else '0';

end Behavioral;
