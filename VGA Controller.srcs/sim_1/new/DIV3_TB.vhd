library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity DIV3_TB is
--  Port ( );
end DIV3_TB;

architecture Behavioral of DIV3_TB is

component DIV3
    generic (n : INTEGER := 3);
    port (
        x : in STD_LOGIC_VECTOR (n * 2 - 1 downto 0);
        c : out STD_LOGIC_VECTOR (n * 2 - 2 downto 0)
    );
end component;

signal x : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal c : STD_LOGIC_VECTOR (4 downto 0);

begin

    DUT: DIV3 port map (x => x, c => c);
    
    TEST: process
        variable expectedRes : STD_LOGIC_VECTOR (4 downto 0);
        variable nrErrors : INTEGER := 0;
    begin
        for i in 0 to 63 loop
            x <= conv_std_logic_vector (i, 6);
            expectedRes := conv_std_logic_vector (i / 3, 5);
            wait for 10ns;
            if conv_integer (c) /= expectedRes then
                report "Expected (" & INTEGER'image (i / 3) & ") /= " & INTEGER'image (conv_integer (c))
                    severity ERROR;
                nrErrors := nrErrors + 1;
            end if;
        end loop;
        report "Number of errors: " & INTEGER'image (nrErrors);
        wait;
    end process TEST;

end Behavioral;
