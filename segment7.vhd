library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.crystal_pkg.crystal_hz;

package segment7_pkg is
	component segment7_mux is
		generic(
			segments_inverted    : boolean := true;
			segment_sel_inverted : boolean := true
		);
		port(
			clk         : in  STD_LOGIC; -- hodinový signál
			reset       : in  STD_LOGIC; -- reset
			enable      : in  STD_LOGIC; -- vypnuto/zapnuto
			digit0      : in  STD_LOGIC_VECTOR(3 downto 0); -- první číslice (0-F)
			digit1      : in  STD_LOGIC_VECTOR(3 downto 0); -- druhá číslice
			digit2      : in  STD_LOGIC_VECTOR(3 downto 0); -- třetí číslice
			digit3      : in  STD_LOGIC_VECTOR(3 downto 0); -- čtvrtá číslice
			segments    : out STD_LOGIC_VECTOR(6 downto 0); -- výstup pro segmenty (a-g)
			segment_sel : out STD_LOGIC_VECTOR(3 downto 0) -- výběr aktivní číslice
		);
	end component segment7_mux;

	-- decoder of input numbers or character codes to display segments
	function segment7_decoder(
		I      : in std_logic_vector(3 downto 0);
		invert : boolean)
	return STD_LOGIC_VECTOR;
end package segment7_pkg;

package body segment7_pkg is
	function segment7_decoder(
		I      : in std_logic_vector(3 downto 0);
		invert : in boolean
	) return STD_LOGIC_VECTOR is
		type decoder_t is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
		constant decoder : decoder_t := (
			"0111111",                  --  0 = 0     000
			"0000110",                  --  1 = 1    5   1
			"1011011",                  --  2 = 2    5   1
			"1001111",                  --  3 = 3     666
			"1100110",                  --  4 = 4    4   2
			"1101101",                  --  5 = 5    4   2
			"1111101",                  --  6 = 6     333 7
			"0000111",                  --  7 = 7
			"1111111",                  --  8 = 8
			"1101111",                  --  9 = 9
			"1110111",                  -- 10 = A
			"1111100",                  -- 11 = b
			"0111001",                  -- 12 = C
			"1011110",                  -- 13 = d
			"1111001",                  -- 14 = E
			"1110001"                   -- 15 = F
		);
	begin
		if invert then
			return NOT decoder(to_integer(unsigned(I)));
		end if;
		return decoder(to_integer(unsigned(I)));
	end function segment7_decoder;

end package body segment7_pkg;

-----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.segment7_pkg.all;

entity segment7_mux is
	generic(
		segments_inverted    : boolean := true;
		segment_sel_inverted : boolean := true
	);
	port(
		clk         : in  STD_LOGIC;    -- hodinový signál
		reset       : in  STD_LOGIC;    -- reset
		enable      : in  STD_LOGIC;    -- vypnuto/zapnuto
		digit0      : in  STD_LOGIC_VECTOR(3 downto 0); -- první číslice (0-F)
		digit1      : in  STD_LOGIC_VECTOR(3 downto 0); -- druhá číslice
		digit2      : in  STD_LOGIC_VECTOR(3 downto 0); -- třetí číslice
		digit3      : in  STD_LOGIC_VECTOR(3 downto 0); -- čtvrtá číslice
		segments    : out STD_LOGIC_VECTOR(6 downto 0); -- výstup pro segmenty (a-g)
		segment_sel : out STD_LOGIC_VECTOR(3 downto 0) -- výběr aktivní číslice
	);
end segment7_mux;

architecture behavioral of segment7_mux is
	signal counter       : unsigned(32 downto 0); -- čítač pro multiplexování
	signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
begin
	process(clk, reset)
	begin
		if reset = '1' then
			counter <= (others => '0');
		elsif rising_edge(clk) then
			counter <= counter + 1;
		end if;
	end process;

	-- Výběr aktivní číslice
	process(counter(25 downto 24), digit0, digit1, digit2, digit3, enable)
	begin
		if enable = '0' then
			segment_sel   <= "0000";
			current_digit <= (others => 'U');
		else
			if segment_sel_inverted then
				case counter(25 downto 24) is
					when "00" =>
						segment_sel   <= "1110";
						current_digit <= digit0;
					when "01" =>
						segment_sel   <= "1101";
						current_digit <= digit1;
					when "10" =>
						segment_sel   <= "1011";
						current_digit <= digit2;
					when others =>
						segment_sel   <= "0111";
						current_digit <= digit3;
				end case;
			else
				case counter(25 downto 24) is
					when "00" =>
						segment_sel   <= "0001";
						current_digit <= digit0;
					when "01" =>
						segment_sel   <= "0010";
						current_digit <= digit1;
					when "10" =>
						segment_sel   <= "0100";
						current_digit <= digit2;
					when others =>
						segment_sel   <= "1000";
						current_digit <= digit3;
				end case;
			end if;
		end if;
	end process;

	process(current_digit)
	begin
		segments <= segment7_decoder(current_digit, segments_inverted);
	end process;

end behavioral;
