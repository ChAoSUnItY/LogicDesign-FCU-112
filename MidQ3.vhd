library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity MidQ3 is
	port(
		CLK, RESETN, SW : in std_logic;
		HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(7 downto 0)
	);
end MidQ3;

architecture a of MidQ3 is
-- constants
constant p1 : integer := 3;
constant p2 : integer := 0;
constant p3 : integer := 2;
-- signals
signal count : integer range 1 to 50000000 := 1;
signal idx : integer := 1;
signal pn : integer := 3;
signal digs, tens, hrds, thds : std_logic_vector(3 downto 0) := (others => '0');
signal r1 : integer := p1;
signal r2 : integer := p2;
signal r3 : integer := p3;
begin
	process (SW, CLK, RESETN)
		variable np: integer;
	begin
		if RESETN = '0' then
			r1 <= p1;
            r2 <= p2;
            r3 <= p3;
            idx <= 1;
            pn <= 3;
		elsif CLK'event and CLK = '1' then
            if SW = '1' then
                if count = 50000000 then
                    if idx = 0 then
                        pn <= r1;
                    elsif idx = 1 then
                        pn <= r2;
                    elsif idx = 2 then
                        pn <= r3;
                    else
                        np := r2 + r1;
                        r1 <= r2;
                        r2 <= r3;
                        r3 <= np;
                        pn <= np;
                    end if;
    
                    idx <= idx + 1;
                    count <= 1;
                else
                    count <= count + 1;
                end if;
            end if;
		end if;
	end process;

    process (pn)
    begin
        thds <= conv_std_logic_vector((pn / 1000) MOD 10, 4);
        hrds <= conv_std_logic_vector((pn / 100) MOD 10, 4);
        tens <= conv_std_logic_vector((pn / 10) MOD 10, 4);
        digs <= conv_std_logic_vector(pn MOD 10, 4);
    end process;

    ThdsHex: entity work.HexSeg port map(
        A => thds(3),
        B => thds(2),
        C => thds(1),
        D => thds(0),
        NA => HEX3(0),
        NB => HEX3(1),
        NC => HEX3(2),
        ND => HEX3(3),
        NE => HEX3(4),
        NF => HEX3(5),
        NG => HEX3(6)
    );

    HrdsHex: entity work.HexSeg port map(
        A => hrds(3),
        B => hrds(2),
        C => hrds(1),
        D => hrds(0),
        NA => HEX2(0),
        NB => HEX2(1),
        NC => HEX2(2),
        ND => HEX2(3),
        NE => HEX2(4),
        NF => HEX2(5),
        NG => HEX2(6)
    );

    TensHex: entity work.HexSeg port map(
        A => tens(3),
        B => tens(2),
        C => tens(1),
        D => tens(0),
        NA => HEX1(0),
        NB => HEX1(1),
        NC => HEX1(2),
        ND => HEX1(3),
        NE => HEX1(4),
        NF => HEX1(5),
        NG => HEX1(6)
    );

    DigsHex: entity work.HexSeg port map(
        A => digs(3),
        B => digs(2),
        C => digs(1),
        D => digs(0),
        NA => HEX0(0),
        NB => HEX0(1),
        NC => HEX0(2),
        ND => HEX0(3),
        NE => HEX0(4),
        NF => HEX0(5),
        NG => HEX0(6)
    );
end a;
