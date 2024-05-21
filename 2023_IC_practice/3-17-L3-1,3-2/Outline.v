/*
Finite state machine.
*/
/*State definition*/

module fsm_cc1_2(output logic rd,ds,
input go,ws,clk, rst_n);

parameter IDLE =2'b00,
          READ =2'b01,
         DLY = 2'b11,
         DONE = 1'b10;
    logic[1:0] state, next; // state variable
    always_ff@(posedge clk, negedge rst_n) // Remember to add "reset state"

    if(!rst_n)
        begin
            state <= IDLE;'
        end
    else 
        begin
            state<= next;
        end
endmodule
/*What's the different between "define" and "parameter"?
define is a global variable.(latter will replace former if declared more than once.)
parameter is local variable.(In different modules that won't affect each others.) */



/*
3.Next state/Output logic
*/
module FSM();
    always_comb 
    begin
        next = 'bx;
        rd = 1'b0;
        ds = 1'b0
    end
case(state)
    IDLE:if(go)begin  //case item in different state test each state
            next = READ;
        end
        else begin
            next = IDLE;
        end

    READ:begin
        rd = 1'b1;
        next = DLY;
        end
    DLY : begin
        rd = 1'b1;
            if(!ws)begin
                next = DONE;
            end
            else begin
                next = READ;
            end
        end

    DONE:begin
            ds = 1'b1;
            next = IDLE;
        end 
endcase

endmodule

/*Two always coding style vs One always*/
/*Two always*/
module two_always();    
    parameter [1:0];
    IDLE = 2'b00, 
    BBUSY = 2'b01,
    BFREE = 2'b10;
    reg[1:0] state,next;

    always@(posedge clk or negedge rst_n)
    begin
    if(!rst_n)
        begin
            state <= IDLE;
        end
    else
        begin
            state<=next;
        end
    end
endmodule

/*one always not recommended, Don't merge CL and SL together*/
module one_always();
    parameter [1:0];
    IDLE = 2'b00, 
    BBUSY = 2'b01,
    BFREE = 2'b10;
    reg[1:0] state,next;
    always@(posedge clk or negedge rst_n)
    if(!rst_n) 
        begin
            state <= IDLE;
            out1 <= 1'b0;
        end
    else 
        begin
            state <= 2'bx;
            out1<= 1'b0;
            case(state)
                IDLE : if(in1)
                    begin
                        state <= BBUSY;
                        out1 <= 1'b1;
                    end
                else state <=IDLE;
                BBUSY: if(in2)
                    begin
                    state<= BBUSY;
                    out1 <= 1'b1;
                    end
                else 
                    state <=BFREE;
            endcase
        end

endmodule

/*TLDR
Use two always or three always coding style.
Two always: one for state DFF one for next state and output
Three always one for state DFF, one for next state, one for output.
*/

/*debug會看波型，0101波型，放進state有些困難。
/。3-2 TIMING
/*。How to read  a timing report?
Setup time:Clock edge來之前不能變的時間段
Hold time:
寫了design合成丟入EDA Tool會告訴說跑多快。

Q. How fast my Design can run?
Fastest clock cycle time : Tc
Max Delay: 
p:propagation(最常delay時間)
Tc>= t_pcq + t_pd + t_setup. D_FF
t_pd<= Tc - (t_pcq + t_setup)
If delay of comb. Logic is too long => setup time violation,DFF will catch the wrong value.
A.
Method to fix 1:(clock cycle slower)
Tc become larger.
Method to fix 2:(Boosting by pipeline)
Tpd smaller by pipeline or algorithm change
"t_pcq+t_setup" is called "register overhead"
先不用管"hold time violation"的部分，因為在合成之前都不會知道。
t_cd+t_ccq >= t_hold.
or use t_cd>= t_hold - t_ccq.
"cd"."cq" called "contamination"

Q. How to fix hold time violation?
A. increase tcd(e.g add delay,buffer), adding clock rate DOES NOT WORK!

 
*/

/*。Timing Paths have 3 types :
1.Input to register
2.register to register
3.register to output
(start from or end to DFFs)
1.Input to output
*/

/*。How to read and interpret timing report?
A.Four sections in Timing report: Header,Data arrival,Data required, Slack
Clock skew:
*/