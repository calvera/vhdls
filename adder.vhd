library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity halfadder is
    port(
        a : in  std_logic;
        b : in  std_logic;
        q : out std_logic;
        c : out std_logic
    );
end entity halfadder;

architecture dataflow of halfadder is
begin
    q <= a xor b;
    c <= a and b;

end architecture dataflow;

architecture struct of halfadder is
begin
    GX : gate_xor port map(a => a, b => b, q => q);
    GA : gate_and port map(a => a, b => b, q => c);

end architecture struct;

library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity fulladder1b is
    port(
        a    : in  std_logic;
        b    : in  std_logic;
        cin  : in  std_logic;
        q    : out std_logic;
        cout : out std_logic
    );
end entity fulladder1b;

architecture struct of fulladder1b is
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

    GO : gate_or port map(a => c1, b => c2, q => cout);

end architecture struct;

architecture dataflow of fulladder1b is
begin

    q    <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);

end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(
        a    : in  std_logic_vector(width - 1 downto 0);
        b    : in  std_logic_vector(width - 1 downto 0);
        cin  : in  std_logic;
        q    : out std_logic_vector(width - 1 downto 0);
        cout : out std_logic
    );
end entity adder;

architecture struct of adder is
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

end architecture struct;

architecture behavioral of adder is
begin
    process(A, B, Cin) is
        variable sum        : unsigned(width downto 0);
        variable sum_vector : std_logic_vector(width downto 0);
    begin
        sum        := unsigned('0' & A) + unsigned(B);
        if (Cin = '1') then
            sum := sum + 1;
        end if;
        sum_vector := std_logic_vector(sum);
        Q          <= sum_vector(width - 1 downto 0);
        Cout       <= sum_vector(width);
    end process;

end architecture behavioral;

architecture behavioral_lookahead_carry of adder is
    signal p, g : std_logic_vector(width - 1 downto 0); -- propagate, generate
    signal c    : std_logic_vector(width downto 0); -- carry
begin
    -- Generate propagate and generate signals
    g <= a and b;
    p <= a xor b;

    -- Carry look-ahead logic
    process(p, g, cin)
    begin
        c(0) <= cin;

        for i in 1 to WIDTH loop
            c(i) <= g(i - 1) or (p(i - 1) and c(i - 1));
        end loop;
    end process;

    -- Calculate sum
    q    <= p xor c(WIDTH - 1 downto 0);
    cout <= c(WIDTH);
end architecture;
