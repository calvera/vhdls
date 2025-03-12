library ieee;
use ieee.std_logic_1164.all;

package clock_pkg is
    component clock is
        generic(
            divider : natural
        );
        port(
            clk_in  : in  std_logic;
            reset   : in  std_logic := '0';
            clk_out : out std_logic
        );
    end component clock;

    component counting_clock is
        generic(
            divider       : natural;
            counting_bits : natural := 16
        );
        port(
            clk_in   : in  std_logic;
            reset    : in  std_logic := '0';
            clk_out  : out std_logic;
            counting : out std_logic_vector(counting_bits - 1 downto 0)
        );
    end component counting_clock;

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
        reset   : in  std_logic := '0';
        clk_out : out std_logic
    );
end entity;

architecture behavioral of clock is
    constant C_TICKS : integer := divider / 2 - 1;
    constant C_BITS  : integer := integer(ceil(log2(real(C_TICKS))));

    subtype counter_t is std_logic_vector(C_BITS downto 0);
    constant ticks : counter_t := std_logic_vector(to_unsigned(C_TICKS, C_BITS + 1));

    signal counter  : counter_t := ticks;
    signal temp_clk : std_logic := '0';
begin
    process(clk_in, reset)
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

architecture pll of clock is
    constant C_TICKS : integer := divider / 2 - 1;
    constant C_BITS  : integer := integer(ceil(log2(real(C_TICKS))));

    subtype counter_t is std_logic_vector(C_BITS downto 0);
    constant ticks : counter_t := std_logic_vector(to_unsigned(C_TICKS, C_BITS + 1));

    signal counter  : counter_t := ticks;
    signal internal_clk : std_logic := '0';
    signal temp_clk : std_logic := '0';
begin
    pll_inst : entity work.pll PORT MAP (
		areset	 => '0',
		inclk0	 => clk_in,
		c0	 => internal_clk
	);

    process(internal_clk, reset)
    begin
        if reset = '1' then
            counter  <= ticks;
            temp_clk <= '0';
        elsif (rising_edge(internal_clk)) then
            counter <= counter_t(unsigned(counter) - 1);
            if counter(counter'high) = '1' then
                temp_clk <= NOT temp_clk;
                counter  <= ticks;
            end if;
        end if;
    end process;

    clk_out <= temp_clk;
end architecture;

-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity counting_clock is
    generic(
        divider       : natural;
        counting_bits : natural := 16
    );
    port(
        clk_in   : in  std_logic;
        reset    : in  std_logic := '0';
        clk_out  : out std_logic;
        counting : out std_logic_vector(counting_bits - 1 downto 0)
    );
end entity;

architecture behavioral of counting_clock is
    signal counter : unsigned(counting_bits - 1 downto 0) := (others => '0');
    signal clk_internal: std_logic;
begin
    clk : entity work.clock(pll)
        generic map(
            divider => divider
        )
        port map(
            clk_in  => clk_in,
            reset   => reset,
            clk_out => clk_internal
        );

    process(clk_internal, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk_internal) then
            counter <= counter + 1;
        end if;
        clk_out <= clk_internal;
    end process;

    process(counter) is
    begin
        counting <= std_logic_vector(counter);
    end process;

end architecture;
