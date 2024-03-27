library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DualCounter is
	port(
		CLK: in std_logic;
		RESETN: in std_logic;
		SIG_HEX: out std_logic_vector(0 to 6);
        VAR_HEX: out std_logic_vector(0 to 6)
	);
end DualCounter;

architecture a of DualCounter is
-- Components
component IntDecimalDecoder
    port (
        V : in integer;
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6)
    );
end component;
-- Signals
signal tmp1, tmp2: integer range 0 to 10;
begin
    -- Sig
	process (CLK, RESETN)
	begin
		if RESETN = '0' then
			tmp1 <= 0;
		elsif rising_edge(CLK) then
			tmp1 <= tmp1 + 1;
            if tmp1 = 10 then
                tmp1 <= 0;
            end if;
		end if;
	end process;

    -- Var
    process (CLK, RESETN)
        variable tmp2v: integer range 0 to 10;
    begin
        if RESETN = '0' then
			tmp2v := 0;
		elsif rising_edge(CLK) then
			tmp2v := tmp2v + 1;
            if tmp2v = 10 then
                tmp2v := 0;
            end if;
		end if;
        tmp2 <= tmp2v;
    end process;

    DisplaySigHex: IntDecimalDecoder port map (
        tmp1,
        SIG_HEX,
        open
    );

    DisplayVarHex: IntDecimalDecoder port map (
        tmp2,
        VAR_HEX,
        open
    );
end a;
