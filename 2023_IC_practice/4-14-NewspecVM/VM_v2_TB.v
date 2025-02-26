module VM_v2_TB;
reg RST = 0,CLK= 1,SEL= 0 , DOLLAR_10= 0 , DOLLAR_50 = 0; 
reg[1:0] ITEM= 0 ; 
wire [7:0] VALUE;
wire [2:0] ITEM_RELS; 
wire CHANGE_RETURN; 
integer i; 
VM DUT(.clk(CLK), .rst(RST), .item(ITEM), .sel(SEL), .dollar_10(DOLLAR_10), .dollar_50(DOLLAR_50),.value(VALUE) , .item_rels(ITEM_RELS), .change_return(CHANGE_RETURN));
      
    initial begin
        CLK = 1;
        #5;
        for(i = 0 ; i<40 ; i = i+1)
        begin
            //RST
            RST = (i == 1 | i == 100) ? 1:0;
            //ITEM
            case(i)
                3: ITEM  = 1;
                4: ITEM  = 2;
                5: ITEM  = 3;
                15: ITEM = 1;
                18: ITEM = 3;
                25: ITEM = 2;
                26: ITEM = 3;
                27: ITEM = 2;
                default:
                ITEM = 0;
            endcase
            //SEL
            case(i)
                3: SEL  = 1;
                4: SEL  = 1;
                15: SEL = 1;
                26: SEL = 1;
                default:
                SEL = 0;
            endcase

            //DOLLAR_10
            case (i)
                6:DOLLAR_10 = 1;
                7:DOLLAR_10 = 1;
                8:DOLLAR_10 = 1;
                16:DOLLAR_10 = 1;
                17:DOLLAR_10 = 1;
                19:DOLLAR_10 = 1;
                27:DOLLAR_10 = 1;
                default:
                DOLLAR_10 = 0;
            endcase
            //DOLLAR_50
            case (i)
                8: DOLLAR_50  = 1;
                21 :DOLLAR_50 = 1;
                30: DOLLAR_50 = 1;
                default:
                DOLLAR_50 = 0;
            endcase
            #10;     
        end 
        
        #200;
        $finish;
    end

always 
begin
  #5;
  CLK = ~CLK;
end

endmodule