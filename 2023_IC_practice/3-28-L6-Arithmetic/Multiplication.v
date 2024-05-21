module mult_signed_1995( //verilog 1955 with sign extension
    input[2:0]a,
    input[2:0]b,
    input[5:0]prod
);
    wire[5:0] prod_intermediate0;
    wire[5:0] prod_intermediate1;
    wire[5:0] prod_intermediate2;
    wire[2:0] inv_add1;
    assign prod_intermediate0 = b[0]?{ {3{a[2]}},a;}
    assign prod_intermediate1 = b[1] ?{{2{a[2]}},a,1'b0}
    assign prod_intermediate2 = b[2] ? {{1{inv_add1[2]}},inv_add1,2'b0}:6'b0;

endmodule