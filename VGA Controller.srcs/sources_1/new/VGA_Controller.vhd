library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGACTL is
    Port ( pixel_clock : in STD_LOGIC;
           h : out STD_LOGIC_VECTOR (9 downto 0);
           v : out STD_LOGIC_VECTOR (9 downto 0);
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           blank : out STD_LOGIC);
end VGACTL;

architecture Structural of VGACTL is

component HCNT
    Port ( clock : in STD_LOGIC;
           hs : out STD_LOGIC;
           h : out STD_LOGIC_VECTOR (9 downto 0);
           blank : out STD_LOGIC;
           vc_ce : out STD_LOGIC);
end component;

component VCNT
    Port ( clock : in STD_LOGIC;
           clock_enable : in STD_LOGIC;
           vs : out STD_LOGIC;
           v : out STD_LOGIC_VECTOR (9 downto 0);
           blank : out STD_LOGIC);
end component;

signal hs_int : STD_LOGIC;
signal h_int : STD_LOGIC_VECTOR(9 downto 0);
signal vc_ce : STD_LOGIC;
signal vs_int : STD_LOGIC;
signal hblank, vblank : STD_LOGIC;

begin

    HC: HCNT port map (clock => pixel_clock, hs => hs_int, h => h_int, vc_ce => vc_ce, blank => hblank);
    VC: VCNT port map (clock => pixel_clock, clock_enable => vc_ce, vs => vs_int, v => v, blank => vblank);
    
    vs <= vs_int;
    hs <= hs_int;
    h <= h_int;
    
    blank <= hblank or vblank;

end Structural;
