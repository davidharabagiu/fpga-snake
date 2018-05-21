library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SNAKE is
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
           score : out STD_LOGIC_VECTOR (11 downto 0)
           );
end SNAKE;

architecture ARCH of SNAKE is

component SNAKESTACK is
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
end component;

component REG is
    Generic (n : integer := 10);
    Port ( clock : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR( n-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (n-1 downto 0)
           );
end component;

component DIRECTION_ENC is
    Port ( right : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           left : in STD_LOGIC;
           dir : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component RNG is
    Port ( clock : in STD_LOGIC;
           ce : in STD_LOGIC;
           pos: out STD_LOGIC_VECTOR (12 downto 0));
end component;

signal game_over : STD_LOGIC := '0';
signal stack_ce : STD_LOGIC;
signal next_x, head_x, delta_x, next_x_r : STD_LOGIC_VECTOR (x'high downto 0);
signal next_y, head_y, delta_y, next_y_r : STD_LOGIC_VECTOR (y'high downto 0);
signal collision, push, ate_food : STD_LOGIC;
signal snake_pixel_on : STD_LOGIC;

signal new_direction, direction, last_direction : STD_LOGIC_VECTOR (1 downto 0);
signal dir_reg_ce, dir_reg2_ce : STD_LOGIC;

signal new_food_pos, food_pos : STD_LOGIC_VECTOR (12 downto 0);
signal food_reg_ce : STD_LOGIC;
signal food_collision : STD_LOGIC;
signal food_pixel_on : STD_LOGIC;

begin

    SS_I: SNAKESTACK generic map (256) port map (
        clock => clock_100MHZ,
        ce => stack_ce,
        push => push,
        clr => clr,
        next_x => next_x_r,
        next_y => next_y_r,
        cmp_x => x,
        cmp_y => y,
        head_x => head_x,
        head_y => head_y,
        eq => snake_pixel_on,
        ate_food => ate_food,
        colision => collision,
        score => score
    );
    
    DE_I: DIRECTION_ENC port map (
        right => right,
        left => left,
        up => up,
        down => down,
        dir => new_direction
    );
    
    DR_I: REG generic map (2) port map (
        clock => clock_100MHZ,
        rst => clr,
        ce => dir_reg_ce,
        data_in => new_direction,
        data_out => direction
    );
    
    DR2_I: REG generic map (2) port map (
        clock => clock_100MHZ,
        rst => clr,
        ce => dir_reg2_ce,
        data_in => direction,
        data_out => last_direction
    );
    
    FR_I: REG generic map (new_food_pos'length) port map (
        clock => clock_100MHZ,
        rst => '0',
        ce => food_reg_ce,
        data_in => new_food_pos,
        data_out => food_pos
    );
    
    RNG_I: RNG port map (
        clock => clock_100MHZ,
        ce => '1',
        pos => new_food_pos
    );
    
    stack_ce <= clock_2HZ and ce and (not game_over);
    next_x <= head_x + delta_x;
    next_y <= head_y + delta_y;
    dir_reg_ce <= (up or down or left or right) and ce and (new_direction(1) xor last_direction(1)) and (not game_over);
    dir_reg2_ce <= ce and clock_2HZ;
    food_reg_ce <= clr or food_collision;
    food_collision <= '1' when (head_x & head_y) = food_pos else '0';
    food_pixel_on <= '1' when (x & y) = food_pos else '0';
    pixel_on <= snake_pixel_on or food_pixel_on;
    
    next_x_r <= "1001111" when next_x = (next_x'range => '1') else (others => '0') when next_x >= 80 else next_x;
    next_y_r <= "111011" when next_y = (next_y'range => '1') else (others => '0') when next_y >= 60 else next_y;
    
    sr: process (clock_100MHZ, clr)
    -- s = food_collision
    -- r = ate_food
    -- q = push
    begin
        if clr = '1' then
            push <= '0';
        elsif rising_edge (clock_100MHZ) then
            if ce = '1' then
                if food_collision = '1' then
                    push <= '1';
                elsif ate_food = '1' then
                    push <= '0';
                end if;
            end if;
        end if;
    end process sr;
    
    sr2: process (clock_100MHZ)
    begin
        if rising_edge (clock_100MHZ) then
            if clr = '1' then
                game_over <= '0';
            elsif collision = '1' then
                game_over <= '1';
            end if;
        end if;
    end process sr2;
    
    delta_x <= ((delta_x'high downto 1 => '0') & "1") when direction = "00" else
        (delta_x'range => '1') when direction = "01" else
        (delta_x'range => '0');
        
    delta_y <= ((delta_y'high downto 1 => '0') & "1") when direction = "11" else
        (delta_y'range => '1') when direction = "10" else
        (delta_y'range => '0');

end ARCH;
