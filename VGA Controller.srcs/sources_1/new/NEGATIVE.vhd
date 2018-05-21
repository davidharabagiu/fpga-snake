----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2018 12:11:35 AM
-- Design Name: 
-- Module Name: NEGATIVE - Behavioral
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

entity NEGATIVE is
    Port ( pixel_in : in STD_LOGIC_VECTOR (11 downto 0);
           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end NEGATIVE;

architecture Behavioral of NEGATIVE is
signal red, blue, green : STD_LOGIC_VECTOR(3 downto 0);

begin
    red <= "1111" - pixel_in(11 downto 8);
    green <= "1111" -  pixel_in(7 downto 4);
    blue <= "1111" -  pixel_in(3 downto 0);
    pixel_out <= red & green & blue;
end Behavioral;
