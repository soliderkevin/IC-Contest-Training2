module time_sharing_FIR(){
    output reg[15:0] Out,
    input clk,
    input [7:0] datain,
    input[7:0] coeffA,coeffB,coeffC
    };
    reg[7:0] X0,X1,X2;
    reg[2:0] state;
    wire[15:0] accum;
    reg[15:0] accumsum;
    wire[15:0] multout;
    reg[7:0] multdat;
    reg[7:0] multcoeff;
    
    assign multout = (state == 0)?16'b0:multcoeff*multdat;
    //clearing and loading accumulator
    assign accum = (state == 0)? 16'b0:accumsum;
    

    always@(posedge clk)
        accumseum <= accum+ mulout;
    
    always@(posedge clk)begin
        case(state):
        0:begin //load new data
            X0 <=DATAIN ; 
            X1 <= X0;
            X2 <= X1;
            multdat <= datain;
            multcoeff<=coeffA;
            state <=1;
            Out <= accumsum;
        end
        1:begin//A*X[2] is done, load B*X[1]
            multdat <= X2;
            multcoeff<=coeffC;
            state <=3;
        end
        2:begin //B*X[1] is done, load output
            multdat<=X2;
            multcoeff<=coeffC;
            state <=3;
        end
        3:begin//C*X[2] is done, load output
            state<=0;
        end
        default: 
            state<=0;
        endcase
    end
endmodule