library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VCNT is
    Port ( clock : in STD_LOGIC;
           clock_enable : in STD_LOGIC;
           vs : out STD_LOGIC;
           v : out STD_LOGIC_VECTOR (9 downto 0);
           blank : out STD_LOGIC);
end VCNT;

architecture Behavioral of VCNT is

signal counter : STD_LOGIC_VECTOR (9 downto 0);

constant VBLANK : NATURAL := 2;
constant VFRONT : NATURAL := 32;
constant VDISPLAY : NATURAL := 480;
constant VBACK : NATURAL := 11;

begin

    count: process (clock)
    begin
        if rising_edge (clock) then
            if clock_enable = '1' then
                if counter < VBLANK + VFRONT + VDISPLAY + VBACK - 1 then
                    counter <= counter + 1;
                else
                    counter <= (others => '0');
                end if;
            end if;
        end if;
    end process count;
    
    v <= counter;
    vs <= '0' when ((counter >= VDISPLAY + VBACK) and (counter < VDISPLAY + VBACK + VBLANK)) else '1';
    blank <= '0' when counter < VDISPLAY else '1';

end Behavioral;
