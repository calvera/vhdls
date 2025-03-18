library ieee;
use ieee.std_logic_1164.all;

package counting_pkg is

    component counting is
        generic(
            counting_bits : natural := 4;
            overflow      : natural;
            overflow2     : natural := 0
        );
        port(
            clk_in            : in  std_logic;
            reset             : in  std_logic := '0';
            clk_out           : out std_logic;
            counting          : out std_logic_vector(counting_bits - 1 downto 0);
            overflow2_enabled : in  std_logic := '0'
        );
    end component counting;

end package counting_pkg;

-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counting is
    generic(
        counting_bits : natural := 4;
        overflow      : natural;
        overflow2     : natural := 0
    );
    port(
        clk_in            : in  std_logic;
        reset             : in  std_logic := '0';
        clk_out           : out std_logic;
        counting          : out std_logic_vector(counting_bits - 1 downto 0);
        overflow2_enabled : in  std_logic := '0'
    );
end entity;

architecture behavioral of counting is
    constant C_OVERFLOW  : std_logic_vector(counting_bits - 1 downto 0) := std_logic_vector(to_unsigned(overflow, counting_bits));
    constant C_OVERFLOW2 : std_logic_vector(counting_bits - 1 downto 0) := std_logic_vector(to_unsigned(overflow2, counting_bits));
    signal counter       : std_logic_vector(counting_bits - 1 downto 0) := (others => '0');
    signal clk_out_int   : std_logic                                    := '0';
begin
    ov2 : if overflow2 > 0 generate
        process(clk_in, reset)
        begin
            if reset = '1' then
                counter     <= (others => '0');
                clk_out_int <= '0';
            elsif rising_edge(clk_in) then
                if overflow2_enabled = '1' and counter = C_OVERFLOW2 then
                    counter     <= (others => '0');
                    clk_out_int <= '1';
                elsif counter = C_OVERFLOW then
                    clk_out_int <= '1';
                    counter     <= (others => '0');
                else
                    clk_out_int <= '0';
                    counter     <= std_logic_vector(unsigned(counter) + 1);
                end if;
            end if;
        end process;
    else generate
        process(clk_in, reset)
        begin
            if reset = '1' then
                counter     <= (others => '0');
                clk_out_int <= '0';
            elsif rising_edge(clk_in) then
                if counter = C_OVERFLOW then
                    clk_out_int <= '1';
                    counter     <= (others => '0');
                else
                    clk_out_int <= '0';
                    counter     <= std_logic_vector(unsigned(counter) + 1);
                end if;
            end if;
        end process;
    end generate;

    clk_out <= clk_out_int;

    process(counter) is
    begin
        counting <= counter;
    end process;

end architecture;
