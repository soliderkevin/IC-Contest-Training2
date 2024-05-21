/*
This verilog file is about assignment data type, blocking(=) and non-blocking(<=).

    1.FF should use non-blocking.
    2.Latches should use non-blocking.
    3.CL should use non-blocking.
    4. DO NOT MIX CL and SL in the same "always" block.
    5. Do not assign to the same variable from more than one always block.

*/

module blocking(
    in,clk,out

)
input in,clk;
output out;
reg q1,q2,out;

always @ (posedge clk)begin
    q1 = in;
    q2 = q1;
    out = q2;
end

endmodule


module non_blocking(
    in,clk,out
)
input in,clk;
output out;
reg q1,q2,out;

    always @ (posedge clk)begin
        q1 <= in;
        q2 <= q1;
        out <= q2;
    end
endmodule

