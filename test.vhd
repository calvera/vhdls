library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    port(
        A, B : in  std_logic_vector(7 downto 0);
        Q1, Q2, Q3, Q4    : out std_logic_vector(7 downto 0)
    );
end entity test;

architecture RTL of test is
    signal cin : std_logic := '0';
begin
    uut1 : entity work.adder(struct)
        generic map(
            width => 8
        )
        port map(
            cin => cin,
            A => A,
            B => B,
            Q => Q1
        );
    uut2 : entity work.adder(behavioral)
        generic map(
            width => 8
        )
        port map(
            cin => cin,
            A => A,
            B => B,
            Q => Q2
        );
    uut3 : entity work.adder(behavioral_lookahead_carry)
        generic map(
            width => 8
        )
        port map(
            cin => cin,
            A => A,
            B => B,
            Q => Q3
        );
    uut4 : entity work.adder(dataflow_lookahead_carry)
        generic map(
            width => 8
        )
        port map(
            cin => cin,
            A => A,
            B => B,
            Q => Q4
        );

end architecture RTL;
