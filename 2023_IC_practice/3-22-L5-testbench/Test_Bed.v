`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
`include "Seq.sv"
`elsif GATE
`include "Seq_SYN.v"
`endif

module TESTED_BED();

logic CLK, rst_n, in_valid, out_valid, out_data;
logic [3:0]in_data;
    intial begin
        'ifdef result
            $fsdbDumpfil("Seq.fsdb");
            $fsdbDumpfil(0,"+mda");
        'elsif GATE
            $fsdbDumpfil("Seq_SYN.fsdb");
            $fsdbDumpfil("Seq_SYN.adf",I_Seq);
            $fsdbDumpfil(0,"+mda");
        `endif
    end

Seq I_Seq(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_data(.in_data),
    .out_valid(.out_valid),
    .out_data(.out_data)
)

PATTERN 1_PATTERN(
    .clk(clk),
    .rst_n(rst_n),
)

endmodule