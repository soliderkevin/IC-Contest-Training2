module Pipeline_resource_sharing(
    output done,
    output reg[7:0] product,
    input [7:0] A,
    input [7:0] B,
    input clk,
    input start
)
//Area, Area*Latency = Complexity. Area = (8bits+8bits)*7 
    reg [4:0] multcounter;
    reg [7:0] shiftB;
    reg [7:0] shiftA;
    wire adden;
    assign adden = shiftB[7]&ldone;
    assign done = multcounter[3];
    always@(posedge clk) 
    begin
        if(start) 
            multcounter <= 0;
        else if (!done) 
            multcounter <=multcounter + 1;
        if(start) 
            shiftB<=B;
        else 
            shiftB[7:0] <= (shiftB[6:0],1'b0);
        if(start)
            shiftA <=A;
        else
            shiftA[7:0]<= {shiftA[7],shiftA[7:1]};

            if(start)
                product <=0;
            else if (adden)
                product <= product + shiftA;
    end
endmodule

module adder(   //Two adders on top and one 2-1 mux below
    input a,b,c,d,
    input [1:0] counter_sel,
    output [1:0]y
)

    always @(a or b or c or d or counter_sel) 
    begin
        if(s)
            y=a+b;
        else
            y=c+d;
    end
endmodule


module adder_resources_sharing(  //Two muxs on top + one adder
    input a,b,c,d,
    input [1:0] counter_sel,
    output [1:0]y
)    
    always@(a or b or c or d or a)
    begin
        reg tmp1,tmp2;
        tmp1 = s?a:c;
        tmp2 = s? b:d;
        y = tmp1 + tmp2;
    end
endmodule


)