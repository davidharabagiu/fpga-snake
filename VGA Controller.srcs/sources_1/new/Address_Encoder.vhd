library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ADDRENCODE is
    Port ( h : in STD_LOGIC_VECTOR (9 downto 0);
           v : in STD_LOGIC_VECTOR (9 downto 0);
           h_div : out STD_LOGIC_VECTOR (7 downto 0);
           v_div : out STD_LOGIC_VECTOR (6 downto 0);
           addr : out STD_LOGIC_VECTOR (14 downto 0));
end ADDRENCODE;

architecture Behavioral of ADDRENCODE is

signal h_div_int : STD_LOGIC_VECTOR (7 downto 0);
signal v_div_int : STD_LOGIC_VECTOR (6 downto 0);

begin

    h_div_int <= h (9 downto 2);
    v_div_int <= v (8 downto 2);
    
    addr <= ("0" & v_div_int & "0000000") + ("000" & v_div_int & "00000") + ("0000000" & h_div_int);

    h_div <= h_div_int;
    v_div <= v_div_int;

end Behavioral;
