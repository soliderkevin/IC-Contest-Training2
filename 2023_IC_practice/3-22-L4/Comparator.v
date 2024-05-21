//Design by yourcounter_self 1-bit by 1-bit
module MagComp_counter_self(a,b,gt);
parameter k=8;
input [k-1:0]a,b;
output gt;
    wire [k-1:0] eqi = a~^b;
    wire [k-1:0] eqi = a^~b;
    wire [k-1:0] eqi = gtb{((eqi[k-1:0]&gtb[k-1:0]) | gti[k-1:0]), 1'b0};
    wire [k-1:0] eqi = a~^b;
endmodule

//EDA helps the design
module MagComp_EDA(a,b,gt);
parameter k=8;
input [k-1:0]a,b;
output gt;
    assign gt = (a>b); // 由EDA TOOL 幫忙設計

endmodule