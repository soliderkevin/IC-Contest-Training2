//This decoder transfer binary to onehot.
module bo_dec(a,b);
    parameter n=2;
    parameter n=4;

    input [n-1:0] a;
    output [m-1:0] b;
    wire [m-1:0]b;
    
    assign b = 1<<qa;
endmodule