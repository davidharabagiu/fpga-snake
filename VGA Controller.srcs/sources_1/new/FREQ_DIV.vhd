----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2018 12:03:08 AM
-- Design Name: 
-- Module Name: FREQUENCE_DIVIDER2 - ARCH
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

entity FREQUENCE_DIVIDER2 is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end FREQUENCE_DIVIDER2;

architecture ARCH of FREQUENCE_DIVIDER2 is
signal count : STD_LOGIC_VECTOR(24 downto 0);
begin

count <= count + 1 when rising_edge(clk_in);
clk_out <= '1' when ((count = 0) or (count = 11072962) or (count = 22145925)) else '0';

end ARCH;
