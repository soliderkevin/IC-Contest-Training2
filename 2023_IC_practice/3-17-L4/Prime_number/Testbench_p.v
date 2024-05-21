// set clock, I/O restriction
create_clock "clk" - name clk - period 2 - waveform(0 1.7)
set_clock_uncertainity 0.2 clk
set_fix_hold all_clocks()
set_input_delay 0.5 -clock clk{in}
set_output_delay -max 0.8 -clock clk(isprime)

//set loading
set_load = -pin_load 5 {isprime}