library ieee;
use ieee.std_logic_1164.all;

entity halfadder is
    port(
        a : in  std_logic;
        b : in  std_logic;
        q : out std_logic;
        c : out std_logic
    );
end entity halfadder;

architecture RTL of halfadder is

begin
    q <= a xor b;
    c <= a and b;

end architecture RTL;

library ieee;
use ieee.std_logic_1164.all;

entity fulladder1b is
    port(
        a    : in  std_logic;
        b    : in  std_logic;
        cin  : in  std_logic;
        q    : out std_logic;
        cout : out std_logic
    );
end entity fulladder1b;

architecture RTL of fulladder1b is
    signal partsum : std_logic;
    signal c1, c2  : std_logic;
begin
    halfadder1 : entity work.halfadder
        port map(
            a => a,
            b => b,
            q => partsum,
            c => c1
        );
    halfadder2 : entity work.halfadder
        port map(
            a => partsum,
            b => cin,
            q => q,
            c => c2
        );

    cout <= c1 OR c2;

end architecture RTL;

architecture GATES of fulladder1b is
begin

    q    <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);

end GATES;

library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic(
        width : integer range 2 to 32 := 8
    );
    port(
        a    : in  std_logic_vector(width-1 downto 0);
        b    : in  std_logic_vector(width-1 downto 0);
        cin  : in  std_logic;
        q    : out std_logic_vector(width-1 downto 0);
        cout : out std_logic
    );
end entity adder;

architecture RTL of adder is
    signal C : std_logic_vector(width downto 0);
begin
    adders : for N in 0 to width - 1 generate
        myadder : entity work.fulladder1b
            port map(
                a    => A(N), b => B(N), q => q(N), cin => C(N), cout => C(N + 1)
            );
    end generate;
    C(0) <= Cin;
    Cout <= C(width);

end architecture RTL;
