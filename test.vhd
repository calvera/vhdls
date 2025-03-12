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
        SEG    : out std_logic_vector(6 downto 0)
    );
end entity test;

architecture RTL of test is
begin
    mux : segment7_mux
        generic map(
            segments_inverted    => true,
            segment_sel_inverted => true
        )
        port map(
            clk         => clk_in,
            reset       => '0',
            enable      => '1',
            digit0      => x"0",
            digit1      => x"1",
            digit2      => x"2",
            digit3      => x"3",
            segment_sel => DIG,
            segments    => SEG
        );

end architecture RTL;
