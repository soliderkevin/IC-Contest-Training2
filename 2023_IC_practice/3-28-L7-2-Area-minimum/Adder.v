
module adder_logic(
    input A,B,C,D,E,
    output SUM1,SUM2,SUM3
);

    assign SUM1 = A+B+C;
    assign SUM2 = A+B+D;
    assign SUM3 = A+B+E;
endmodule

module adder_logic_sharing(
    input A,B,C,D,E,
    output SUM1,SUM2,SUM3
);
    assign tmp = A+B;
    assign SUM1 = tmp +C;
    assign SUM2 = tmp +D;
    assign SUM3 = tmp +E;
endmodule