library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyArithmetic is
    port (
        BUT_ADD : in std_logic;
        BUT_SUB : in std_logic;
        BUT_MUL : in std_logic;
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6);
        LED : out std_logic
    );
end KeyArithmetic;

architecture a of KeyArithmetic is
-- Components
component IntDecimalDecoder
    port (
        V : in integer;
        HEX0 : out std_logic_vector(0 to 6);
        HEX1 : out std_logic_vector(0 to 6)
    );
end component;
-- Signals
signal HEX_OUT, ADDITION, SUBTRACTION, MULTIPLICATION : integer := 0;
signal LED_TEMP : std_logic := '0';
signal HEX0_TEMP, HEX1_TEMP : std_logic_vector(0 to 6) := (others => '1');
signal SHOW : boolean := false;
begin
    PERFORM_ARITH: process (A, B, BUT_ADD, BUT_SUB, BUT_MUL)
    begin
        ADDITION <= to_integer(signed(A)) + to_integer(signed(B));
        SUBTRACTION <= to_integer(signed(A)) - to_integer(signed(B));
        MULTIPLICATION <= to_integer(signed(A)) * to_integer(signed(B));

        if BUT_ADD = '0' and BUT_SUB = '1' and BUT_MUL = '1' then
            SHOW <= true;
            if ADDITION < 0 then
                LED_TEMP <= '1';
                HEX_OUT <= -ADDITION;
            else
                LED_TEMP <= '0';
                HEX_OUT <= ADDITION;
            end if;
        elsif BUT_ADD = '1' and BUT_SUB = '0' and BUT_MUL = '1' then
            SHOW <= true;
            if SUBTRACTION < 0 then
                LED_TEMP <= '1';
                HEX_OUT <= -SUBTRACTION;
            else
                LED_TEMP <= '0';
                HEX_OUT <= SUBTRACTION;
            end if;
        elsif BUT_ADD = '1' and BUT_SUB = '1' and BUT_MUL = '0' then
            SHOW <= true;
            if MULTIPLICATION < 0 then
                LED_TEMP <= '1';
                HEX_OUT <= -MULTIPLICATION;
            else
                LED_TEMP <= '0';
                HEX_OUT <= MULTIPLICATION;
            end if;
        else
            SHOW <= false;
        end if;
    end process PERFORM_ARITH;

    Display: IntDecimalDecoder port map (
        HEX_OUT,
        HEX0_TEMP,
        HEX1_TEMP
    );

    ResolveState: process (A, B, BUT_ADD, BUT_SUB, BUT_MUL, SHOW)
    begin
        if SHOW then
            HEX0 <= HEX0_TEMP;
            HEX1 <= HEX1_TEMP;
            LED <= LED_TEMP;
        else
            HEX0 <= (others => '1');
            HEX1 <= (others => '1');
            LED <= '0';
        end if;
    end process ResolveState;
end a;
