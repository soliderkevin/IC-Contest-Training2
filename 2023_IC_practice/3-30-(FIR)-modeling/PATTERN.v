`define CYCLE_TIME 12 //cycle
module PATTERN(
    //Output Port
    clk,
    rst,
	start,
	halt,
    in,

    //input Port
    out,
	done
);

/* Input to design */
output reg   clk, rst, start,halt;
output reg   [3:0]   in;

/* Output to pattern */
input         out;
input [8:0]   done;

/* define clock cycle */
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;
integer cnt;

initial 
begin
    rst = 1;
    in = 4'bx;
    start = 1'b0;
    halt = 1'b0;
    clk = 0;

    #(CYCLE*4);
    rst = 0;

    #(CYCLE*2);
    start = 1;
    @(posedge clk);
    start = 0;
    for(cnt=0;cnt<50;cnt = cnt + 1)
    begin
        in = cnt;
        @(posedge clk);    
    end
    
    halt = 1'b1;
    in = 4'bx;
    #(CYCLE);
    halt = 1'b0;

    #(30*CYCLE);
    $finish;
end

endmodule