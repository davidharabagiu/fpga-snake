library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SNAKESTACK is
    Generic ( max_length : NATURAL := 8 );
    Port ( clock : in STD_LOGIC;
           ce : in STD_LOGIC;
           push : in STD_LOGIC;
           clr : in STD_LOGIC;
           next_x : in STD_LOGIC_VECTOR (6 downto 0);
           next_y : in STD_LOGIC_VECTOR (5 downto 0);
           cmp_x : in STD_LOGIC_VECTOR (6 downto 0);
           cmp_y : in STD_LOGIC_VECTOR (5 downto 0);
           head_x : out STD_LOGIC_VECTOR (6 downto 0);
           head_y : out STD_LOGIC_VECTOR (5 downto 0);
           eq : out STD_LOGIC;
           ate_food : out STD_LOGIC;
           colision : out STD_LOGIC;
           score : out STD_LOGIC_VECTOR (11 downto 0));
end SNAKESTACK;

architecture Behavioral of SNAKESTACK is

component COMP
    generic (n : INTEGER := 8);
    port (
        a : in STD_LOGIC_VECTOR (n - 1 downto 0);
        b : in STD_LOGIC_VECTOR (n - 1 downto 0);
        y : out STD_LOGIC
    );
end component;

type MEM is ARRAY (0 to max_length - 1) of STD_LOGIC_VECTOR (next_x'length + next_y'length  downto 0);
signal segments : MEM := (
    0 => ("0000100" & "001010" & "1"),
    1 => ("0000011" & "001010" & "1"),
    2 => ("0000010" & "001010" & "1"),
    others => (others => '0')
);
signal next_segments : MEM := (others => (others => '0'));
signal head : STD_LOGIC_VECTOR (head_x'length + head_y'length downto 0);
signal colision_i : STD_LOGIC := '0';
signal comp_pixel_x : STD_LOGIC_VECTOR (max_length - 1 downto 0);
signal comp_pixel_y : STD_LOGIC_VECTOR (max_length - 1 downto 0);
signal comp_head_x : STD_LOGIC_VECTOR (max_length - 2 downto 0);
signal comp_head_y : STD_LOGIC_VECTOR (max_length - 2 downto 0);
signal segments_on : STD_LOGIC_VECTOR (max_length - 1 downto 0);
signal head_colision : STD_LOGIC_VECTOR (max_length - 2 downto 0);
signal score_count : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');

begin

    shift: process (clock, clr)
    begin
        if clr = '1' then
            segments <= (
                0 => ("0000100" & "001010" & "1"),
                1 => ("0000011" & "001010" & "1"),
                2 => ("0000010" & "001010" & "1"),
                others => (others => '0')
            );
            score_count <= x"000";
        elsif rising_edge (clock) then
            if ce = '1' then
                if push = '1' then
                    score_count <= score_count + 1;
                end if;
                for i in 0 to max_length - 1 loop
                    segments (i) <= next_segments (i);
                end loop;
            end if;
        end if;
    end process shift;
    
    next_segments (0) <= next_x & next_y & "1";
    score <= score_count;
    
    comp_next_segments: process (segments, push)
    begin
        for i in 1 to max_length - 1 loop
            if (push = '1' and segments (i - 1) (0) = '1') or segments (i) (0) = '1' then
                next_segments (i) <= segments (i - 1);
            else
                next_segments (i) <= (others => '0');
            end if;
        end loop;
    end process comp_next_segments;
    
    d_push : process (clock)
    begin
        if rising_edge (clock) then
            if ce = '1' then
                ate_food <= push;
            end if;
        end if;
    end process d_push;

    colision_i <= '0' when head_colision = (head_colision'range => '0') else '1';
    
    game_over: process(segments, comp_head_x, comp_head_y)
    begin
        for i in 1 to max_length - 1 loop
            head_colision (i - 1) <= (comp_head_x (i - 1) and comp_head_y (i - 1) and segments (i) (0));
        end loop;
    end process game_over;
    
    head <= segments(0);
    head_x <= head(head'high downto head'high - head_x'length + 1);
    head_y <= head(head_y'length downto 1);
    colision <= colision_i;
    
    gen_comp_current_pos: for i in 0 to max_length - 1 generate
        COMP_II_CX : COMP generic map (head_x'length) port map (a => segments (i) (head'high downto head'high - head_x'length + 1), b => cmp_x, y => comp_pixel_x (i));
        COMP_II_CY : COMP generic map (head_y'length) port map (a => segments (i) (head_y'length downto 1), b => cmp_y, y => comp_pixel_y (i));
    end generate gen_comp_current_pos;
    
    gen_comp_head_pos: for i in 1 to max_length - 1 generate
        COMP_II_HX : COMP generic map (head_x'length) port map (a => segments (i) (head'high downto head'high - head_x'length + 1), b => segments (0) (head'high downto head'high - head_x'length + 1), y => comp_head_x (i - 1));
        COMP_II_HY : COMP generic map (head_y'length) port map (a => segments (i) (head_y'length downto 1), b => segments (0) (head_y'length downto 1), y => comp_head_y (i - 1));
    end generate gen_comp_head_pos;
    
    eq <= '0' when segments_on = (segments_on'range => '0') else '1';
    
    check_snake_pixel: process (segments, comp_pixel_x, comp_pixel_y)
    begin
        for i in 0 to max_length - 1 loop
            segments_on (i) <= comp_pixel_x (i) and comp_pixel_y (i) and segments (i) (0);
        end loop;
    end process check_snake_pixel;

end Behavioral;
