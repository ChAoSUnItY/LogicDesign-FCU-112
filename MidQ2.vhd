library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MidQ2 is
	port(
		SW : in std_logic_vector(7 downto 0);
		HEX0, HEX1: out std_logic_vector(0 to 6)
	);
end MidQ2;

architecture a of MidQ2 is
-- Components
component IntDecimalDecoder
    port (
        V : in integer;
        HEX0, HEX1 : out std_logic_vector(0 to 6)
    );
end component;
-- Signals
signal val : integer := 0;
signal sqrt_val : integer range 0 to 12 := 0;
signal TENS, DIGS : std_logic_vector(0 to 6) := (others => '0');
begin
    process (SW)
    begin
        val <= to_integer(signed(SW));

        if val > 0 then
            if val >= 1 and val < 4 then
                sqrt_val <= 1;
            elsif val >= 4 and val < 9 then
                sqrt_val <= 2;
            elsif val >= 9 and val < 16 then
                sqrt_val <= 3;
            elsif val >= 16 and val < 25 then
                sqrt_val <= 4;
            elsif val >= 25 and val < 36 then
                sqrt_val <= 5;
            elsif val >= 36 and val < 49 then
                sqrt_val <= 6;
            elsif val >= 49 and val < 64 then
                sqrt_val <= 7;
            elsif val >= 64 and val < 81 then
                sqrt_val <= 8;
            elsif val >= 81 and val < 100 then
                sqrt_val <= 9;
            elsif val >= 100 and val < 121 then
                sqrt_val <= 10;
            else
                sqrt_val <= 11;
            end if;
        end if;
    end process;

    Display: IntDecimalDecoder port map (
        sqrt_val,
        DIGS,
        TENS
    );

    process (val)
    begin
        if val <= 0 then
            HEX1 <= "0110000"; -- E
            HEX0 <= "1111010"; -- r
        else
            HEX0 <= DIGS;
            HEX1 <= TENS;
        end if;
    end process;
end a;
