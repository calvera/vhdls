library ieee;
use ieee.std_logic_1164.all;

---------------------------
package logic_units_pkg is
    component unit_not is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A : in  std_logic_vector(width - 1 downto 0);
             Q : out std_logic_vector(width - 1 downto 0)
            );
    end component unit_not;

    component unit_zero is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A : in  std_logic_vector(width - 1 downto 0);
             Q : out std_logic
            );
    end component unit_zero;

    component unit_sign is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A : in  std_logic_vector(width - 1 downto 0);
             Q : out std_logic
            );
    end component unit_sign;

    component unit_parity is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A : in  std_logic_vector(width - 1 downto 0);
             Q : out std_logic
            );
    end component unit_parity;

    component unit_or is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A, B : in  std_logic_vector(width - 1 downto 0);
             Q    : out std_logic_vector(width - 1 downto 0)
            );
    end component unit_or;

    component unit_xor is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A, B : in  std_logic_vector(width - 1 downto 0);
             Q    : out std_logic_vector(width - 1 downto 0)
            );
    end component unit_xor;

    component unit_and is
        generic(
            width : integer range 2 to integer'high := 8
        );
        port(A, B : in  std_logic_vector(width - 1 downto 0);
             Q    : out std_logic_vector(width - 1 downto 0)
            );
    end component unit_and;

end package logic_units_pkg;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity unit_not is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A : in  std_logic_vector(width - 1 downto 0);
         Q : out std_logic_vector(width - 1 downto 0)
        );
end entity unit_not;

architecture dataflow of unit_not is
begin
    nots : for N in 0 to width - 1 generate
        Q(N) <= NOT A(N);
    end generate;
end architecture dataflow;

architecture dataflow_simple of unit_not is
begin
    Q <= NOT A;
end architecture dataflow_simple;

architecture struct of unit_not is
begin
    nots : for N in 0 to width - 1 generate
        gate : gate_not port map(A => A(N), Q => Q(N));
    end generate;
end architecture struct;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity unit_or is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A, B : in  std_logic_vector(width - 1 downto 0);
         Q    : out std_logic_vector(width - 1 downto 0)
        );
end entity unit_or;

architecture dataflow of unit_or is
begin
    ors : for N in 0 to width - 1 generate
        Q(N) <= A(N) OR B(N);
    end generate;
end architecture dataflow;

architecture dataflow_simple of unit_or is
begin
    Q <= A OR B;
end architecture dataflow_simple;

architecture struct of unit_or is
begin
    ors : for N in 0 to width - 1 generate
        gate : gate_or port map(A => A(N), B => B(N), Q => Q(N));
    end generate;
end architecture struct;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity unit_and is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A, B : in  std_logic_vector(width - 1 downto 0);
         Q    : out std_logic_vector(width - 1 downto 0)
        );
end entity unit_and;

architecture dataflow of unit_and is
begin
    ands : for N in 0 to width - 1 generate
        Q(N) <= A(N) AND B(N);
    end generate;
end architecture dataflow;

architecture dataflow_simple of unit_and is
begin
    Q <= A AND B;
end architecture dataflow_simple;

architecture struct of unit_and is
begin
    ands : for N in 0 to width - 1 generate
        gate : gate_and port map(A => A(N), B => B(N), Q => Q(N));
    end generate;
end architecture struct;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity unit_xor is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A, B : in  std_logic_vector(width - 1 downto 0);
         Q    : out std_logic_vector(width - 1 downto 0)
        );
end entity unit_xor;

architecture dataflow of unit_xor is
begin
    xors : for N in 0 to width - 1 generate
        Q(N) <= A(N) xor B(N);
    end generate;
end architecture dataflow;

architecture dataflow_simple of unit_xor is
begin
    Q <= A xor B;
end architecture dataflow_simple;

architecture struct of unit_xor is
begin
    xors : for N in 0 to width - 1 generate
        gate : gate_xor port map(A => A(N), B => B(N), Q => Q(N));
    end generate;
end architecture struct;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.logic_gates_pkg.all;

entity unit_sign is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A : in  std_logic_vector(width - 1 downto 0);
         Q : out std_logic
        );
end entity unit_sign;

architecture dataflow of unit_sign is
begin
    Q <= A(A'high);
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.logic_gates_pkg.all;

entity unit_zero is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A : in  std_logic_vector(width - 1 downto 0);
         Q : out std_logic
        );
end entity unit_zero;

architecture dataflow of unit_zero is
begin
    Q <= AND_REDUCE(A);
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.logic_gates_pkg.all;

entity unit_parity is
    generic(
        width : integer range 2 to integer'high := 8
    );
    port(A : in  std_logic_vector(width - 1 downto 0);
         Q : out std_logic
        );
end entity unit_parity;

architecture dataflow of unit_parity is
begin
    Q <= XOR_REDUCE(A);
end architecture dataflow;
