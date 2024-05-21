module no_pipeline(
    input [2:0] x,a,b,c,
    output Y
); // depth 0
    wire w1,w2;
    assign w1 = x+a;
    assign w2 = w1+b;
    assign Y = w2 + c;
endmodule

module One_pipeline(
    input [2:0] x,a,b,c,clk,
    output Y
); // depth 1
    wire w1;
    reg w2;
    assign w1 = x+a;
    assign Y = w2+c;
    always @(posedge clk)
         w2 <= w1+b;

endmodule

module One_pipeline_register(
    input [2:0] x,a,b,c,clk,
    output Y

); // depth 1f
    reg w1,w2;
    assign Y = w2+c;
    always @(posedge clk)
    begin
        w1<=x+a;
        w2<=w1+b;
    end

endmodule

//Fine_Grain_Pipelining

module Calculation_of_power3( //3次方??��??
    output reg[7:0]X3,
    output finished,
    input[7:0] X,
    input clk, start);
    reg[7:0] ncount;
    reg[7:0] Xpower,Xin;
    assign finished = (ncount == 0);
        always@(posedge clk)
        if(start)begin
            Xpower <= X;
            Xin <=X;
            ncount <=2;
            X3<= Xpower;
        end
        else if(!finished) begin
            ncount<=ncount-1;
            Xpower<=Xpower*Xin;
        end
endmodule  

module Expand_Calculation_of_power3( //3次方Speed up
    output reg[7:0]X3,
    output finished,
    input[7:0] X,
    input clk
);
reg[7:0] XPower1,XPower2;
reg[7:0] X2;
    always@(posedge clk) begin
        XPower1 <=X;
        XPower2 <= XPower1* XPower1;
        X2<= XPower1;
        XPower1<=XPower2*X2;
    end
endmodule


module power3(    
    output [7:0] Xpower,
    input[7:0] X
    );
    reg[7:0] XPower1,XPower2;
    reg[7:0] X1,X2;
    always@(*)
    XPower1 = X;
    always@(*)
        begin
            X2 = XPower1;
            XPower2 = XPower1*XPower1;
        end
    assign XPower = XPower2*X2;

endmodule


module adder_2( //Register Balancing(to improve timing)
    output reg[7:0] sum,
    input [7:0] A,B,C,
    input clk
);
reg[7:0] rA,rB,rC;
always@(posedge clk)
    begin
        rA<=A;
        rB<=B;
        rC<=C;
        sum<=rA+rB+rC;
    end
endmodule

