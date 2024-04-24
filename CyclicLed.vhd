library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CyclicLed is
	port(
		CLK, RESETN : in std_logic;
        LEDS : out std_logic_vector(7 downto 0)
	);
end CyclicLed;

architecture a of CyclicLed is
-- Signals
signal count : integer range 1 to 50000000 := 1;
signal IDX : integer range 0 to 7 := 7;
begin
    process (CLK, RESETN)
    begin
        if RESETN = '0' then
            count <= 1;
            IDX <= 7;
            LEDS <= "10000000";
        elsif CLK'event and CLK = '1' then
            if count = 50000000 then
                if IDX = 0 then
                    IDX <= 7;
                else
                    IDX <= IDX - 1;
                end if;

                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;

        LEDS <= (others => '0');
        LEDS(IDX) <= '1';
    end process;
end a;
