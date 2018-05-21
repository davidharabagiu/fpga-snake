library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyboardFilter is
	port (
	   clock : in STD_LOGIC;
	   i : in STD_LOGIC;
	   f: out STD_LOGIC
    );
end KeyboardFilter;

architecture FILTER of KeyboardFilter is
signal INT: STD_LOGIC_VECTOR(7 downto 0);
begin										   
	process(clock)
	begin 
	if rising_edge(clock) then 
		INT(7) <= i;					   
		INT(6 downto 0) <= INT(7 downto 1);
		if INT = x"00" then
			f <= '0';
		elsif INT = x"FF" then
			F <= '1';
		end if;	 
	end if;
	end process;
end FILTER;