module TESTBED;

wire         clk, rst,start,halt;
wire[3:0] in;
wire[8:0] out;
wire    done;


FIR u_FIR(
       .clk            (   clk          ),
       .rst          (   rst        ),
       .in       (   in     ),
       .start           (     start       ),
       .halt             (       halt       ),

       .out      (   out    ),
       .done             (       done       )
   );

PATTERN u_PATTERN(
       .clk            (   clk          ),
       .rst          (   rst        ),
       .in       (   in     ),
       .start           (     start       ),
       .halt             (       halt       ),

       .out      (   out    ),
       .done             (       done       )
   );

endmodule