library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HCNT is
    Port ( clock : in STD_LOGIC;
           hs : out STD_LOGIC;
           h : out STD_LOGIC_VECTOR (9 downto 0);
           blank : out STD_LOGIC;
           vc_ce : out STD_LOGIC
    );
end HCNT;

architecture Behavioral of HCNT is

signal counter : STD_LOGIC_VECTOR(9 downto 0);

constant HBLANK : NATURAL := 93;
constant HFRONT : NATURAL := 45;
constant HDISPLAY : NATURAL := 640;
constant HBACK : NATURAL := 22;

begin

    count: process (clock)
    begin
        if rising_edge (clock) then
            if counter < HBLANK + HFRONT + HDISPLAY + HBACK - 1 then
                counter <= counter + 1;
                
                if counter = HBLANK + HFRONT + HDISPLAY + HBACK - 2 then
                    vc_ce <= '1';
                else
                    vc_ce <= '0';
                end if;
            else
                counter <= (others => '0');
                vc_ce <= '0';
            end if;
        end if;
    end process count;
    
    h <= counter;
    hs <= '0' when ((counter >= HDISPLAY + HBACK) and (counter < HDISPLAY + HBACK + HBLANK)) else '1';
    blank <= '0' when counter < HDISPLAY else '1';

end Behavioral;
