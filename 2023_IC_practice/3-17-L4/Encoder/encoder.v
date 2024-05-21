//Two different style of 4->2 bits Encoder
//1. Assign method
module Enc42a(a,b);
input [3:0] a;
output[1:0] b;
wire [1:0] b;

    assign b[1] = a[3] | a[2];
    assign b[0] = a[3] | a[1];
endmodule
//2. case method
module Enc42a_2(a,b);
input [3:0] a;
output reg [1:0] b;

    always@(*) begin
        case(a)
        4'b0001: b = 2'd0;
        4'b0010: b = 2'd1;
        4'b0100: b = 2'd2;
        4'b1000: b = 2'd3;
        4'b0000: b = 2'd0; // to facitate the large encoder
        default: b = 2'd0; //Should had 16 combinations included, so we have to add "default" to include other 11 possibilities.
        endcase
    end
endmodule