library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCDCounter is
	port(
		CLK, RESETN : in std_logic;
		HEX0, HEX1: out std_logic_vector(0 to 6)
	);
end BCDCounter;

architecture a of BCDCounter is
-- Components
component IntDecimalDecoder
    port (
        V : in integer;
        HEX0, HEX1 : out std_logic_vector(0 to 6)
    );
end component;
-- Signals
signal count : integer range 0 to 1 := 0;
signal val : integer range 0 to 99 := 0;
begin
    process (CLK, RESETN)
    begin
        if RESETN = '0' then
            count <= 0;
            val <= 0;
        elsif CLK'event and CLK = '1' then
            if count = 1 then
                if val = 99 then
                    val <= 0;
                else
                    val <= val + 1;
                end if;

                count <= 0;
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
