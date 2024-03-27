library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MultiPhaseAdditionDisplay is
    port (
        BUT_HEX : in std_logic;
        BUT_LED : in std_logic;
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6);
        LED : out std_logic_vector(3 downto 0)
    );
end MultiPhaseAdditionDisplay;

architecture a of MultiPhaseAdditionDisplay is
-- Signals
signal MODE : std_logic_vector(1 downto 0) := (others => '0');
signal TENS_C, DIGS_C : std_logic_vector(0 to 6) := (others => '0');
signal ADDITION : std_logic_vector(3 downto 0) := (others => '0');
-- Constants
constant HEX_OFF : std_logic_vector(0 to 6) := (others => '1');
constant LED_OFF : std_logic_vector(3 downto 0) := (others => '0');
begin
    PerformAdd: process (A, B, ADDITION)
    begin
        ADDITION <= std_logic_vector(unsigned(A) + unsigned(B));
    end process PerformAdd;

    DecHexDec: entity work.DecimalDecoder port map(
        V => ADDITION,
        HEX1 => TENS_C,
        HEX0 => DIGS_C
    );

    ButtonDetection: process (A, B, MODE, BUT_HEX, BUT_LED)
    begin
        if (BUT_HEX = '1' and BUT_LED = '1') or (BUT_HEX = '0' and BUT_LED = '0') then
            MODE <= "00";
        elsif BUT_HEX = '0' then
            MODE <= "01";
        elsif BUT_LED = '0' then
            MODE <= "10";
        end if;
    end process ButtonDetection;

    Display: process(ADDITION, MODE)
    begin
        if MODE = "00" then
            HEX1 <= HEX_OFF;
            HEX0 <= HEX_OFF;
            LED <= LED_OFF;
        elsif MODE = "01" then
            HEX1 <= TENS_C;
            HEX0 <= DIGS_C;
            LED <= LED_OFF;
        elsif MODE = "10" then
            HEX1 <= HEX_OFF;
            HEX0 <= HEX_OFF;
            LED <= ADDITION;
        end if;
    end process Display;
end a;
