module FIR(
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
output reg [8:0] out;
output reg done;

parameter IDLE = 4'd0;
parameter CAL = 4'd1;
parameter COUNT = 4'd2;
parameter DONE = 4'd3;
parameter HALT_CYCLES = 3; //3-1(register delay);
reg done_tmp;
reg [3:0] CS;
reg [3:0] NS;
reg[2:0] cout;
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
                    if(start == 1)
                    begin 
                            NS = IDLE;
                    end
                    else 
                    begin
                            NS = CAL;
                    end
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
                end
            
            COUNT:
                begin
                    if(cout)
                    begin
                        NS = DONE;
                    end
                    else
                    begin
                        NS = IDLE;
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

wire lt_two_f = cout >= 2;

//Counter + Comparator
always@(posedge clk or posedge rst)
begin 
    if(rst) 
    begin
        cout <= 0;
    end
    else 
    begin
        cout<= cnext;    
        
        if(lt_two_f) 
        begin
     
                cout <= 0;
        end
    end
end

always@(*) 
begin
     cnext = cout+1;
end

reg [9:0] R_in,R1out,R2out,result_M1,result_M2,result_M3,sum_A1,Rin_tmp,out_tmp,sum_A2;

//CAL DATAPATH Multiplexor? 0:1 :
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        R_in = 0;
    end
    else if(in)
    begin
        if(CS == CAL)
        begin
            R_in <= in; //adder 
        end
    else
        begin
            R_in <= Rin_tmp;
        end
    end
end
always@(posedge clk)
begin
    if(rst)
    begin
        Rin_tmp<=0;
    end
    else if(R_in)
    begin
        Rin_tmp <= R_in;
    end
    else
    begin
        Rin_tmp = Rin_tmp;
    end
end

reg[8:0] in_tmp;
//Multiplier1
always @(*) 
begin
    if(in)
        begin
            result_M1 = in * 3; // Perform multiplication
        end
    else 
    begin
        result_M1 = in_tmp;
    end
end

always@(posedge clk)  //exclude the random signal, inheritate the signal.
begin
    if(rst)
    begin
        in_tmp<=0;
    end
    else if(in) 
    begin
        in_tmp = in;
    end
    else
    begin
        in_tmp <= in_tmp;
    end
end

//Multiplier2
always @(*) begin
    result_M2 = R1out * 4; // Perform multiplication
end

//Multiplier3
always @(*) begin
    result_M3 = R2out * 5; // Perform multiplication
end

//adder 1
always @(*) begin
    begin
        sum_A1 = result_M1 + result_M2; // Perform addition
    end
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
        R1out<=R_in;
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
        R2out<=R1out;
    end
end

//RegisterY
always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        out<=0;
    end
    else if(done)
    begin
        out<=0;
    end
    else if(done_tmp)
    begin
        out<= 0;
    end
    else
    begin
        if(sum_A2 >= 0) //deal with when rst, and no signal inside sum_A2 problem
            begin
                out <= sum_A2;
            end
        else
            begin
                out <= out_tmp;
            end
    end
end

always@(posedge clk) //to inheritate the information when rst gone.
begin
    if(out >= 0)
        begin
            out_tmp <= out;
        end
    else
        begin
             out_tmp <= 0;
        end
end

always@(posedge clk )begin
    if(rst) 
    begin
        done_tmp<=0;
    end
    else if(done)
    begin
        done_tmp <= done;
    end
    else begin
        done_tmp <= done_tmp;
    end
end

//when no rst or information, it has to remain previous state!

reg[2:0] count_halt,count_next;
reg count_trigger;
//Halt register count 2 cycles.

always@(posedge clk)
begin
    if(rst)
    begin
        count_trigger <= 0;
    end
    else if(halt == 1) 
        begin
            count_trigger <= 1;
        end
    else
        begin
            count_trigger<= count_trigger;
        end
end

always@(posedge clk or posedge rst)
begin
    if(rst)
        begin
            count_halt <= 0;
        end
    else if(count_trigger == 1)
        begin
            count_halt <= count_halt+1;
        end
    else
        begin
            count_halt <= count_halt;
        end
end
//Counter for halting

always@(*)  // pull up done signal.
begin
    if(rst)
        begin
            done = 0;
        end
    else if(count_halt == HALT_CYCLES)
        begin
            done = 1;
        end
    else 
        begin
            done = 0;
        end
end

always@(posedge clk)
begin
    if(done == 1) 
    begin
        count_trigger <= 0;
    end
end
always@(posedge clk)
begin
    if(done == 1) 
    begin
        count_halt <= 0;
    end
end


//When RST gone, the value just gone.




endmodule