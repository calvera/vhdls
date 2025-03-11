library ieee;
use ieee.std_logic_1164.all;
use work.logic_units_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    port(
        A, B : in  std_logic_vector(7 downto 0);
        Q1, Q2, Q3    : out std_logic_vector(7 downto 0)
    );
end entity test;

architecture RTL of test is
begin
    uut1 : entity work.unit_xor(dataflow)
        generic map(
            width => 8
        )
        port map(
            A => A,
            B => B,
            Q => Q1
        );
    uut2 : entity work.unit_xor(dataflow_simple)
        generic map(
            width => 8
        )
        port map(
            A => A,
            B => B,
            Q => Q2
        );
    uut3 : entity work.unit_xor(struct)
        generic map(
            width => 8
        )
        port map(
            A => A,
            B => B,
            Q => Q3
        );

end architecture RTL;
