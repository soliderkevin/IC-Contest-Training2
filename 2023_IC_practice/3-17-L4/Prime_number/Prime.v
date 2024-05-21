

module prime_case(in, isprime);
input [3:0] in;
output isprime;
wire n1,n2,n3,n4;
    OAI13 U1( .A1(n2), .B1(n1), .B2(in[2]), .B3(in[3]), .Y(isprime));
    INV U2(.A(in[1]), .Y(n1));
    INV U3(.A(in[1]), .Y(n1));
    XOR2 U4( .A(in[2]), .B(in[1]), .Y(n4));
    OAT12 U5( .A1(in[0]), .B1(n3), .B2(n4), .Y(n2));
endmodule
/*Prime number function using assign*/
module prime_assign(in, isprime);
    input [3:0] in;
    output isprime;
    wire isprime =
        (in[0]& ~in[3])|
        (in[1]& ~in[2]& ~in[3])|
        (in[0]& ~in[1] &in[2])|
        (in[0]& in[1]& ~in[2]);
endmodule