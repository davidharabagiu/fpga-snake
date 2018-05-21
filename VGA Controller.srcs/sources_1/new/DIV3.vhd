library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DIV3 is
    generic (n : INTEGER := 3);
    port (
        x : in STD_LOGIC_VECTOR (n * 2 - 1 downto 0);
        c : out STD_LOGIC_VECTOR (n * 2 - 2 downto 0)
    );
end DIV3;

architecture Behavioral of DIV3 is

    component DIV3_COMP
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
               c : out STD_LOGIC_VECTOR (1 downto 0);
               r : out STD_LOGIC_VECTOR (1 downto 0));
    end component;
    
    signal r_int : STD_LOGIC_VECTOR (2 * n + 1 downto 0);
    signal c_int : STD_LOGIC_VECTOR (2 * n - 1 downto 0);

begin

    r_int (2 * n + 1 downto 2 * n) <= "00";

    GEN: for i in n - 1 downto 0 generate
        signal xi : STD_LOGIC_VECTOR (3 downto 0);
    begin
        xi <= r_int ((i + 1) * 2 + 1 downto (i + 1) * 2) & x (i * 2 + 1 downto i * 2);
        COMP_I: DIV3_COMP port map (
            x => xi,
            c => c_int (i * 2 + 1 downto i * 2),
            r => r_int (i * 2 + 1 downto i * 2)
        );
    end generate;

    c <= c_int (n * 2 - 2 downto 0);

end Behavioral;
