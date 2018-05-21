library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RNG is
    Port ( clock : in STD_LOGIC;
           ce : in STD_LOGIC;
           pos: out STD_LOGIC_VECTOR (12 downto 0));
end RNG;

architecture Behavioral of RNG is

signal q_int : STD_LOGIC_VECTOR (31 downto 0) := x"12345678";
signal x1, x2, x3 : STD_LOGIC_VECTOR (31 downto 0);
signal x_raw, x : STD_LOGIC_VECTOR (6 downto 0);
signal y_raw, y : STD_LOGIC_VECTOR (5 downto 0);

begin

    x1 <= q_int xor (q_int(18 downto 0) & "0000000000000");
    x2 <= x1 xor ("00000000000000000" & x1(31 downto 17));
    x3 <= x2 xor (x2(26 downto 0) & "00000");

    process (clock)
    begin
        if rising_edge (clock) then
            if ce = '1' then
                q_int <= x3;
            end if;
        end if;
    end process;
    
    x_raw <= q_int (6 downto 0);
    y_raw <= q_int (12 downto 7);
    
    x <= x_raw - 80 when x_raw >= 80 else x_raw;
    y <= y_raw - 60 when y_raw >= 60 else y_raw;
    
    pos <= x & y;

end Behavioral;
