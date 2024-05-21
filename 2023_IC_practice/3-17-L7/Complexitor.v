module ifelse_Multiplexor(

input a,b,c,d, 
input [ 1:0] counter_sel,
output result
);
    // Parameter declaration
    parameter Width = 8;
    //The delay will have chronological orders.
    input[Width-1:0] a;
    input[Width-1:0] b;
    input[Width-1:0] c;
    input[Width-1:0] d;
    


    always@(*)begin
        if(counter_sel == 00)begin
            assign result<=;
        end
        else if(counter_sel == 01 )begin
            assign result<=b;
        end
        else if(counter_sel == 10)begin
            assign result<=c;
        end
        else begin
        assign result <= d;
        end
    end


endmodule

module cae_Multiplexor(
    input a,b,c,d, input [ 1:0] counter_sel, output result
);
// The delay will be the same(Preferable).

    input[Width-1:0] a;
    input[Width-1:0] b;
    input[Width-1:0] c;
    input[Width-1:0] d;
    parameter Width = 8;

    always@(*)begin
        case (counter_sel)
        2'd0 : result = a;
        2'd1 : result = b;
        2'd2 : result = c;
        2'd3 : result = d;
        default : result = 0;
        endcase
    end

endmodule