library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssd is
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end ssd;

architecture Behavioral of ssd is

signal counter: STD_LOGIC_VECTOR(15 downto 0);
signal digit: STD_LOGIC_VECTOR(3 downto 0);

begin

    counter <= counter + 1 when rising_edge(clk);
    
    process (counter, digit0, digit1, digit2, digit3)
    begin
        case counter(15 downto 14) is
            when "00" => digit <= digit0; an <= "1110";
            when "01" => digit <= digit1; an <= "1101";
            when "10" => digit <= digit2; an <= "1011";
            when "11" => digit <= digit3; an <= "0111";
        end case;
    end process;
    
    with digit select
       cat<= "1111001" when "0001",   --1
             "0100100" when "0010",   --2
             "0110000" when "0011",   --3
             "0011001" when "0100",   --4
             "0010010" when "0101",   --5
             "0000010" when "0110",   --6
             "1111000" when "0111",   --7
             "0000000" when "1000",   --8
             "0010000" when "1001",   --9
             "0001000" when "1010",   --A
             "0000011" when "1011",   --b
             "1000110" when "1100",   --C
             "0100001" when "1101",   --d
             "0000110" when "1110",   --E
             "0001110" when "1111",   --F
             "1000000" when others;   --0

end Behavioral;
