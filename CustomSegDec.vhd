library ieee;
use ieee.std_logic_1164.all;

entity CustomSegDec is
    port (
        C : in std_logic_vector(1 downto 0);
        NA : out std_logic;
        NB : out std_logic;
        NC : out std_logic;
        ND : out std_logic;
        NE : out std_logic;
        NF : out std_logic;
        NG : out std_logic
    );
end CustomSegDec;

architecture a of CustomSegDec is
begin
    NA <= '0' when C = "01" or C = "10" else '1';
    NB <= '0' when C = "00" or C = "10" else '1';
    NC <= '0' when C = "00" or C = "10" else '1';
    ND <= '0' when C /= "11" else '1';
    NE <= '0' when C /= "11" else '1';
    NF <= '0' when C = "01" or C = "10" else '1';
    NG <= '0' when C = "00" or C = "01" else '1';
end a;