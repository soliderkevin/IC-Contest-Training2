module VM(
    clk,
    rst,
    item,
    sel,
    dollar_10,
    dollar_50,
    price,
    item_rels,
    change_return,
    value
);
reg signed [31:0]  Total_amount;
reg cnt,sel_reg,price_out; // signal to save the signal input.
reg dollar_50_reg,dollar_10_reg;
reg [5:0] sel_saving_reg;
//reference Inputs and Outputs
input  clk;
input  rst;
output value;
input  [1:0] item; //Transition @negedge
input  sel; //Transition @negedge
input  dollar_10; //Transition @negedge
input  dollar_50; //Transition @negedge
output  reg signed [3:0] price; //Transition @posedge
output reg [2:0] item_rels; //Transition @posedge
output reg change_return; //Transition @posedge

reg [4:0]CS,NS;
reg Sel_Signal_reg,release_reg;
reg Conf_sig;

wire is_water    = item     ==      2'b00;
wire is_blacktea = item     ==      2'b01;
wire is_coke     = item     ==      2'b10;
wire is_juice    = item     ==      2'b11;
wire inserting   = sel || dollar_10 || dollar_50;

parameter IDLE        = 5'b0001;
parameter CONF        = 5'b0010;
parameter CAL         = 5'b0011;
parameter CHANGE      = 5'b0100;
parameter RST         = 5'b0101;

reg [5:0] cnt_10,cnt_50;

//Counter to start on insertionv 50$
always@(posedge clk)begin
    if(rst)begin
        cnt_50 <= 0;
    end
    else begin
        if(dollar_50_reg)begin
            cnt_50 <= cnt_50 + 1;
        end
        else if(CS == CAL)begin
            cnt_50 <= 0;
        end
        else begin
            cnt_50 <= cnt_50;
        end
    end
    
end

//Counter to start on insertionv 10$
always@(posedge clk)begin
    if(rst)begin
        cnt_10 <= 0;
    end
    else begin
        if(dollar_10_reg)begin
            cnt_10 <= cnt_10 + 1;
        end
        else if(CS == CAL)begin
            cnt_10 <= 0;
        end
        else begin
            cnt_10 <= cnt_10;
        end
    end
    
end


/*FSM: Requirements setting*/
always@(posedge clk)begin
    if(rst)begin
        CS <= 0;
    end
    else begin
        CS <= NS;
    end
end

//selection buffer
always@(posedge clk)begin
    if(rst)begin
        Conf_sig <= 0;
     end
    else begin
        if(sel)begin
            Conf_sig <= sel;
        end
        else begin
            Conf_sig <= 0;
        end
    end
end

always@(*)begin
    case(CS)
        IDLE:begin
            if(Conf_sig || dollar_10_reg || dollar_50_reg || sel_reg)begin
                NS = CONF;
            end
            else begin
                NS = CS;
            end
        end
        CONF:begin
            if(Conf_sig == 1 && Total_amount > price_out)begin
                NS = CHANGE;
            end
            else begin
                NS = CAL;
            end

        end
        CAL:begin
            if(Conf_sig == 1)begin
                NS = CONF;
            end
            else if(cnt_50 == 0 & cnt_10 == 0)begin
                NS = IDLE;
            end
            else begin
                NS = CAL;
            end

        end
        CHANGE:begin
            if(Total_amount == 0)begin
                NS = RST;
            end
            else begin
                NS = CHANGE;
            end
        end
        RST:begin
            if(release_reg)begin
                NS = IDLE;
            end
            else begin
                NS = RST;
            end
        end 
        default:begin
                NS = IDLE;
            end
    endcase
end
//Tokens saving regs:
//Buffer to save incoming tokens 10$
always@(posedge clk)begin
    if(rst)begin
        dollar_10_reg <= 0;
    end
    else begin
        if(dollar_10)begin
            dollar_10_reg <= dollar_10; 
        end
        else begin
            dollar_10_reg <= 0;
        end
    end
end

//Buffer to save incoming tokens $50
always@(posedge clk)begin
    if(rst)begin
        dollar_50_reg <= 0;
    end
    else begin
        if(dollar_50)begin
            dollar_50_reg <= dollar_50; 
        end
        else begin
            dollar_50_reg <= 0;
        end
    end
end

// //switching counter input mux
// reg ten_or_fifty; // 0 is ten , 1 is fifty
// wire switch_from_10_to_50 = dollar_50_reg == 1 && ten_or_fifty == 0; 
// wire switch_from_50_to_10 = dollar_10_reg == 1 && ten_or_fifty == 1; 
// reg [5:0]cnt_50,cnt_10;
// //switching counter input muxed reg
// always @(posedge clk) begin
//     if(rst)begin
//         ten_or_fifty <= 0;
//     end
//     else if(switch_from_10_to_50)
//     begin
//         ten_or_fifty <= 1;
//     end
//     else if(switch_from_50_to_10)
//     begin
//         ten_or_fifty <= 0;
//     end
//     else
//     begin
//         ten_or_fifty <= ten_or_fifty; 
//     end
// end




//Mux + Register to store certain dollar signal.
always@(posedge clk)begin
    if(rst)begin
        Total_amount <= 0;
    end
    else begin
        Total_amount <=Total_amount;
    end
end
//10,50 put in
always@(posedge clk)begin
    if(rst)begin
        Total_amount <= 0;
    end
    else begin
        if(CS == IDLE)begin
            Total_amount <= Total_amount + cnt_10*10 + cnt_50*50;
        end
        else begin
            Total_amount <= Total_amount;
        end
    end
end

//Conf reg, new cycle to update selection signal
always@(posedge clk)begin
    if(rst)begin
        sel_saving_reg <= 0;
    end
    else begin
        if(Conf_sig == 1)begin
            sel_saving_reg <= item;
        end
        else begin
            sel_saving_reg <= sel_saving_reg;
        end
    end
end

//Price storing mux
always@(posedge clk)begin
    if(rst)begin
        price_out <= 0;
    end
    else begin
        if(CS == CONF)begin
            case(sel_saving_reg)
                00: //water 20$
                    price_out <= 20;
                01: //blacktea 20$
                    price_out <= 30;
                10: //coke 40$
                    price_out <= 40;
                11: //juice : 50$
                    price_out <= 50;
                default: // user not entering selection
                    price_out <= 0;
            endcase
        end
        else begin
            price_out <= price_out;
        end
    end
end

//price_out must be displayed.
always@(posedge clk)begin
    if(rst)begin
        price_out <= 0;
    end
    else begin
        if(dollar_50_reg)begin
            price <= price_out ;
        end
        else if(dollar_10_reg)begin
            price <= price_out;
        end
        else begin
            price <= price_out;
        end
    end
end


//ALU:Subtracter Price CAL1 //Q. This is combinational logic, How do I add in the "else begin"statement?

//Release selection
always@(*)begin
        if(CS == CHANGE)begin
            case(sel_saving_reg)
                0: //water
                    release_reg = 3'b100; 
                1: //black tea
                    release_reg = 3'b101;
                2: //coke
                    release_reg = 3'b110;
                3: //juice
                    release_reg = 3'b111;
                default:
                    release_reg = 3'b000;
            
            endcase
        end
        else begin
            release_reg = 0;
        end
end

//release reg
always@(posedge clk)begin
    if(rst)begin
        item_rels <= 0;
    end
    else begin
        item_rels <= release_reg;
    end
end

//Counter2 to start on Dispose
always@(posedge clk)begin
    if(rst)begin
        Total_amount <= 0;
    end
    else begin
        if(CS == CHANGE)begin
            if(Total_amount>0)begin
                Total_amount <= Total_amount - 10;
            end
            else begin
                Total_amount <= Total_amount;
            end
        end
        else begin
            Total_amount <= 0;
        end
    end           
end

//Dispose signal from cnt to generate coin signal
always@(posedge clk)begin
    if(CS == CHANGE)begin
        change_return <= 1;
    end
    else begin
        change_return <= 0;
    end
end
always@(*)begin
    assign price = price_out;
end

endmodule

//Q. How do I share the counter together? by using mux to rst counter everytime the sel changes?