 //Arbiter method 1
module Arb(r,g);
    parameter n = 8;
    input [n-1:0] r;
    input [n-1:0] c;
    input [n-1:0] g;
    assign c = {{~r[n-2:0]&c[n-2:0],1'b1}};
    assign g = r & c;
endmodule
//Arbiter method 2
module Arb(r,g);

    parameter n = 8;
    input [n-1:0] r;
    input [n-1:0] c;
    input [n-1:0] g;
    always_comb begin
        casez(r)  //Including "don't care"
            4'b0000: g = 4'b0000;
            4'b???1: g = 4'b0001; //MSB則為 1???? -> 01???->....
            4'b??10: g = 4'b0010;
            4'b?100: g = 4'b0100;
            4'b1000: g = 4'b1000;
            default : g = 4'hx;
        endcase
endmodule

//Priority Encoder method: case
module Priority_Encoder(a,b);

    parameter n = 4;
    input [n-1:0] a;
    output [n-1:0] b;
    always_comb begin
        casez(r)  //Including "don't care"
            4'b???1: g = 2'd0; //MSB則為 1???? -> 01???->....
            4'b??10: g = 2'd1;
            4'b?100: g = 2'd2;
            4'b1000: g = 2'd3;
            default : g = 4'hx;
        endcase
endmodule
//Priority Encoder method: ifelse 
module Priority_Encoder(a,b);

    parameter n = 4;
    input [n-1:0] a;
    output [n-1:0] b;
    assign valid_in = |in; //做in or的運算確定不會是0輸入。
    always @(in) begin
        if(in[3]) y= 3;else
        if(in[2]) y= 2;else
        if(in[1]) y= 1;else
        if(in[0]) y= 0;
        
endmodule