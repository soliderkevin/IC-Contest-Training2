//4-bit prime in case
module 4_bit_Prime_case();
    input [3:0] in;
    output isprime;
    logic isprime;

    always@(*)  //always_comb(combinational logic)
    begin
        case(in)
            1,2,3,4,5,7,11,13: 
                isprime= 1'b1;
            default:
                isprime = 1;b0;
        endcase
    end
endmodule
//4-bit prime in casez
module 4_bit_Prime_casez();
    input [3:0] in;
    output isprime;
    logic isprime;

    always@(*)  //always_comb(combinational logic)
    begin
        casez(in)
            4'b0??1: isprime = 1;
            4'b001?: isprime = 1;
            4'b?011: isprime = 1;
            4'b?101: isprime = 0;
            default: isprime = 0;
        endcase
    end
endmodule
//4-bit prime in assign
module 4_bit_Prime_casez();
    input [3:0] in;
    output isprime;

    wire isprime =  (in[0]& ~in[3])|
                    ( in[1]& ~in[2] & ~in[3])|
                    (in[0]& ~in[1] & ~in[2])| 
                    (in[1]& in[2] & ~in[3]);
endmodule