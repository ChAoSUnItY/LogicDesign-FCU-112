library ieee;
use ieee.std_logic_1164.all;

entity HexPrime is
    port(
        A: in std_logic;
        B: in std_logic;
        C: in std_logic;
        D: in std_logic;
        P: out std_logic
    );
end HexPrime;

architecture dataflow of HexPrime is
begin
    P <= (
        (not A and not B and C) or
        (not B and C and D) or
        (B and not C and D) or
        (not A and C and D)
    );
end dataflow;
