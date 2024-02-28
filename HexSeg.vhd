library ieee;
use ieee.std_logic_1164.all;

entity HexSeg is
    port(
        A: in std_logic;
        B: in std_logic; 
        C: in std_logic; 
        D: in std_logic; 
        NA: out std_logic; 
        NB: out std_logic; 
        NC: out std_logic; 
        ND: out std_logic; 
        NE: out std_logic; 
        NF: out std_logic; 
        NG: out std_logic
    );
end HexSeg;

architecture dataflow of HexSeg is
begin
    NA <= not (
        (A and not B and not C) or
        (not A and B and D) or
        (A and not D) or
        (not A and C) or
        (B and C) or
        (not B and not D)
    );
    NB <= not (
        (not A and not C and not D) or
        (not A and C and D) or
        (A and not C and D) or
        (not B and not C) or
        (not B and not D)
    );
    NC <= not (
        (not A and not C) or
        (not A and D) or
        (not C and D) or
        (not A and B) or
        (A and not B)
    );
    ND <= not (
        (not A and not B and not D) or
        (not B and C and D) or
        (B and not C and D) or
        (B and C and not D) or
        (A and not C)
    );
    NE <= not (
        (not B and not D) or
        (C and not D) or
        (A and C) or
        (A and B)
    );
    NF <= not (
        (not A and B and not C) or
        (not C and not D) or
        (B and not D) or
        (A and not B) or
        (A and C)
    );
    NG <= not (
        (not A and B and not C) or
        (not B and C) or
        (C and not D) or
        (A and not B) or
        (A and D)
    );
end dataflow;
