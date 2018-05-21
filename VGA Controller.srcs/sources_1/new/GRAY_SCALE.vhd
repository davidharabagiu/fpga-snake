----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2018 12:27:55 AM
-- Design Name: 
-- Module Name: GRAY_SCALE - ARCH
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

entity GRAY_SCALE is
   Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
          pixel_out : out STD_LOGIC_VECTOR(11 downto 0) 
         );
end GRAY_SCALE;

architecture ARCH of GRAY_SCALE is

    signal pixel_in_aux : std_logic_vector(5 downto 0);
    signal pixel_out_aux : std_logic_vector(4 downto 0);
    component  DIV3 is
        generic (n : INTEGER := 3);
        port (
            x : in STD_LOGIC_VECTOR (n * 2 - 1 downto 0);
            c : out STD_LOGIC_VECTOR (n * 2 - 2 downto 0)
        );
    end component;
begin

    pixel_in_aux <= ("00" & pixel_in(3 downto 0)) + ("00"& pixel_in(7 downto 4)) + ("00" & pixel_in ( 11 downto 8)); 
    div: DIV3 port map ( x => pixel_in_aux, c => pixel_out_aux);
    pixel_out <= pixel_out_aux(3 downto 0) & pixel_out_aux(3 downto 0) & pixel_out_aux(3 downto 0);
    
end ARCH;
