library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.segment7_pkg.all;

entity test is
    port(
        clk_in       : in  std_logic;
        reset        : in  std_logic;
        show_seconds : in  std_logic;
        -- multiplexing digits
        DIG          : out std_logic_vector(3 downto 0);
        -- control segments of the current digit (7 = decimal point)
        SEG          : out std_logic_vector(7 downto 0)
    );
end entity test;

architecture RTL of test is
    signal sec_low    : std_logic_vector(3 downto 0) := (others => '0');
    signal sec_high   : std_logic_vector(3 downto 0) := (others => '0');
    signal min_low    : std_logic_vector(3 downto 0) := (others => '0');
    signal min_high   : std_logic_vector(3 downto 0) := (others => '0');
    signal hour_low   : std_logic_vector(3 downto 0) := (others => '0');
    signal hour_high  : std_logic_vector(3 downto 0) := (others => '0');
    signal dig0       : std_logic_vector(3 downto 0) := (others => '0');
    signal dig1       : std_logic_vector(3 downto 0) := (others => '0');
    signal dig2       : std_logic_vector(3 downto 0) := (others => '0');
    signal dig3       : std_logic_vector(3 downto 0) := (others => '0');
    signal dig2_en    : std_logic                    := '1';
    signal dig3_en    : std_logic                    := '1';
    signal seconds    : std_logic;
    signal seconds10  : std_logic;
    signal minutes    : std_logic;
    signal minutes10  : std_logic;
    signal hour       : std_logic;
    signal hour10     : std_logic;
    signal r          : std_logic;
    signal reset_sync : std_logic;
    signal ss         : std_logic;
    signal counter    : std_logic_vector(1 downto 0) := (others => '0');
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            reset_sync <= reset;
        end if;
    end process;

    r  <= not reset_sync;
    ss <= not show_seconds;

    refresh : entity work.counting_clock
        generic map(
            divider       => 50,
            counting_bits => 2
        )
        port map(
            clk_in   => clk_in,
            counting => counter,
            reset    => r
        );

    secs : entity work.clock
        generic map(
            divider => 10_000
        )
        port map(
            clk_in  => clk_in,
            reset   => r,
            clk_out => seconds
        );

    sl : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 9
        )
        port map(
            clk_in   => seconds,
            reset    => r,
            clk_out  => seconds10,
            counting => sec_low
        );

    sh : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 5
        )
        port map(
            clk_in   => seconds10,
            reset    => r,
            clk_out  => minutes,
            counting => sec_high
        );

    ml : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 9
        )
        port map(
            clk_in   => minutes,
            reset    => r,
            clk_out  => minutes10,
            counting => min_low
        );

    mh : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 5
        )
        port map(
            clk_in   => minutes10,
            reset    => r,
            counting => min_high,
            clk_out  => hour
        );

    hl : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 9,
            overflow2     => 3
        )
        port map(
            clk_in            => hour,
            reset             => r,
            clk_out           => hour10,
            counting          => hour_low,
            overflow2_enabled => hour_high(1)
        );

    hh : entity work.counting
        generic map(
            counting_bits => 4,
            overflow      => 5
        )
        port map(
            clk_in   => hour10,
            reset    => r,
            counting => hour_high
        );

    process(ss, hour_high, hour_low, min_high, min_low, sec_high, sec_low)
    begin
        if ss = '0' then
            dig0    <= min_low;
            dig1    <= min_high;
            dig2    <= hour_low;
            dig3    <= hour_high;
            dig2_en <= '1';
            dig3_en <= hour_high(1) or hour_high(0);
        else
            dig0    <= sec_low;
            dig1    <= sec_high;
            dig2    <= min_low;
            dig3    <= hour_low;
            dig2_en <= '0';
            dig3_en <= '0';
        end if;
    end process;

    mux : segment7_mux
        generic map(
            segments_inverted    => true,
            segment_sel_inverted => true
        )
        port map(
            counter     => counter,
            digit0      => dig0,
            digit1      => dig1,
            digit2      => dig2,
            digit3      => dig3,
            digit2en    => dig2_en,
            digit3en    => dig3_en,
            dec_point2  => seconds,
            segment_sel => DIG,
            segments    => SEG
        );

end architecture RTL;
