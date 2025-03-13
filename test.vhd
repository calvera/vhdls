library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.segment7_pkg.all;

entity test is
    port(
        clk_in : in  std_logic;
        -- multiplexing digits
        DIG    : out std_logic_vector(3 downto 0);
        -- control segments of the current digit (7 = decimal point)
        SEG    : out std_logic_vector(7 downto 0)
    );
end entity test;

architecture RTL of test is
    signal counter : std_logic_vector(15 downto 0); -- čítač pro multiplexování
    signal blink : std_logic;
begin
    refresh : entity work.counting_clock
        generic map(
            divider       => 10_000,
            counting_bits => 16
        )
        port map(
            clk_in   => clk_in,
            counting => counter,
            clk_out => blink
        );

    mux : segment7_mux
        generic map(
            segments_inverted    => true,
            segment_sel_inverted => true
        )
        port map(
            clk         => clk_in,
            digit0      => counter(3 downto 0),
            digit1      => counter(7 downto 4),
            digit2      => counter(11 downto 8),
            digit3      => counter(15 downto 12),
            dec_point2  => blink,
            segment_sel => DIG,
            segments    => SEG
        );

end architecture RTL;
