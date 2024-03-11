library ieee;
use ieee.std_logic_1164.all;

entity IndvCustomSegDec is
    port (
        SW : in std_logic_vector(1 downto 0);
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6);
        HEX2 : out std_logic_vector(0 to 6);
        HEX3 : out std_logic_vector(0 to 6)
    );
end IndvCustomSegDec;

architecture a of IndvCustomSegDec is
constant HEX_OFF: std_logic_vector(0 to 6) := "1111111";
begin
    HEX0 <= HEX_OFF;
    HEX1 <= "0000001" when SW = "10" else HEX_OFF;
    HEX2 <= "0110000" when SW = "01" else HEX_OFF;
    HEX3 <= "1000010" when SW = "00" else HEX_OFF;
end a;