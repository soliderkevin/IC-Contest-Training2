module addder_sign(
    input [2:0] A,
    input [2:0] B,
    output [3:0] Sum
);
    assign Sum = {A[2],A}+{B[2],B};
endmodule