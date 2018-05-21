library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IMGDISPLAY is
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
           snake_score : out STD_LOGIC_VECTOR (11 downto 0)
       );
         
end IMGDISPLAY;

architecture Structural of IMGDISPLAY is

component VGACTL
    Port ( pixel_clock : in STD_LOGIC;
           h : out STD_LOGIC_VECTOR (9 downto 0);
           v : out STD_LOGIC_VECTOR (9 downto 0);
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           blank : out STD_LOGIC);
end component;

component FRDIV
    port (
		clock_in : in STD_LOGIC;
		clock_out : out STD_LOGIC
	);
end component;

component ADDRENCODE
    Port ( h : in STD_LOGIC_VECTOR (9 downto 0);
           v : in STD_LOGIC_VECTOR (9 downto 0);
           h_div : out STD_LOGIC_VECTOR (7 downto 0);
           v_div : out STD_LOGIC_VECTOR (6 downto 0);
           addr : out STD_LOGIC_VECTOR (14 downto 0));
end component;

component IMG1
    port (
		clock : in STD_LOGIC;
		addr : in INTEGER;
		pixel_data : out STD_LOGIC_VECTOR(11 downto 0)
	);
end component;

component IMG2
    port (
		clock : in STD_LOGIC;
		addr : in INTEGER;
		pixel_data : out STD_LOGIC_VECTOR(11 downto 0)
	);
end component;

component SNAKE
    Port ( clock_100MHZ : in STD_LOGIC;
           clock_2HZ : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (6 downto 0);
           y : in STD_LOGIC_VECTOR (5 downto 0);
           ce : in STD_LOGIC;
           clr : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           right : in STD_LOGIC;
           left : in STD_LOGIC;
           pixel_on : out STD_LOGIC;
           score : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component MPG
    Port ( button : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component FREQUENCE_DIVIDER2 is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

component NEGATIVE is
    Port ( pixel_in : in STD_LOGIC_VECTOR (11 downto 0);
           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component CONTRAST_PLUS is
    Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
         pixel_out : out STD_LOGIC_VECTOR(11 downto 0));
end component;
component CONTRAST_MINUS is
    Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
         pixel_out : out STD_LOGIC_VECTOR(11 downto 0));
end component;
component GRAY_SCALE is
    Port ( pixel_in : in STD_LOGIC_VECTOR(11 downto 0);
         pixel_out : out STD_LOGIC_VECTOR(11 downto 0));
end component;
signal snake_rst, snake_ce : STD_LOGIC;
signal pixel_clock : STD_LOGIC;
signal h : STD_LOGIC_VECTOR (9 downto 0);
signal v : STD_LOGIC_VECTOR (9 downto 0);
signal h_div : STD_LOGIC_VECTOR (7 downto 0);
signal v_div : STD_LOGIC_VECTOR (6 downto 0);
signal blank : STD_LOGIC;
signal addr : STD_LOGIC_VECTOR (14 downto 0);
signal imgdata_snake, imgdata1, imgdata2 : STD_LOGIC_VECTOR (11 downto 0);
signal imgdata, imgdata_neg, imgdata_cm, imgdata_gr, imgdata_cp : STD_LOGIC_VECTOR (11 downto 0);
signal address_int : INTEGER;
signal btn_right_d, btn_up_d, btn_left_d, btn_down_d, btn_snake_reset_d : STD_LOGIC := '0';
signal clock_2HZ : STD_LOGIC;
signal snake_pixel_on : STD_LOGIC;
signal r_in, g_in, b_in : STD_LOGIC_VECTOR(3 downto 0);

signal r2, g2, b2, r3, g3, b3, r4, g4, b4 : STD_LOGIC_VECTOR (3 downto 0);
signal hs2, vs2 : STD_LOGIC;

begin

    snake_ce <= switches(1);
    snake_rst <= (not switches(1)) or btn_snake_reset_d;

    MPGI_RIGHT: MPG port map (clock => clock, button => btn_right, enable => btn_right_d);
    MPGI_LEFT: MPG port map (clock => clock, button => btn_left, enable => btn_left_d);
    MPGI_UP: MPG port map (clock => clock, button => btn_up, enable => btn_up_d);
    MPGI_DOWN: MPG port map (clock => clock, button => btn_down, enable => btn_down_d);
    MPGI_C: MPG port map (clock => clock, button => btn_c, enable => btn_snake_reset_d);
    SNAKEI: SNAKE port map (
                            clock_100MHZ => clock,
                            clock_2HZ => clock_2HZ,
                            right => btn_right_d,
                            left => btn_left_d,
                            up => btn_up_d,
                            down => btn_down_d,
                            x => h_div(7 downto 1),
                            y => v_div(6 downto 1),
                            ce => snake_ce,
                            clr => snake_rst,
                            pixel_on => snake_pixel_on,
                            score => snake_score
                       );
     FREQ_DIVIDEI: FREQUENCE_DIVIDER2 port map (
                            clk_in => clock,
                            clk_out => clock_2HZ);
    address_int <= to_integer(unsigned(addr));

    CLKDIV: FRDIV port map (clock_in => clock, clock_out => pixel_clock);
    VGA: VGACTL port map (pixel_clock => pixel_clock, h => h, v => v, hs => hs2, vs => vs2, blank => blank);
    ADDRE: ADDRENCODE port map (h => h, v => v, h_div => h_div, v_div => v_div, addr => addr);
    IMGI1: IMG1 port map (clock => clock, addr => address_int, pixel_data => imgdata1);
    IMGI2: IMG2 port map (clock => clock, addr => address_int, pixel_data => imgdata2);
    
    --r_in <= (others => snake_pixel_on);
    --g_in <= (others => snake_pixel_on);
    --b_in <= (others => snake_pixel_on);
    --color_in <= r_in & g_in & b_in;
    
   -- imgdata1 <= "111100000000";
    -- imgdata2 <= "000011110000";
    
    imgdata_snake <= (others => snake_pixel_on);
    imgdata <= imgdata1 when switches(1 downto 0) = "00"
        else imgdata2 when switches(1 downto 0) = "01"
        else imgdata_snake;
    
    NEG_I : NEGATIVE port map (pixel_in => imgdata, pixel_out => imgdata_neg);
    CPL_I : CONTRAST_PLUS port map (pixel_in => imgdata, pixel_out => imgdata_cp);
    GRAY_I : GRAY_SCALE port map (pixel_in => imgdata, pixel_out => imgdata_gr);
    CMN_I : CONTRAST_MINUS port map (pixel_in => imgdata, pixel_out => imgdata_cm);
    
    r2 <= imgdata_cp (11 downto 8) when switches(15 downto 13) = "100"
                                else  imgdata_neg (11 downto 8)  when switches(15 downto 13) = "001"  
                                else  imgdata_gr (11 downto 8)  when switches(15 downto 13) = "010"   
                                else  imgdata_cm (11 downto 8)  when switches(15 downto 13) = "011"                                                                                           
                                else  imgdata (11 downto 8) ;
    g2 <= imgdata_cp (7 downto 4) when switches(15 downto 13) = "100" 
                                else imgdata_neg (7 downto 4) when switches(15 downto 13) = "001"
                                else imgdata_gr (7 downto 4) when switches(15 downto 13) = "010"
                                else imgdata_cm (7 downto 4) when switches(15 downto 13) = "011"                             
                                else  imgdata (7 downto 4)  ;
    b2 <= imgdata_cp (3 downto 0)  when switches(15 downto 13) = "100" 
                                else imgdata_neg (3 downto 0)  when switches(15 downto 13) = "001"
                                else imgdata_gr (3 downto 0)  when switches(15 downto 13) = "010"
                                else imgdata_cm (3 downto 0)  when switches(15 downto 13) = "011"
                                else  imgdata (3 downto 0)  ;
    
    r3 <= "0000" when switches(12)= '1' else r2;
    g3 <= "0000" when switches(11)= '1' else g2;
    b3 <= "0000" when switches(10)= '1' else b2;

    r4 <= r3 when blank = '0' else "0000";
    g4 <= g3 when blank = '0' else "0000";
    b4 <= b3 when blank = '0' else "0000";
    
    -- synchronize vga signals
    r <= r4 when rising_edge (pixel_clock);
    g <= g4 when rising_edge (pixel_clock);
    b <= b4 when rising_edge (pixel_clock);
    hs <= hs2 when rising_edge (pixel_clock);
    vs <= vs2 when rising_edge (pixel_clock);
    
    addrout <= addr;

end Structural;
