module LRL_Shift_Register1(clk,rst,left,right,load,sin,in,out);
parameter n = 4;
input   clk,    rst,    left,   right,  load,   sin;
input   [n-1:0] in,
output  [n-1:0] out,
reg     [n-1:0] next;
reg     [4:0]   out;

always@(posedge clk or posedge rst) 
    if(rst)
        out <= 0;
    else
        out <= next;

always@(*)
    begin
        casez({left,right,load})
        3'b1??: next = {out[n-2:0],sin}; //left
        3'b01?: next = {sin,out[n-1:1]}; //right
        3'b001: next = in; //load
        default: next = out; //hold
        endcase
    end
endmodule