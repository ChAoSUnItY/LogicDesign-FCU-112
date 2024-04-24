library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockDivider is
	port(
        CNT : in integer;
		CLK, RESETN : in std_logic;
        CLK_OUT : out std_logic
	);
end ClockDivider;

architecture behavioural of ClockDivider is
signal count : integer := 1;
signal tmp : std_logic := '0';    
begin
    process (CLK, RESETN)
    begin
        if (RESETN = '1') then
            count <= 1;
            tmp <= '0';
        elsif (CLK'event and CLK = '1') then
            count <= count + 1;
            if (count = CNT) then
                tmp <= NOT tmp;
                count <= 1;
            end if;
        end if;
        CLK_OUT <= tmp;
    end process;
end behavioural;
