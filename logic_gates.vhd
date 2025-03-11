library ieee;
use ieee.std_logic_1164.all;

---------------------------
package logic_gates_pkg is
    component gate_not is
        port(A : in  std_logic;
             Q : out std_logic
            );
    end component gate_not;

    component gate_or is
        port(A, B : in  std_logic;
             Q    : out std_logic
            );
    end component gate_or;

    component gate_xor is
        port(A, B : in  std_logic;
             Q    : out std_logic
            );
    end component gate_xor;

    component gate_and is
        port(A, B : in  std_logic;
             Q    : out std_logic
            );
    end component gate_and;

    component gate_nor is
        port(A, B : in  std_logic;
             Q    : out std_logic
            );
    end component gate_nor;

    component gate_nand is
        port(A, B : in  std_logic;
             Q    : out std_logic
            );
    end component gate_nand;

end package logic_gates_pkg;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_not is
    port(A : in  std_logic;
         Q : out std_logic
        );
end entity gate_not;

architecture dataflow of gate_not is
begin
    Q <= NOT A;
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_or is
    port(A, B : in  std_logic;
         Q    : out std_logic
        );
end entity gate_or;

architecture dataflow of gate_or is
begin
    Q <= A OR B;
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_xor is
    port(A, B : in  std_logic;
         Q    : out std_logic
        );
end entity gate_xor;

architecture dataflow of gate_xor is
begin
    Q <= A XOR B;
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_and is
    port(A, B : in  std_logic;
         Q    : out std_logic
        );
end entity gate_and;

architecture dataflow of gate_and is
begin
    Q <= A AND B;
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_nand is
    port(A, B : in  std_logic;
         Q    : out std_logic
        );
end entity gate_nand;

architecture dataflow of gate_nand is
begin
    Q <= A NAND B;
end architecture dataflow;

---------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gate_nor is
    port(A, B : in  std_logic;
         Q    : out std_logic
        );
end entity gate_nor;

architecture dataflow of gate_nor is
begin
    Q <= A NOR B;
end architecture dataflow;
