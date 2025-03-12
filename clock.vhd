library ieee;
use ieee.std_logic_1164.all;

package clock_pkg is
    component clock is
        generic(
            divider : natural
        );
        port(
            clk_in  : in  std_logic;
            reset   : in  std_logic;
            clk_out : out std_logic
        );
    end component clock;

end package clock_pkg;

-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clock is
    generic(
        divider : natural
    );
    port(
        clk_in  : in  std_logic;
        reset   : in  std_logic;
        clk_out : out std_logic
    );
end entity;
architecture behavioral of clock is
    constant c_ticks: integer := divider / 2 - 1;
    constant c_BITS : integer := integer(ceil(log2(real(c_ticks))));
    subtype counter_t is std_logic_vector(c_bits-1 downto 0);
    constant ticks  : counter_t := std_logic_vector(to_unsigned(c_ticks, c_BITS));
    signal counter  : counter_t := ticks;
    signal temp_clk : std_logic := '0';
begin
    process(clk_in)
    begin
        if reset = '1' then
            counter  <= ticks;
            temp_clk <= '0';
        elsif (rising_edge(clk_in)) then
            counter <= counter_t(unsigned(counter) - 1);
            if counter(counter'high) = '1' then
                temp_clk <= NOT temp_clk;
                counter  <= ticks;
            end if;
        end if;
    end process;

    clk_out <= temp_clk;
end architecture;
