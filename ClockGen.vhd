library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ClockGen is
	generic(
        DIV : integer := 50_000_000
    );
	port 
	(
        CLK_IN : in std_logic;
        CLK_OUT : out std_logic
    ); 
end ClockGen;

architecture a of ClockGen is
	signal count : integer range 0 to DIV := 0;
	signal clk_out_sig : std_logic;
begin
	process (CLK_IN)
	begin
		if CLK_IN'event and CLK_IN = '1' then
			if count < DIV / 2 - 1 then
				count <= count + 1;
			else
				count <= 0;
				clk_out_sig <= not clk_out_sig;
			end if;
		end if;
		CLK_OUT <= clk_out_sig;
	end process;
end a;