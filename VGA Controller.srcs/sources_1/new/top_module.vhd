library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TOPMOD is
    port (
        CLK100MHZ : in STD_LOGIC;
        sw : in STD_LOGIC_VECTOR(15 downto 0);
        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnL : in STD_LOGIC;
        btnC : in STD_LOGIC;
        PS2Clk : in STD_LOGIC;
        PS2Data : in STD_LOGIC;
        vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
        vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
        Hsync : out STD_LOGIC;
        Vsync : out STD_LOGIC;
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        dp : out STD_LOGIC;
        an : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TOPMOD;

architecture Structural of TOPMOD is

component IMGDISPLAY
    Port ( clock : in STD_LOGIC;
           btn_up : in STD_LOGIC;
           btn_down : in STD_LOGIC;
           btn_left : in STD_LOGIC;
           btn_right : in STD_LOGIC;
           btn_c : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR(15 downto 0);
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0);
           addrout : out STD_LOGIC_VECTOR (14 downto 0);
           snake_score : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component ssd
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component bin2bcd_12bit
    Port ( binIN : in  STD_LOGIC_VECTOR (11 downto 0);
           ones : out  STD_LOGIC_VECTOR (3 downto 0);
           tens : out  STD_LOGIC_VECTOR (3 downto 0);
           hundreds : out  STD_LOGIC_VECTOR (3 downto 0);
           thousands : out  STD_LOGIC_VECTOR (3 downto 0)
          );
end component;

component Keyboard
    Port ( clock : in STD_LOGIC;
           kb_clock : in STD_LOGIC;
           kb_data : in STD_LOGIC;
           w_pressed : out STD_LOGIC;
           a_pressed : out STD_LOGIC;
           s_pressed : out STD_LOGIC;
           d_pressed : out STD_LOGIC
    );
end component;

signal plm : STD_LOGIC_VECTOR(14 downto 0);
signal ri, gi, bi : STD_LOGIC_VECTOR (3 downto 0);
signal snake_score : STD_LOGIC_VECTOR (11 downto 0);
signal score_ones, score_tens, score_hundreds, score_thousands : STD_LOGIC_VECTOR (3 downto 0);
signal an_int : STD_LOGIC_VECTOR (3 downto 0);
signal w, a, s, d : STD_LOGIC;
signal up, left, down, right : STD_LOGIC;

begin

    BIN2BCD_I: bin2bcd_12bit port map (
        binIN => snake_score,
        ones => score_ones,
        tens => score_tens,
        hundreds => score_hundreds,
        thousands => score_thousands
    );

    SSD_I: ssd port map (
        clk => CLK100MHZ,
        digit0 => score_ones,
        digit1 => score_tens,
        digit2 => score_hundreds,
        digit3 => score_thousands,
        cat => seg,
        an => an_int
    );
    
    KB_I: Keyboard port map (
        clock => CLK100MHZ,
        kb_clock => PS2Clk,
        kb_data => PS2Data,
        w_pressed => w,
        a_pressed => a,
        s_pressed => s,
        d_pressed => d
    );

    C1 : IMGDISPLAY port map (clock => CLK100MHZ, switches => sw, btn_up => up, btn_down => down, btn_left => left, btn_right => right, btn_c => btnC, hs => Hsync, vs => Vsync, r => ri, g => gi, b => bi, addrout => plm, snake_score => snake_score);
    
    left <= a or btnL;
    right <= d or btnR;
    up <= w or btnU;
    down <= s or btnD;
    
    vgaRed <= ri;
    vgaGreen <= gi;
    vgaBlue <= bi;
    dp <= '1';
    an <= an_int when sw(1) = '1' else "1111";

end Structural;
