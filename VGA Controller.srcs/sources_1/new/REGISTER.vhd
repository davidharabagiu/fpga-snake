library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REG is 
        Generic (n : integer := 10);
        Port ( clock : in STD_LOGIC;
               rst : in STD_LOGIC;
               ce : in STD_LOGIC;
               data_in : in STD_LOGIC_VECTOR( n-1 downto 0);
               data_out : out STD_LOGIC_VECTOR (n-1 downto 0)
               );
end entity;

architecture REGISTER_ARCH of REG is

begin
    
behav: process(clock, rst)
begin
     if rst = '1' then
        data_out <= (others => '0');
     elsif rising_edge(clock) then
         if ce = '1' then
            data_out <= data_in;
         end if;
     end if;
end process;
end REGISTER_ARCH;