//This is the Binary counter_selection Multiplexor, adding a decoder at counter_selection signal.
//Method 1: Calling the premade modules.
module BS_Multiplexor();
parameter k= 1;
input [k-1:0] a0,a1,a2;
input[1:0] sb;
output[k-1:0] b;
wire[2:0] s;
    dec #(2,3) d(sb,s); //Decoder converts binary to one-hot.
    mux3 #(k) m(a2,a1,a0,s,b); //Multipexer counter_selects input
endmodule


//Method 2: EDA Tool decide
module BS_Multiplexor();
parameter k= 1;
input [k-1:0] a0,a1,a2;
input[1:0] sb;
output[k-1:0] b;
wire[2:0] s;

    always_comb begin
        case(sb) 
            0: b=a0;
            1: b= a1;
            2: b= a2; 
            default:{k{1'bx}};
        endcase
    end


endmodule