module UDL_Count1(clk,rst,up,down,load,in,out);
parameter n = 4;
input clk,rst,up,down,load;
input [n-1:0] in;
output[n-1:0] out;
wire [n-1:0] out;
reg [n-1:0] next;

DFF #(n) count(clk,next,out);

always@(*)
    begin
        casez({rst,up,down,load})
            4'b1???:next = {n{1'b0}} ; //rst
            4'b0100:next = out + 1'b1 ;
            4'b0010:next = out - 1'b1 ;
            4'b0001:next = in ;
            4'b0000:next = out ;
            default: next = {n{1'bx}} ; //unknown
        endcase
    end
endmodule


module UDL_Count_simplified(clk,rst,up,down,load,in,out);
parameter   n = 4;
input   clk,    rst,    up,    down,   load;
input   [n-1:0] in;
output  [n-1:0] out;
wire    [n-1:0] out;
reg     [n-1:0] next;

    DFF #(n) count(clk,next,out);

    assign outpm1 = out + {{n-1{down}},1'b1}; //down?-1:1

always@(rst,up,down,load,in,out,outpm1)
    begin
        casez({rst,up,down,load})
        4'b1???:next = {n{1'b0}} ; //rst
        4'b0100:next = outpm1;
        4'b0010:next = outpm1;
        4'b0001:next = in;
        4'b0000:next = out;
        default: next = out; //unknown
        endcase
    end
endmodule


module Timer_counter_down (clk,rst,laod,in,done);
parameter n= 4;
input clk,rst,load;
input [n-1:0] in;
output done;
wire [n-1:0] count,next_count;
wire done;

DFF#(n) cnt(clk,next_count,count);
    always@(rst,load,in,out)begin
        casez({rst,load,done})
            3'b1??: next_count = 0; //rst
            3'b001: next_count = 0; //done
            3'b01?: next_count = in; //load
            default: next_count = count-1'b1; //countdown
        endcase
    end

    assign done = (count == 0);
endmodule


module shift_register1(clk,rst,sin,out);

parameter n = 4;
input   clk,rst,sin;
output  [n-1:0] out;
wire    [n-1:0] next;

assign  next = (out[n-2:0],sin);

    always @(posedge clk or posedge rst) 
    begin
        if(rst) 
            out<={n{1'b0}};
        else
            out <=next;
    end

endmodule