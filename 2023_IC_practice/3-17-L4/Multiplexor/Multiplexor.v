//Multiplexor
//Schematic method to code
module Mux4(a3,a2,a1,a0,s,b);
parameter k= 1;
input [ k-1 : 0 ] a0,a1,a2,a3;
input[3:0] s;
output[k-1:0] b;
    
    wire[k-1:0] b = ({k{s[0]}}& a0) | ({k{s[1]}}& a1) |({k{s[2]}}& a2) |({k{s[3]}}& a3);

endmodule


//Case method to code, and it's better understanding.
module mux3a(a2,a1,a0,s,b);
parameter k= 1;
input [k-1:0] a0,a1,a2;
input [2:0] s;
output [k-1:0] b;
reg [k-1:0] b; //logic?

    always@(*) begin
        case(s)
        3'b001: b = a0;
        3'b010: b = a1;
        3'b100: b = a2;
        default b = {k{1'bx}}; //don't care "x"
        endcase
    end
endmodule