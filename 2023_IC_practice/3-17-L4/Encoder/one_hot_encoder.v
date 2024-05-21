
//Q: What's the different between Priority encoder and simply encoder?
//A: Priority encoder is easier, and simply encoder with bigger space occupied.
// Simply binary encoder ( input is 1-hot)
module one_hot_encodser(A,Y);
input [7:0] A;
output [2:0] Y;
reg [2:0] Y;  // target of assignment


    always @(A)
        case(A)
        8'b00000001 : Y = 0;
        8'b00000010 : Y = 0;
        8'b00000100 : Y = 0;
        8'b00001000 : Y = 0;
        8'b00010000 : Y = 0;
        8'b00100000 : Y = 0;
        8'b01000000 : Y = 0;
        8'b10000000 : Y = 0;
        default: Y= 3'bXXX; // Don't care when input is not 1-hot.
        endcase
endmodule

// Simply binary encoder ( input is 1-hot)
module one_hot_encoder_array(A,Y);
input [7:0] A;
output [2:0] Y;
reg [2:0] Y;  // target of assignment
    always @(A)
        case(A)
            A[0]: Y=0;
            A[1]: Y=1;
            A[2]: Y=2;
            A[3]: Y=3;
            A[4]: Y=4;
            A[5]: Y=5;
            A[6]: Y=6;
            A[7]: Y=7;
        default: Y= 3'bXXX; // Don't care when input is not 1-hot.
        endcase
endmodule
