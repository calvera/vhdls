# Define the input clock
create_clock -name {clk_in} -period 20 [get_ports {clk_in}]

# Derive PLL clocks (if any)
derive_pll_clocks
derive_clock_uncertainty

# Set input delay constraints
set_input_delay -clock {clk_in} -max 5 [get_ports {reset}]
set_input_delay -clock {clk_in} -max 5 [get_ports {show_seconds}]

# Set output delay constraints
set_output_delay -clock {clk_in} -max 5 [get_ports {DIG}]
set_output_delay -clock {clk_in} -max 5 [get_ports {SEG}]

# Set false path constraints (if applicable)
# Example: set_false_path -from [get_ports {reset}] -to [get_ports {SEG}]