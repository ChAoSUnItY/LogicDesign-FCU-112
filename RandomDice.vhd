library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RandomDice is
	port 
	(	
		CLK_50M, CLK, RESETN : in std_logic;
		GPIO_0 : out std_logic_vector(21 downto 9);         -- connect to back-side pin16~pin9 of 8x8 led
		GPIO_1 : out std_logic_vector(21 downto 9)          -- connect to front-side pin1~pin8 of 8x8 led
    );
end RandomDice;

architecture a of RandomDice is
-- Types
type led8x8 is array(1 to 8) of std_logic_vector(1 to 8);
type led8x8states is array(0 to 6) of led8x8;
-- Components
component ClockGen is
	generic(
        DIV : integer := 50_000_000
    );
	port 
	(
        CLK_IN : in std_logic;
        CLK_OUT : out std_logic
    ); 
end component;
-- Constants
constant led_clr : led8x8 := (1 => "00000000",         	   		-- . . . . . . . .
                              2 => "00000000",					-- . . . . . . . .
                              3 => "00000000",					-- . . . . . . . .
                              4 => "00000000",					-- . . . . . . . .
                              5 => "00000000",					-- . . . . . . . .
                              6 => "00000000",					-- . . . . . . . .
                              7 => "00000000",					-- . . . . . . . .
                              8 => "00000000");					-- . . . . . . . .

constant led_one : led8x8 := (1 => "00000000",         	   		-- . . . . . . . .
                              2 => "00000000",					-- . . . . . . . .
                              3 => "00000000",					-- . . . . . . . .
                              4 => "00011000",					-- . . . * * . . .
                              5 => "00011000",					-- . . . * * . . .
                              6 => "00000000",					-- . . . . . . . .
                              7 => "00000000",					-- . . . . . . . .
                              8 => "00000000");					-- . . . . . . . .

constant led_two : led8x8 := (1 => "00000000",         	   		-- . . . . . . . .
                              2 => "01100000",					-- . * * . . . . .
                              3 => "01100000",					-- . * * . . . . .
                              4 => "00000000",					-- . . . . . . . .
                              5 => "00000000",					-- . . . . . . . .
                              6 => "00000110",					-- . . . . . * * .
                              7 => "00000110",					-- . . . . . * * .
                              8 => "00000000");					-- . . . . . . . .

constant led_thr : led8x8 := (1 => "00000000",         	   		-- . . . . . . . .
                              2 => "01100000",					-- . * * . . . . .
                              3 => "01100000",					-- . * * . . . . .
                              4 => "00011000",					-- . . . * * . . .
                              5 => "00011000",					-- . . . * * . . .
                              6 => "00000110",					-- . . . . . * * .
                              7 => "00000110",					-- . . . . . * * .
                              8 => "00000000");					-- . . . . . . . .

constant led_fou : led8x8 := (1 => "01100110",         	   		-- . * * . . * * .
                              2 => "01100110",					-- . * * . . * * .
                              3 => "00000000",					-- . . . . . . . .
                              4 => "00000000",					-- . . . . . . . .
                              5 => "00000000",					-- . . . . . . . .
                              6 => "00000000",					-- . . . . . . . .
                              7 => "01100110",					-- . * * . . * * .
                              8 => "01100110");					-- . * * . . * * .

constant led_fiv : led8x8 := (1 => "01100110",         	   		-- . * * . . * * .
                              2 => "01100110",					-- . * * . . * * .
                              3 => "00000000",					-- . . . . . . . .
                              4 => "00011000",					-- . . . * * . . .
                              5 => "00011000",					-- . . . * * . . .
                              6 => "00000000",					-- . . . . . . . .
                              7 => "01100110",					-- . * * . . * * .
                              8 => "01100110");					-- . * * . . * * .

constant led_six : led8x8 := (1 => "01100110",         	   		-- . * * . . * * .
                              2 => "01100110",					-- . * * . . * * .
                              3 => "00000000",					-- . . . . . . . .
                              4 => "01100110",					-- . * * . . * * .
                              5 => "01100110",					-- . * * . . * * .
                              6 => "00000000",					-- . . . . . . . .
                              7 => "01100110",					-- . * * . . * * .
                              8 => "01100110");					-- . * * . . * * .

constant led_states : led8x8states := (0 => led_clr, 
                                       1 => led_one, 
                                       2 => led_two, 
                                       3 => led_thr, 
                                       4 => led_fou, 
                                       5 => led_fiv, 
                                       6 => led_six);
-- Signals
signal scan_clk : std_logic := '0'; -- 1k hz
signal scanline : integer range 0 to 7 := 0;
signal num : integer range 0 to 6 := 0;
signal row, col: std_logic_vector(1 to 8) := (others => '0');
begin
    DIV_50M_1K: ClockGen generic map(div => 50_000) port map(CLK_50M, scan_clk);

    process (CLK, RESETN)
        variable seed : integer := 0;
    begin
        if RESETN = '0' then
            num <= 0;
        elsif CLK'event and CLK = '1' then
            seed := (seed * 8121 + 28411) mod 134456;
            num <= seed mod 6 + 1;
        end if;
    end process;

    process (scan_clk, RESETN)
    begin
        if RESETN = '0' then
            scanline <= 0;
        elsif scan_clk'event and scan_clk = '1' then
            if scanline = 7 then 
                scanline <= 0;
			else
                scanline <= scanline + 1;
			end if;
        end if;
    end process;

    with scanline select
	row <=	"01111111" when 0,
			"10111111" when 1,
			"11011111" when 2,
		    "11101111" when 3,
			"11110111" when 4,
			"11111011" when 5,
			"11111101" when 6,
			"11111110" when 7,
			"11111111" when others;
		
	with scanline select
	col <=	led_states(num)(1) when 0,
            led_states(num)(2) when 1,
            led_states(num)(3) when 2,
            led_states(num)(4) when 3,
            led_states(num)(5) when 4,
            led_states(num)(6) when 5,
            led_states(num)(7) when 6,
            led_states(num)(8) when 7,
			"00000000" when others;

    -- back-side
	GPIO_0(21) <= col(8);  GPIO_0(19) <= col(7);	GPIO_0(17) <= row(2); GPIO_0(15) <= col(1);
	GPIO_0(14) <= row(4);  GPIO_0(13) <= col(6);	GPIO_0(11) <= col(4); GPIO_0(9) <= row(1);
    -- front-side	
	GPIO_1(21) <= row(5);  GPIO_1(19) <= row(7);	GPIO_1(17) <= col(2); GPIO_1(15) <= col(3);
	GPIO_1(14) <= row(8);  GPIO_1(13) <= col(5);	GPIO_1(11) <= row(6); GPIO_1(9) <= row(3);
end a;
