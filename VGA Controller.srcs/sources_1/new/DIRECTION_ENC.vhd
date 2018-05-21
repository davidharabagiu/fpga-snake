----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2018 10:11:48 PM
-- Design Name: 
-- Module Name: DIRECTION_ENC - ARCH
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DIRECTION_ENC is
    Port ( right : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           left : in STD_LOGIC;
           dir : out STD_LOGIC_VECTOR (1 downto 0));
end DIRECTION_ENC;

architecture ARCH of DIRECTION_ENC is

begin
    dir <= "00" when right = '1' else
           "01" when left = '1' else
           "10" when up = '1' else
           "11" when down = '1' else
           "00";

end ARCH;
