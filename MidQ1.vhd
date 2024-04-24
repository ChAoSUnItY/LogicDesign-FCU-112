library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MidQ1 is
	port(
		CLK, RESETN, SW : in std_logic;
		HEX0, HEX1: out std_logic_vector(0 to 6)
	);
end MidQ1;

architecture a of MidQ1 is
-- Components
component IntDecimalDecoder
    port (
        V : in integer;
        HEX0, HEX1 : out std_logic_vector(0 to 6)
    );
end component;
-- Signals
signal count : integer range 1 to 50000000 := 1;
signal val : integer range 0 to 24 := 0;
signal prev_sw : std_logic := SW;
begin
    process (CLK, RESETN)
    begin
        if prev_sw /= SW then
            count <= 1;
            val <= 0;
            prev_sw <= SW;
        elsif CLK'event and CLK = '1' then
            if count = 50000000 then
                if SW = '0' and val = 12 then
                    val <= 0;
                elsif SW = '1' and val = 24 then
                    val <= 0;    
                else
                    val <= val + 1;
                end if;

                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    Display: IntDecimalDecoder port map (
        val,
        HEX0,
        HEX1
    );
end a;
