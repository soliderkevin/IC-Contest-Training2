module Flash(clk,rst,in,out);
    input clk,rst,in;
    output out;
    reg out;
    wire[`SWIDTH-1:0] state,next;
    reg[`SWIDTH-1:0] next1;
    reg tload,tsel;
    wire done;

// instantiate state register
DFF #(`SWIDTH) state_reg(clk,next,state);

//instantiate timer: data path
Timer1 timer(clk,rst,tload,tsel,done);

    always@(*)
        begin
            case(state)
            `S_OFF:{out,tload,tsel,next1} =
                {1'b0,1'b1,1'b1,in?`S_A:`S_OFF};
            `S_A:{out,tload,tsel,next1} =
                {1'b1,done,1'b0,done?`S_B:`S_A};
            `S_B:{out,tload,tsel,next1} =
                {1'b0,done,1'b1,done ? `S_C:`S_B};
            `S_C:{out,tload,tsel,next1} =
                {1'b1,done,1'b0,done ? `S_D:`S_C};
            `S_D:{out,tload,tsel,next1} =
                {1'b0,done,1'b1,done ? `S_E:`S_D};
            `S_E:{out,tload,tsel,next1} =
                {1'b1,done,1'b1,done ? `S_OFF:`S_E};
            endcase
        end

    assign next = rst ? `S_OFF:next1;

endmodule


