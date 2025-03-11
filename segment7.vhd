library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.crystal_pkg.crystal_hz;

package segment7_pkg is
	-- state of display segments
	subtype segment7_t is std_logic(6 downto 0);

	-- control of idividual segments of the display
	component segment7_unit is
		generic(
			-- digit multiplexer frequency (1000 Hz)
			multiplex : positive := crystal_hz / 1000;
			-- blink frequency (2 Hz)
			blink     : positive := crystal_hz / 2;
			-- the number of digits of the display
			digits    : positive := 4;
			-- use inverted logical levels ('0' for on)
			inverted  : boolean  := true
		);
		port(
			-- the master system clock
			clk                   : in  std_logic;
			-- reset and turn the display off
			rst                   : in  std_logic;
			-- enable (turn on) digits (unregistered)
			segment7_enable       : in  std_logic_vector(digits - 1 downto 0);
			-- enable (turn on) digits (unregistered)
			segment7_blink        : in  std_logic_vector(digits - 1 downto 0);
			-- enable (turn on) decimal points (unregistered)
			decimal_points_enable : in  std_logic_vector(digits - 1 downto 0);
			-- enable (turn on) decimal points (unregistered)
			decimal_points_blink  : in  std_logic_vector(digits - 1 downto 0);
			-- select digits to be updated
			segment7_write        : in  std_logic_vector(digits - 1 downto 0);
			---------------------------------
			-- multiplexing digits
			DIG                   : out std_logic_vector(digits - 1 downto 0);
			-- control segments of the current digit (7 = decimal point)
			SEG                   : out std_logic_vector(7 downto 0)
		);
	end component;

	-- decoder of input numbers or character codes to display segments
	-- It supports two code pages of digits and symbols:
	function segment7_decoder(I : in std_logic_vector(3 downto 0)) return segment7_t;
end package segment7_pkg;

package body segment7_pkg is
	function segment7_decoder(I : in std_logic_vector(3 downto 0)) return segment7_t is
		type decoder_t is array (0 to 15) of segment7_t;
		constant decoder : decoder_t := (
			"0111111",                  --  0 = 0     000
			"0000110",                  --  1 = 1    5   1
			"1011011",                  --  2 = 2    5   1
			"1001111",                  --  3 = 3     666
			"1100110",                  --  4 = 4    4   2
			"1101101",                  --  5 = 5    4   2
			"1111101",                  --  6 = 6     333
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
		return decoder(natural(I));
	end function segment7_decoder;

end package body segment7_pkg;

-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.crystal_pkg.crystal_hz;

entity segment7_unit is
	generic(
		-- digit multiplexer frequency (1000 Hz)
		multiplex : positive := crystal_hz / 1000;
		-- blink frequency (2 Hz)
		blink     : positive := crystal_hz / 2;
		-- the number of digits of the display
		digits    : positive := 4;
		-- use inverted logical levels ('0' for on)
		inverted  : boolean  := true
	);
	port(
		-- the master system clock
		clk                   : in  std_logic;
		-- reset and turn the display off
		rst                   : in  std_logic;
		-- enable (turn on) digits (unregistered)
		segment7_enable       : in  std_logic_vector(digits - 1 downto 0);
		-- enable (turn on) digits (unregistered)
		segment7_blink        : in  std_logic_vector(digits - 1 downto 0);
		-- enable (turn on) decimal points (unregistered)
		decimal_points_enable : in  std_logic_vector(digits - 1 downto 0);
		-- enable (turn on) decimal points (unregistered)
		decimal_points_blink  : in  std_logic_vector(digits - 1 downto 0);
		-- select digits to be updated
		segment7_write        : in  std_logic_vector(digits - 1 downto 0);
		---------------------------------
		-- multiplexing digits
		DIG                   : out std_logic_vector(digits - 1 downto 0);
		-- control segments of the current digit (7 = decimal point)
		SEG                   : out std_logic_vector(7 downto 0)
	);
end entity;
