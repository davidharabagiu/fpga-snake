library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FRDIV is
	port (
		clock_in : in STD_LOGIC;
		clock_out : out STD_LOGIC
	);
end FRDIV;

architecture Behavioral of FRDIV is
	
signal counter : STD_LOGIC_VECTOR(1 downto 0);

begin

	counter <= counter + 1 when rising_edge(clock_in);
	clock_out <= counter(1);

end Behavioral;
