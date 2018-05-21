----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2018 11:05:20 PM
-- Design Name: 
-- Module Name: MPG - ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
    Port ( button : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture ARCH of MPG is

signal D1, D2,D3, EN : STD_LOGIC;
signal counter : STD_LOGIC_VECTOR(15 downto 0);

begin

counter <= counter + 1 when rising_edge(clock);
en <= '1' when counter = x"FFFF" else '0';

process(clock)
    begin
        if rising_edge(clock) then
           if en = '1' then
                D1 <= button;
           end if;   
        end if;
end process;
D2 <= D1 when rising_edge(clock);
D3 <= D2 when rising_edge(clock);
enable <= D2 and not(D3);

end ARCH;
