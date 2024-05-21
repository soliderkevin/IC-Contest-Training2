/*verilog testbench*/
`timescale 1ns/1ps //time resolution
`include "counter_selected_file.v"
`include "pattern.v"

module testbench;
parameter Width = 8;
wire clk_p;
wire rst_n;
wire [Width-1:0] data_in;
wire [Width-1:0] data_out;

pattern U_pattern(
    .clk_p(clk_p),
    .rst_n(rst_n),
    .data_in(data_in),
    .data_out(data_out)
);

desgin U_design(
    .clk_p(clk_p),
    .rst_n(rst_n),
    .data_in(data_in),
    .data_out(data_out)
);


//dumping wave form
Intiial begin
    $dumpfile("waveform.fadb")
    $Dumpvars;
end


endmodule




/*(System verilog).sv testbench*/
`timescale 1ns/1ps //time resolution
`include "counter_selected_file.v"
`include "pattern.v"

module testbench;
parameter Width = 8;
wire clk_p;
wire rst_n;
wire [Width-1:0] data_in;
wire [Width-1:0] data_out;

pattern U_pattern(
 .*
 );

desgin U_design(
.*
);


//dumping wave form
Intiial begin
    $dumpfile("waveform.fadb")
    $Dumpvars;
end


endmodule

