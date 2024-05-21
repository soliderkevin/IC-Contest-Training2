module FIR_counter(
    //Input Port
    clk,
    rst,
	start,
	halt,
    in,

    //Output Port
    out,
	done
);
/* Input to design */
input   clk, rst, start,halt;
input   [3:0]   in;

/* Output to pattern */
output reg         out;
output reg [8:0]   done;

parameter IDLE = 9'b000000001;
parameter CAL = 9'b000000010;
parameter COUNT = 9'b000000100;
parameter DONE = 9'b000001000;

reg [9:0] CS;
reg [9:0] NS;
reg[4:0] cout;
//state controller
always@(posedge clk)
begin
    if(rst)
    begin
        CS <= 0 ;
    end
    else
    begin
        CS <= NS;
    end
end
 
//FSM controller
always@(*)
begin

        case(CS)

            IDLE:
                begin
                    if(start == 1)begin 
                        NS = IDLE;
                    end
                    else 
                    begin
                        NS = CAL;
                    end
                        //NS = (Start == 1) ? CAL:IDLE;
                end
            CAL:
                begin
                    if(halt == 1)
                    begin 
                        NS = COUNT;
                    end
                    else 
                    begin
                        NS = CAL;
                    end
                    //NS = (halt == 1) ? COUNT:CAL
                end
            
            COUNT:
                begin
                    if(cout)begin
                        NS = DONE;
                        end
                end

            DONE:
                begin
                    NS = IDLE;
                end

            default:
            begin
                NS = IDLE;
            end
    endcase
end
reg[2:0] cnext;
wire lt_two_f = cout <= 2;
//Counter + Comparator
always@(posedge clk or posedge rst)
begin 
    if(rst) 
    begin
        cout <= 0;
    end
    else 
    begin
        if(lt_two_f) 
        begin
                cout<= cnext;          
        end
    end
end

always@(*) 
begin
     cnext = cout+1;
end

reg [8:0] R1,R2,R1in,R1out,R2in,R2out,result_M1,result_M2,result_M3,sum_A1,sum_A2,Y;
//CAL DATAPATH:
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        R1in = 0;
    end
    else
    begin
        if(CS == CAL)
        begin
            R1in<= in*3; //adder 
        end
        else
        begin
            R1in <= 0;
        
        end
    end

end

//Multiplier1
always @(*) begin
    result_M1 = in * 3; // Perform multiplication
end

//Multiplier2
always @(*) begin
    result_M2 = R2out * 4; // Perform multiplication
end
//Multiplier3
always @(*) begin
    result_M3 = R2out * 5; // Perform multiplication
end

//adder 1
always @(*) begin
    sum_A1 = result_M1 + result_M2; // Perform addition
end
//adder 2
always @(*) begin
        sum_A2 = result_M3 + sum_A1; // Perform addition
end



//Register1
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        R1out<=0;
    end
    begin
        R1out<=R1in;
    end
end

//Register2
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        R2out<=0;
    end
    else
    begin
        R2out<=R2in;
    end
end

//RegisterY
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        Y<=0;
    end
    else
    begin
        Y<=0;
    end
end





endmodule