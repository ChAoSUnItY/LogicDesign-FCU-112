library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignedAcc is
	port(
		A: in std_logic_vector(7 downto 0);
		CLK: in std_logic;
		RESETN: in std_logic;
		OVF: out std_logic;
		S: out std_logic_vector(7 downto 0)
	);
end SignedAcc;

architecture a of SignedAcc is
signal tmp: std_logic_vector(7 downto 0) := (others => '0');
signal add_tmp: integer := 0;
begin
	process (CLK, RESETN)
	begin
		if RESETN = '0' then
			tmp <= (others => '0');
			OVF <= '0';
		elsif rising_edge(CLK) then
			add_tmp <= to_integer(signed(A)) + to_integer(signed(tmp));
		
			if add_tmp >= 128 or add_tmp <= -127 then
				OVF <= '1';
			else
				OVF <= '0';
			end if;
			
			tmp <= std_logic_vector(signed(A) + signed(tmp));
		end if;
	end process;

	S <= tmp;
end a;
