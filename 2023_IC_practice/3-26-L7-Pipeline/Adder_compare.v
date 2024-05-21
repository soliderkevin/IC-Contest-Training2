module adder(
    input sub,
    input [1:0] a,b,
    output [1:0] y
);

    assign y = sub?(a-b):(a+b);

endmodule

module adder_optimized(
    input sub,
    input[3:0] a,b,
    output [3:0] y
    
);
    wire [3:0] tmp;
    assign tmp = sub ?~b : b;
    assign y = a + tmp + (3'b0 + sub);
    
endmodule