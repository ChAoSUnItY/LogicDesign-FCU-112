library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecimalDecoder is
    port (
        V : in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6)
    );
end DecimalDecoder;

architecture a of DecimalDecoder is
signal TENS, DIGS : std_logic_vector(3 downto 0) := "0000";
begin
    process (V, TENS, DIGS)
    begin
        if V > "1001" then TENS <= "0001";
        else TENS <= "0000";
        end if;

        if V > "1001" then DIGS <= std_logic_vector(unsigned(V) - 10);
        else DIGS <= V;
        end if;
    end process;

    TensHex: entity work.HexSeg port map(
        A => TENS(3),
        B => TENS(2),
        C => TENS(1),
        D => TENS(0),
        NA => HEX1(0),
        NB => HEX1(1),
        NC => HEX1(2),
        ND => HEX1(3),
        NE => HEX1(4),
        NF => HEX1(5),
        NG => HEX1(6)
    );

    DigsHex: entity work.HexSeg port map(
        A => DIGS(3),
        B => DIGS(2),
        C => DIGS(1),
        D => DIGS(0),
        NA => HEX0(0),
        NB => HEX0(1),
        NC => HEX0(2),
        ND => HEX0(3),
        NE => HEX0(4),
        NF => HEX0(5),
        NG => HEX0(6)
    );
end a;
