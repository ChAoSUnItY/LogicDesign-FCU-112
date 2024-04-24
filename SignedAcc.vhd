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
signal pre_add, post_add: std_logic_vector(7 downto 0) := (others => '0');
begin
	process (CLK, RESETN)
		variable add_tmp: integer;
	begin
		if RESETN = '0' then
			pre_add <= (others => '0');
			post_add <= (others => '0');
			OVF <= '0';
		elsif rising_edge(CLK) then
			add_tmp := to_integer(signed(pre_add)) + to_integer(signed(post_add));
			post_add <= std_logic_vector(to_signed(add_tmp, post_add'length));
			pre_add <= A;
		
			if add_tmp > 127 or add_tmp < -128 then
				OVF <= '1';
			else
				OVF <= '0';
			end if;
		end if;
	end process;

	S <= post_add;
end a;
