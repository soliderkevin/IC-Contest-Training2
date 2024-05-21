module VM_Datapath(
   clk,     //(1 bit)
   rst,     //(1 bit)
   price,   //input price(reg [8:0])
   nickel,  //input tokens (1 bit)
   dime,    //input tokens (1 bit)
   quarter, //input tokens (1 bit)
   serve,   //serving drinks? (1 bit)
   change_return,   // total number given(reg [8:0])
   nickel_out,dime_out,quarter_out,insufficient,
   item_rels
//    ,output nickel_out   //Nickel_out
//    ,output quarter_out  //quarter_out
//    ,output dime_out     //dime_out
//    ,output insufficient
/*Problem when considering disposing tokens pick:
1.Recieve owner input tokens and add it.
2.Return owner input tokens and subtract it.
3.Tokens register must be separated from the price register.
4.When certain token is out of amount, choose the other one.*/
);
    reg [8:0] enough,zero;
    reg [8:0]command;
    reg[8:0] CS;
    output reg[4:0]serve;
    output reg[4:0]change_return;
    output reg[8:0] nickel_out;
    output reg[8:0] dime_out;
    output reg[8:0] quarter_out;
    output reg[8:0] insufficient;
    output reg  [8:0]price;
    input  [8:0]nickel;
    input  [8:0]dime;
    input  [8:0]quarter;
    //Default signal for all verilog models.
    input clk;
    input rst;
    input item_rels;
parameter IDLE      = 3'd0;
parameter CAL1      = 3'd1;
parameter STR1      = 3'd2;
parameter CAL2      = 3'd3;
parameter STR2      = 3'd4;
parameter CHANGE    = 3'd5;
parameter CAL3      = 3'd6;
parameter STR3      = 3'd7;

//FSM of vending Machine
reg start,SERVE_DONE,SERVE_START,NS;
reg [3:0] sel1,sel2;
always@(posedge clk or rst)begin
    if(rst)begin
        CS <= IDLE;
    end
    else begin
        CS <= NS;
    end
end

wire CAL1_DONE,STR1_DONE,CAL2_DONE,CAL3_DONE;

always@(*)
begin
    case(CS)
        IDLE:
            begin
                if(sel1 == 0 )begin
                    NS = CAL1;
                end
                else begin
                    NS = IDLE;
                end
            end
        CAL1:
            begin
                if(CAL1_DONE)begin
                    NS = STR1;
                end
                else
                begin
                    NS = CAL1;
                end
            end
        STR1:
            begin
                if(STR1_DONE)begin
                    NS = CAL2;
                end
                else
                begin
                    NS = CAL1;
                end
            end
        CAL2:
            begin
                if(CAL2_DONE)
                begin
                    NS = CHANGE;
                end
                else
                begin
                    NS= CAL2;
                end
            end
        STR2:
            begin
                NS= CAL3;
            end
        CAL3:
              begin
                NS = STR3;
              end

        STR3:
            begin
                if(CAL3_DONE)begin
                    NS = IDLE;
                end
                else
                    NS = CAL3;
            end
    endcase
end
//å¤–è?‡ã?æ?•å?“ã?è‡ª??Ÿå?? ä¸‰å¤§æ³•äºº
//Comparater, signal sending at same time and ending in short period!, which have more coins to process first?
//Sending signal into reg first to save them 

//Dime reg to save the signal Dime is 1 bit signal!!!!!!!
reg[8:0] quarter_reg,nickel_reg,dime_reg;

always@(posedge clk)begin
    if (rst)begin
        dime_reg <= 0;
    end
    else begin
            if (dime > 0) begin
                dime_reg <= dime;
                end
            else begin
                dime_reg <= dime_reg;
            end
        end
 end
//Quarter reg to save the signal
always@(posedge clk)begin
    if (rst)begin
        quarter_reg <= 0;
    end
    else begin
        if(quarter)begin
            quarter_reg<=quarter;
        end
        else begin
        quarter_reg <= quarter_reg;
        end
    end
end
//Nickel reg to save the signal
always@(posedge clk)begin
    if (rst)begin
        nickel_reg <= 0;
    end
    else begin
        if(nickel)begin
            nickel_reg <= dime;
        end
        else begin
            nickel_reg <= nickel_reg;
        end
    end
end

//Which coin insert first? Deciding which goes first.
always@(posedge clk or posedge rst)
begin
    if(rst)begin
        sel1 <= 0;
    end
    else 
    begin
        if(dime_reg > 0)begin //dime first
            sel1 <= 1;
        end
        else if(quarter_reg > 0)begin
            sel1 <= 2;
        end
        else if(nickel_reg > 0)begin
            sel1 <= 3;
        end
        else begin
            sel1 <= 0; //return
        end
    end
end

reg[8:0] out_mux1;
//First Multiplexor choose which signal in
always@(*) 
begin
    if(sel1 == 1) begin
        out_mux1 = dime_reg; 
    end
    else if(sel1 == 2)begin
        out_mux1 = quarter_reg; 
    end
    else if(sel1 == 3)begin
        out_mux1 = nickel_reg; 
    end
    else begin
        out_mux1 = 0;
    end
end

reg[8:0] counter_A1;
wire CAL1_START;
//Counter back to ALU cycling
always@(posedge clk or posedge rst)
begin
    if(rst)begin
        counter_A1 <= 0;
    end
    else begin
        if(CS == CAL1_DONE)begin //when cal done, reset the clock
            counter_A1 <= 0;
        end
        else if (CS == CAL1) begin  //when comp start the count
            counter_A1 <= counter_A1 + 1;
        end
        else begin
            counter_A1 <= 0;
        end
    end
end

reg [8:0] nickel_total_reg;
reg[8:0] counter_A2;
//nickel amount inside machine counter
always@(posedge clk)begin
    if (rst)begin
        nickel_total_reg <= 0;
    end
    else begin
        if(CS == CAL1_DONE && sel1 == 3)begin
            nickel_total_reg <= nickel_total_reg + counter_A2;
        end
        else if(CS == CAL3_DONE && sel2 == 3)begin //minus change
            nickel_total_reg<= nickel_total_reg - counter_A2;
        end
        else begin
            nickel_total_reg <= nickel_total_reg;
        end
    end
end
reg[8:0] quarter_total_reg;
//quarter amount inside machine counter
always@(posedge clk)begin
    if (rst)begin
        quarter_total_reg <= 0;
    end
    else begin
        if(CS == CAL1_DONE && sel2 == 2)begin
            quarter_total_reg<=quarter_total_reg + counter_A1;
        end
        else if(CS == CAL3_DONE && sel2 == 2)begin //minus change
            quarter_total_reg<= quarter_total_reg - counter_A2;
        end
        else begin
            quarter_total_reg <= quarter_total_reg;
        end
    end
end

reg [8:0] dime_total_reg;
//dime amount inside machine
always@(posedge clk)begin
    if (rst)begin
        dime_total_reg <= 0;
    end
    else begin
        if(CS == CAL1_DONE && sel1 == 3)begin
            dime_total_reg<= dime_total_reg + counter_A1;
        end
        else if(CS == CAL3_DONE && sel2 == 3)begin
            dime_total_reg<= dime_total_reg - counter_A2;
        end
        else begin
            dime_total_reg <= dime_total_reg;
        end

    end
end


reg [9:0] out_ALU1;

//ALU for first calculation
always@(*)begin
    if(sel1 == 1 &&  CS==CAL1_DONE)begin//10 ç¾Žå?? dime
        out_ALU1 = counter_A1 * 0.1;
    end
    if(sel1 == 2 && CS==CAL1_DONE)begin//25 ç¾Žå?? quarter
        out_ALU1 = counter_A1 * 0.25;
    end
    if(sel1 == 3 && CS==CAL1_DONE)begin //5 ç¾Žå?? nickel
        out_ALU1 = counter_A1* 0.05;
    end
    else begin
        out_ALU1 = 0;
    end
end
reg[8:0] n_sum_amount,outALU1;
//Adder to CL can't read itself!
always@(*)begin
    if(CS== CAL2_DONE)begin
        n_sum_amount = outALU1;
    end
    else begin
        n_sum_amount = 0;
    end
end

reg[8:0] sum, ins_sum_total;
//Total Money inserted register : Adder + Mult+ Register
always@(posedge clk)begin
    if(rst)begin
        sum <= 0;
    end
    else begin
        if (n_sum_amount > 0 )begin
            ins_sum_total <= ins_sum_total + n_sum_amount ;
        end
        else begin
            ins_sum_total <= ins_sum_total;
        end
    end
end

reg[8:0] price_reg;
//Selecting Drink(price) register in case no reading.
always@(posedge clk)begin
    if(rst)begin
        price_reg <= 0;
        end
    else 
        if(price_reg)begin
            price <= price_reg;
        end
        else begin
            price_reg <= price_reg;
        end
 end


reg serve_reg;
//ALU:Comparater to see which is higher, and trigger serve signal
always@(*)
begin
    if(ins_sum_total >= price_reg)begin
        serve_reg = 1;
    end
    else begin
        serve_reg = 0;
    end
end



reg change_in;
//ALU:Subtracting and load the amount
always@(*)
begin
    if(ins_sum_total >= price_reg)begin
        change_in= ins_sum_total-price_reg;
    end
    else begin
        change_in = 0;
    end
end

//serve_reg to serving signal
always@(posedge clk or posedge rst)begin
    if(rst)begin
            serve <= 0;
        end
    else 
        if(serve_reg)begin
            serve <= serve_reg;
        end
        else begin
            serve <= 0;
        end
    end

reg[8:0] change_reg;
// change_reg saving in.
always@(posedge clk or posedge rst)begin
    if(rst)begin
        change_reg <= 0;
        end
    else 
        if(change_in > 0)begin
            change_reg <= change_in;
        end
        else begin
            change_reg <= change_reg;
        end
 end


reg [8:0] quarter_dis,dime_dis,nickel_dis;
// Multiplexor : Selecting amount to dispose. check nickel_out,quarter_out,dime_out: remaining amount
// nickel,quarter,dime 
//change_quarter small controller
always@(*)
begin
    if(change_reg > 0)begin
        if(quarter_out > 0)begin
            if(change_reg >= 0.25)begin
                quarter_dis = 1;
        end
            else begin 
                quarter_dis = 0;
            end
        end
    end
end
//change_dime small controller
always@(*)
begin
    if(change_reg > 0)begin
        if(dime_out > 0)begin
            if(change_reg >= 0.1)begin
                dime_dis = 1;
        end
            else begin 
                dime_dis = 0;
            end
        end
    end
end
//change_nickel small controller
always@(*)
begin
    if(change_reg > 0)begin
        if(nickel_out > 0)begin
            if(change_reg >= 0.05)begin
                nickel_dis = 1;
        end
            else begin 
                nickel_dis = 0;
            end
        end
    end
end

reg [8:0] change_reg_next,token_dis;
always@(*)
begin
    if(change_reg > 0)begin
        if(quarter_dis)begin
            if(quarter_out > 0)begin
                if(change_reg >= 0.25)
                begin
                    change_reg_next = change_reg - token_dis*0.25;   
                end
                else begin
                    change_reg_next = change_reg;
    
                    //change_reg <0.25, pull dime_out signal
                end
            end
        end
        else if(dime_dis)begin
            if(dime_out > 0)begin           
                if(change_reg >= 0.1)
                begin
                    change_reg_next = change_reg - token_dis*0.1;  
                end
                else begin
                    change_reg_next = change_reg;
                end
            end
            else
                change_reg_next = 0;
        end
        end
        else if(nickel_dis > 0) begin
            if(nickel_out)begin
                if(change_reg >= 0.05)
                begin
                    change_reg_next = change_reg - token_dis*0.01;
                end
                else begin
                    change_reg_next = change_reg;
                end
            end
            else begin
                change_reg_next = 0;
            end
        end
        else begin
            change_reg_next = 0;
        end
end

wire counter_out;
//Counter to dispose coins .
always@(posedge clk)begin
    if(rst)begin
        token_dis <= 0;
    end
    else begin
        if(counter_out)begin
            token_dis <= token_dis +1;
        end
        else begin
            token_dis <= token_dis;
        end
    end
end
reg[8:0] sel_Nickel_dis;
wire sel_nickel_dis,sel_quarter_dis,sel_dime_dis;
//Nickel dispose
always@(posedge clk)begin
    if(rst)begin
        nickel_total_reg <= 0;
    end
    else begin
        if(sel_nickel_dis)begin
            nickel_total_reg <= nickel_total_reg-token_dis;
        end
        else
        begin
            nickel_total_reg <= nickel_total_reg;
        end
    end
end
always@(*)begin
    if(sel_nickel_dis)begin
        nickel_out = 1;
    end
    else
    begin
        nickel_out = 0;
    end
end

//Quarter dispose
always@(posedge clk)begin
    if(rst)begin
        quarter_total_reg <= 0;
    end
    else begin
        if(sel_quarter_dis)begin
            quarter_total_reg <= quarter_total_reg-token_dis;
        end
        else
        begin
            quarter_total_reg <= quarter_total_reg;
        end
    end
end
wire quarter_dis2;
always@(*)begin
    if(quarter_dis2)begin
        quarter_out = 1;
    end
    else
    begin
        quarter_out = 0;
    end
end

//Dime dispose
always@(posedge clk)begin
    if(rst)begin
    end
    else begin
        if(sel_dime_dis)begin
            dime_total_reg <= dime_total_reg-token_dis;
        end
        else
        begin
            dime_total_reg <= dime_total_reg;
        end
    end
end
always@(*)begin
    if(dime_dis)begin
        dime_out = 1;
    end
    else
    begin
        dime_out = 0;
    end
end





//Choose dime,quarter or nickel amount


// //adder
// module addder_sign(
//     input [2:0] A,
//     input [2:0] B,
//     output [3:0] Sum
// );
//     assign Sum = {A[2],A}+{B[2],B};

// endmodule

// //Comparater
// //EDA helps the design
// module MagComp_EDA(a,b,gt);
// parameter k=8;
// input [k-1:0]a,b;
// output gt;
//     assign gt = (a>b); // ?”±EDA TOOL å¹«å?™è¨­è¨?

// endmodule

endmodule