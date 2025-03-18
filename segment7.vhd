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
			counter     : in  std_logic_vector(1 downto 0); -- čítač pro multiplexování
			enable      : in  STD_LOGIC := '1'; -- vypnuto/zapnuto
			digit0      : in  STD_LOGIC_VECTOR(3 downto 0); -- první číslice (0-F)
			digit0en    : in  STD_LOGIC := '1';
			digit1      : in  STD_LOGIC_VECTOR(3 downto 0); -- druhá číslice
			digit1en    : in  STD_LOGIC := '1';
			digit2      : in  STD_LOGIC_VECTOR(3 downto 0); -- třetí číslice
			digit2en    : in  STD_LOGIC := '1';
			digit3      : in  STD_LOGIC_VECTOR(3 downto 0); -- čtvrtá číslice
			digit3en    : in  STD_LOGIC := '1';
			dec_point0  : in  STD_LOGIC := '0';
			dec_point1  : in  STD_LOGIC := '0';
			dec_point2  : in  STD_LOGIC := '0';
			dec_point3  : in  STD_LOGIC := '0';
			segments    : out STD_LOGIC_VECTOR(7 downto 0); -- výstup pro segmenty (a-g)
			segment_sel : out STD_LOGIC_VECTOR(3 downto 0) -- výběr aktivní číslice
		);
	end component segment7_mux;

	-- decoder of input numbers or character codes to display segments
	function segment7_decoder(
		enable    : in std_logic;
		number    : in std_logic_vector(3 downto 0);
		dec_point : in std_logic := '0';
		invert    : in boolean   := false
	) return STD_LOGIC_VECTOR;
end package segment7_pkg;

package body segment7_pkg is
	function segment7_decoder(
		enable    : in std_logic;
		number    : in std_logic_vector(3 downto 0);
		dec_point : in std_logic := '0';
		invert    : in boolean   := false
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
		variable result : std_logic_vector(7 downto 0);

	begin
		if enable = '0' then
			result := (others => '0');
		else
			result := dec_point & decoder(to_integer(unsigned(number)));
		end if;
		if invert then
			return NOT result;
		end if;
		return result;
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
		counter     : in  std_logic_vector(1 downto 0); -- čítač pro multiplexování
		enable      : in  STD_LOGIC := '1'; -- vypnuto/zapnuto
		digit0      : in  STD_LOGIC_VECTOR(3 downto 0); -- první číslice (0-F)
		digit0en    : in  STD_LOGIC := '1';
		digit1      : in  STD_LOGIC_VECTOR(3 downto 0); -- druhá číslice
		digit1en    : in  STD_LOGIC := '1';
		digit2      : in  STD_LOGIC_VECTOR(3 downto 0); -- třetí číslice
		digit2en    : in  STD_LOGIC := '1';
		digit3      : in  STD_LOGIC_VECTOR(3 downto 0); -- čtvrtá číslice
		digit3en    : in  STD_LOGIC := '1';
		dec_point0  : in  STD_LOGIC := '0';
		dec_point1  : in  STD_LOGIC := '0';
		dec_point2  : in  STD_LOGIC := '0';
		dec_point3  : in  STD_LOGIC := '0';
		segments    : out STD_LOGIC_VECTOR(7 downto 0); -- výstup pro segmenty (a-g)
		segment_sel : out STD_LOGIC_VECTOR(3 downto 0) -- výběr aktivní číslice
	);
end segment7_mux;

architecture behavioral of segment7_mux is
	signal current_digit     : STD_LOGIC_VECTOR(3 downto 0);
	signal current_dec_point : STD_LOGIC;
	signal current_enable    : STD_LOGIC;
begin

	-- Výběr aktivní číslice
	process(counter, digit0, digit1, digit2, digit3, enable, dec_point0, dec_point1, dec_point2, dec_point3, digit0en, digit1en, digit2en, digit3en)
	begin
		if enable = '0' then
			if segment_sel_inverted then
				segment_sel <= "1111";
			else
				segment_sel <= "0000";
			end if;
			current_digit     <= (others => 'U');
			current_dec_point <= '0';
			current_enable    <= '0';
		else
			case counter is
				when "00" =>
					current_digit     <= digit0;
					current_dec_point <= dec_point0;
					current_enable    <= digit0en;
				when "01" =>
					current_digit     <= digit1;
					current_dec_point <= dec_point1;
					current_enable    <= digit1en;
				when "10" =>
					current_digit     <= digit2;
					current_dec_point <= dec_point2;
					current_enable    <= digit2en;
				when others =>
					current_digit     <= digit3;
					current_dec_point <= dec_point3;
					current_enable    <= digit3en;
			end case;
			if segment_sel_inverted then
				case counter is
					when "00" =>
						segment_sel <= "1110";
					when "01" =>
						segment_sel <= "1101";
					when "10" =>
						segment_sel <= "1011";
					when others =>
						segment_sel <= "0111";
				end case;
			else
				case counter is
					when "00" =>
						segment_sel <= "0001";
					when "01" =>
						segment_sel <= "0010";
					when "10" =>
						segment_sel <= "0100";
					when others =>
						segment_sel <= "1000";
				end case;
			end if;
		end if;
	end process;

	process(current_digit, current_dec_point, current_enable)
	begin
		segments <= segment7_decoder(current_enable, current_digit, current_dec_point, segments_inverted);
	end process;

end behavioral;
