library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyboard is
    Port ( clock : in STD_LOGIC;
           kb_clock : in STD_LOGIC;
           kb_data : in STD_LOGIC;
           w_pressed : out STD_LOGIC;
           a_pressed : out STD_LOGIC;
           s_pressed : out STD_LOGIC;
           d_pressed : out STD_LOGIC
    );
end Keyboard;

architecture Behavioral of Keyboard is

component KeyboardFilter
	port (
	   clock : in STD_LOGIC;
	   i : in STD_LOGIC;
	   f: out STD_LOGIC
    );
end component;

signal counter : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); -- counter for delay
signal counter2 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0'); -- counter for delay2
signal kb_clock_f, kb_data_f : STD_LOGIC; -- filtered keyboard signals
signal key_read, key_read_d, key_read_d2 : STD_LOGIC; -- 1 when a key was received
signal kb_recv : STD_LOGIC_VECTOR (10 downto 0); -- received data from keyboard
signal w, a, s, d : STD_LOGIC := '0'; -- key states
signal break_code, break_code_d : STD_LOGIC := '0'; -- '1' if receiving a break code
signal key_code : STD_LOGIC_VECTOR (7 downto 0); -- current key code; 

begin

    w_pressed <= w;
    a_pressed <= a;
    s_pressed <= s;
    d_pressed <= d;

    FLT_CLOCK: KeyboardFilter port map (
        clock => clock,
        i => kb_clock,
        f => kb_clock_f
    );
    
    FLT_DATA: KeyboardFilter port map (
        clock => clock,
        i => kb_data,
        f => kb_data_f
    );

    counter <= counter + 1 when rising_edge (clock);
    counter2 <= counter2 + 1 when rising_edge (clock);
    key_read <= not kb_recv (0);
    
    read_key: process (clock)
    begin
        if key_read_d = '1' then
            kb_recv <= (kb_recv'range => '1');
        elsif falling_edge (kb_clock_f) then
            kb_recv <= kb_data_f & kb_recv(10 downto 1);
        end if;
    end process read_key;
    
    delay_key_read: process (clock)
    begin
        if rising_edge (clock) then
            if counter = (counter'range => '0') then
                key_read_d <= key_read;
            end if;
        end if;
    end process delay_key_read;
    
    output_key: process (clock)
    begin
        if rising_edge (clock) then
            if key_read = '1' then
                key_code <= kb_recv (8 downto 1);
            end if;
        end if;
    end process;
    
    check_break_code: process (clock)
    begin
        if rising_edge (clock) then
            if key_read_d2 = '1' then
                if key_code = x"F0" then
                    break_code <= '1';
                else
                    break_code <= '0';
                end if;
            end if;
        end if;
    end process check_break_code;
    
    key_read_d2 <= key_read when rising_edge (clock);
    
    delay_break_code: process (clock)
    begin
        if rising_edge (clock) then
            if counter2 = (counter2'range => '0') then
                break_code_d <= break_code;
            end if;
        end if;
    end process delay_break_code;
    
    update_key_states: process (clock)
    begin
        if rising_edge (clock) then
            if key_read_d2 = '1' then
                if key_code = x"1D" then
                    w <= not break_code_d;
                end if;
                if key_code = x"1C" then
                    a <= not break_code_d;
                end if;
                if key_code = x"1B" then
                    s <= not break_code_d;
                end if;
                if key_code = x"23" then
                    d <= not break_code_d;
                end if;
            end if;
        end if;
    end process update_key_states;
    
end Behavioral;
