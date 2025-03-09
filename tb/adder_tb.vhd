library ieee;
use ieee.std_logic_1164.all;

entity halfadder_tb is
end halfadder_tb;

architecture rtl of halfadder_tb is
    component halfadder
        port(
            a, b : in  std_logic;       -- inputs
            q, c : out std_logic        -- outputs
        );

    end component;
    signal ip1_s, ip2_s : std_logic;    -- signals
    signal sum_s, ca_s  : std_logic;    -- output signals
begin

    ip1_s <= '0', '1' after 30 NS, '0' after 60 NS, '1' after 90 NS;
    ip2_s <= '0', '1' after 60 NS, '0' after 120 NS;

    uut : halfadder
        port map(
            a => ip1_s,
            b => ip2_s,
            q => sum_s,
            c => ca_s);

end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity fulladder1b_tb is
end fulladder1b_tb;

architecture rtl of fulladder1b_tb is
    component fulladder1b
        port(
            a, b, cin : in  std_logic;  -- inputs
            q, cout   : out std_logic   -- outputs
        );

    end component;
    signal a, b, cin : std_logic;       -- signals
    signal q, cout   : std_logic;       -- output signals
begin

    a   <= '0', '1' after 30 NS, '0' after 60 NS, '1' after 90 NS, '0' after 120 NS, '1' after 150 NS, '0' after 180 NS, '1' after 210 NS, '0' after 240 NS;
    b   <= '0', '1' after 60 NS, '0' after 120 NS, '1' after 180 NS, '0' after 240 NS;
    cin <= '0', '1' after 120 NS, '0' after 240 NS;

    uut : fulladder1b
        port map(
            a    => a,
            b    => b,
            cin  => cin,
            q    => q,
            cout => cout);

end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Include UVVM Utility Library
library uvvm_util;
context uvvm_util.uvvm_util_context;

-- Include VVC Framework
library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

entity adder_tb is
end adder_tb;

architecture tb of adder_tb is
    -- Clock and reset signals
    signal clk : std_logic := '0';

    -- DUT signals
    signal a    : std_logic_vector(31 downto 0) := ((others => '0'));
    signal b    : std_logic_vector(31 downto 0) := ((others => '0'));
    signal cin  : std_logic                     := '0';
    signal q    : std_logic_vector(31 downto 0) := ((others => '0'));
    signal cout : std_logic;

    -- Constants
    constant C_CLK_PERIOD : time := 10 ns;

begin
    -- Clock generator
    clk <= not clk after C_CLK_PERIOD / 2;

    enable_log_msg(ALL_MESSAGES);

    -- Main test process
    p_main : process
    begin
        -- Print test header
        log(ID_LOG_HDR, "Starting 32bit Adder Test");

        -- Test case 1: 0 + 0 + 0
        a   <= x"00000000";
        b   <= x"00000000";
        cin <= '0';
        wait for C_CLK_PERIOD;
        check_value(q, x"00000000", error, "Test case 2: Sum check");
        check_value(cout, '0', error, "Test case 1: Cout check");

        -- Test case 2: 1 + 1 + 0
        a   <= x"00000001";
        b   <= x"00000001";
        cin <= '0';
        wait for C_CLK_PERIOD;
        check_value(q, x"00000002", error, "Test case 2: Sum check");
        check_value(cout, '0', error, "Test case 2: Cout check");

        -- Test case 3: 1 + 1 + 1
        a   <= x"00000001";
        b   <= x"00000001";
        cin <= '1';
        wait for C_CLK_PERIOD;
        check_value(q, x"00000003", error, "Test case 3: Sum check");
        check_value(cout, '0', error, "Test case 3: Cout check");

        -- Test case 4: Maximum value test
        a   <= x"FFFFFFFF";
        b   <= x"FFFFFFFF";
        cin <= '1';
        wait for C_CLK_PERIOD;
        check_value(q, x"FFFFFFFF", error, "Max value test: Sum check");
        check_value(cout, '1', error, "Max value test: Cout check");

        -- Report final status
        report_alert_counters(FINAL);   -- Report final counters

        -- Wait for UVVM to initialize
        await_uvvm_initialization(VOID);

        -- Finish the simulation
        log(ID_LOG_HDR, "Simulation completed");
        wait;

    end process p_main;

    -- DUT instantiation
    DUT : entity work.adder
        generic map(32)
        port map(
            a    => a,
            b    => b,
            cin  => cin,
            q    => q,
            cout => cout
        );

end architecture tb;
